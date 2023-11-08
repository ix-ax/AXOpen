using AXOpen.Base.Data;
using AXSharp.Connector;
using System;
using System.Collections.Generic;

namespace AXOpen.Data
{
    public partial class AxoDataPersistentExchange
    {

        /// <summary>
        /// ROOT OBJECT 
        /// </summary>
        private ITwinObject _root;

        /// <summary>
        /// tracked all persistent tagss
        /// </summary>
        private List<ITwinPrimitive> allTags = new();

        /// <summary>
        /// tags sorted in groups
        /// </summary>
        private Dictionary<string, List<ITwinPrimitive>> tagsInGroups = new();

        /// <summary>
        /// repository that stored tag values
        /// </summary>
        private IRepository<PersistentRecord> Repository;

        #region ReadWrite to/from controller/PLC

        private async Task<bool> ReadTagsFromPlc(string group)
        {
            var tagsToRead = tagsInGroups[group];
            if (tagsToRead != null)
            {
                await _root.GetConnector().ReadBatchAsync(tagsToRead);
                return true;
            }
            else
            {
                return false;
            }
        }

        private async Task<bool> WriteTags(List<ITwinPrimitive> primitives)
        {
            await _root.GetConnector().WriteBatchAsync(primitives);
            return true;
        }

        #endregion ReadWrite to/from controller/PLC

        #region Main Handling Method - Read Write
        private async Task<bool> WritePersistentGroupFromRepository(string group)
        {
            var recordFromRepo = Repository.Read(group);

            List<ITwinPrimitive> tagsToWrite = new List<ITwinPrimitive>();

            foreach (var tagFromRepo in recordFromRepo.Tags)
            {
                var ConnectedTags = allTags.Where(p => p.Symbol == tagFromRepo.Symbol);

                if (!ConnectedTags.Any()) continue;

                var ConnectedTag = ConnectedTags.First();

                if (ConnectedTag == null) continue;

                ConnectedTag.SetTagCyclicValue(tagFromRepo);

                tagsToWrite.Add(ConnectedTag);
            }

            await WriteTags(tagsToWrite);
            return true;
        }

        private async Task<bool> UpdatePersistentGroupToRepository(string persistentGroupName)
        {
            await ReadTagsFromPlc(persistentGroupName);

            var primitivesTagsInGroup = tagsInGroups[persistentGroupName];

            if (primitivesTagsInGroup == null)
                return false;

            List<TagObject> NewTagValues = new List<TagObject>();

            foreach (var tag in primitivesTagsInGroup)
            {
                var t = tag.AsNewTagObject();

                NewTagValues.Add(t);
            }

            bool exist = Repository.Exists(persistentGroupName);

            if (exist)
            {
                var recordFromRepository = Repository.Read(persistentGroupName);

                foreach (var newtagValue in NewTagValues)
                {
                    var TagsFromRepository = recordFromRepository.Tags.Where(p => p.Symbol == newtagValue.Symbol);

                    if (TagsFromRepository.Count() != 1)    
                    {
                        recordFromRepository.Tags.RemoveAll(t => t.Symbol == newtagValue.Symbol);
                        recordFromRepository.Tags.Add(newtagValue);
                        continue;
                    }

                    var tagFromRepository = TagsFromRepository.First();

                    if (tagFromRepository.Value == null)
                    {
                        tagFromRepository.Value = newtagValue.Value;
                    }
                    else
                    {
                        Type repotype = tagFromRepository.Value.GetType();
                        Type tagtype = newtagValue.Value.GetType();

                        if (repotype == tagtype)
                        {
                            tagFromRepository.Value = newtagValue.Value;
                        }
                        else
                        {
                            recordFromRepository.Tags.Remove(tagFromRepository);
                            recordFromRepository.Tags.Add(newtagValue);
                        }
                    }
                }

                Repository.Update(persistentGroupName, recordFromRepository);
            }
            else
            {
                Repository.Create(persistentGroupName, new PersistentRecord()
                {
                    DataEntityId = persistentGroupName,
                    Tags = NewTagValues
                });
            }

            return true;
        }
        #endregion

        #region Data Exchange Implementation

        /// <summary>
        ///     Initializes data exchange between remote controller and this <see cref="AxoDataExchange{TOnline,TPlain}" />
        /// </summary>
        /// <param name="repository">Repository to be associated with this <see cref="AxoDataExchange{TOnline,TPlain}" /></param>
        public async Task InitializeRemoteDataExchange(ITwinObject persistetnRootObject, IRepository<PersistentRecord> repository)
        {
            this._root = persistetnRootObject;
            Repository = repository;

            this.CollectPersistentTags(this._root);

            await InitializeRemoteDataExchange();
        }

        /// <summary>
        ///     Initializes data exchange between remote controller and this <see cref="AxoDataExchange{TOnline,TPlain}" />
        /// </summary>
        public async Task InitializeRemoteDataExchange()
        {
            Operation.InitializeExclusively(Handle);
            //await this.WriteAsync();
        }

        /// <summary>
        ///     Terminates data exchange between controller and this <see cref="AxoDataExchange{TOnline,TPlain}" />
        /// </summary>
        public async Task DeInitializeRemoteDataExchange()
        {
            Operation.DeInitialize();
            //await this.WriteAsync();
        }

        private async Task Handle()
        {
            await Operation.ReadAsync();
            var operation = (ePersistentOperation)Operation.CrudOperation.LastValue;
            var identifier = Operation.DataEntityIdentifier.LastValue;
            if (string.IsNullOrEmpty(identifier))
            {
                identifier = "default"; // default persistent group
            }

            switch (operation)
            {
                case ePersistentOperation.Read:
                    await this.WritePersistentGroupFromRepository(identifier);
                    break;

                case ePersistentOperation.Update:
                    await this.UpdatePersistentGroupToRepository(identifier);
                    break;

                case ePersistentOperation.EntityExist:
                    var result = await this.RemoteEntityExist(identifier);
                    await Operation._exist.SetAsync(result);
                    break;

                default:
                    throw new ArgumentOutOfRangeException();
            }
        }

        /// <inheritdoc />
        public async Task<bool> RemoteRead(string identifier)
        {
            try
            {
                var record = Repository.Read(identifier);
                this.WritePersistentGroupFromRepository(identifier);

                return true;
            }
            catch (Exception exception)
            {
                throw;
            }
        }

        /// <inheritdoc />
        public async Task<bool> RemoteEntityExist(string identifier)
        {
            return Repository.Exists(identifier);
        }

        #endregion dataExchangeImplementation

        #region Collect persistent tags

        private void CollectPersistentTags(ITwinElement member)
        {
            AddPersistentMember(member);
        }

        private void AddPersistentMember(ITwinElement member)
        {
            if (member.HasAttribute<PersistentAttribute>())
            {
                if (member is ITwinPrimitive)
                {
                    InsertPersistentPrimitive(member as ITwinPrimitive);
                }
                else
                {
                    InsertPersistentMember(member as ITwinObject);
                }
            }
            if (member is ITwinObject)
            {
                foreach (var item in (member as ITwinObject).GetKids())
                {
                    AddPersistentMember(item);
                }
            }
        }

        private void InsertPersistentMember(ITwinObject member)
        {
            var toGroups = member.GetAttribute<PersistentAttribute>().Groups;

            var alltags = member.RetrievePrimitives();

            foreach (var item in alltags)
            {
                InsertPersistentPrimitive(item, toGroups);
            }
        }

        private void InsertPersistentPrimitive(ITwinPrimitive primitive)
        {
            InsertPersistentPrimitive(primitive, primitive.GetAttribute<PersistentAttribute>().Groups);
        }

        private void InsertPersistentPrimitive(ITwinPrimitive primitive, IEnumerable<string> toGroups)
        {
            foreach (var toGroup in toGroups)
            {
                if (tagsInGroups.TryGetValue(toGroup, out List<ITwinPrimitive> list))
                {
                    list.Add(primitive);
                    allTags.Add(primitive);
                }
                else
                {
                    tagsInGroups[toGroup] = new List<ITwinPrimitive> { primitive };
                    allTags.Add(primitive);
                }
            }
        }

        #endregion Collect persistent tags
    }
}