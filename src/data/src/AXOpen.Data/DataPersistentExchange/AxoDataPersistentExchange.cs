using AXOpen.Base.Data;
using AXSharp.Connector;

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
        /// Gets the list of collected group names from the tags grouped by their assigned groups.
        /// </summary>
        public List<string> CollectedGroups
        {
            get
            {
                return tagsInGroups.Keys.ToList();
            }
        }

        /// <summary>
        /// repository that stored tag values
        /// </summary>
        private IRepository<PersistentRecord> Repository;

        #region ReadWrite to/from controller/PLC

        /// <summary>
        /// Reads tags from the PLC for a given group.
        /// </summary>
        /// <param name="group">The name of the group to read tags for.</param>
        /// <returns>Returns true if the read operation is successful; otherwise, false.</returns>
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

        /// <summary>
        /// Writes a batch of tag values to the PLC.
        /// </summary>
        /// <param name="primitives">The list of primitive tags to write.</param>
        /// <returns>Returns true if the write operation is successful; otherwise, false.</returns>
        private async Task<bool> WriteTags(List<ITwinPrimitive> primitives)
        {
            await _root.GetConnector().WriteBatchAsync(primitives);
            return true;
        }

        #endregion ReadWrite to/from controller/PLC

        #region Main Handling Method - Read Write

        /// <summary>
        /// Writes a persistent group of tags from the repository to the PLC.
        /// </summary>
        /// <param name="group">The group name of the tags to be written.</param>
        /// <returns>Returns true if the write operation is successful; otherwise, false.</returns>
        public async Task<bool> WritePersistentGroupFromRepository(string group)
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

        /// <summary>
        /// Writes all persistent tags from the repository to the PLC.
        /// </summary>
        /// <param name="group">The group name of the tags to be written.</param>
        /// <returns>Returns true if the write operation is successful; otherwise, false.</returns>
        public async Task<bool> WriteAllPersistentGroupsFromRepositoryToPlc()
        {
            List<ITwinPrimitive> tagsToWrite = new List<ITwinPrimitive>();
            foreach (var groupName in this.CollectedGroups)
            {
                var recordFromRepo = Repository.Read(groupName);
                AddTagsFromRecordToWrittenList(tagsToWrite, recordFromRepo);
            }
            await WriteTags(tagsToWrite);
            return true;
        }

        private void AddTagsFromRecordToWrittenList(List<ITwinPrimitive> tagsToWrite, PersistentRecord recordFromRepo)
        {
            foreach (var tagFromRepo in recordFromRepo.Tags)
            {
                var ConnectedTags = allTags.Where(p => p.Symbol == tagFromRepo.Symbol);

                if (!ConnectedTags.Any()) continue;

                var ConnectedTag = ConnectedTags.First();

                if (ConnectedTag == null) continue;

                ConnectedTag.SetTagCyclicValue(tagFromRepo);

                tagsToWrite.Add(ConnectedTag);
            }
        }


        /// <summary>
        /// Updates a persistent group of tags to the repository after reading from the PLC.
        /// </summary>
        /// <param name="persistentGroupName">The group name of the persistent tags to be updated.</param>
        /// <returns>Returns true if the update operation is successful; otherwise, false.</returns>
        public async Task<bool> UpdatePersistentGroupFromPlcToRepository(string persistentGroupName)
        {
            await ReadTagsFromPlc(persistentGroupName);
            return UpdateReadedTagsToRepository(persistentGroupName);
        }

        private bool UpdateReadedTagsToRepository(string persistentGroupName)
        {

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


        /// <summary>
        /// Updates a persistent group of tags to the repository after reading from the PLC.
        /// </summary>
        /// <param name="persistentGroupName">The group name of the persistent tags to be updated.</param>
        /// <returns>Returns true if the update operation is successful; otherwise, false.</returns>
        public async Task<bool> UpdateAllPersistentGroupsToRepository()
        {
            await _root.GetConnector().ReadBatchAsync(allTags); // read all tags from PLC

            foreach (var groupName in this.CollectedGroups)
            {
                UpdateReadedTagsToRepository(groupName);
            }

            return true;
        }


        #endregion Main Handling Method - Read Write

        #region Data Exchange Implementation

        /// <summary>
        /// Initializes the remote data exchange by setting up the persistent root object and repository.
        /// </summary>
        /// <param name="persistetnRootObject">The root object for the data exchange.</param>
        /// <param name="repository">The repository to store the persistent records.</param>
        public async Task InitializeRemoteDataExchange(ITwinObject persistetnRootObject, IRepository<PersistentRecord> repository)
        {
            this._root = persistetnRootObject;
            Repository = repository;

            this.CollectPersistentTags(this._root);

            await InitializeRemoteDataExchange();
        }

        /// <summary>
        /// Performs the actual initialization of the remote data exchange.
        /// </summary>
        public async Task InitializeRemoteDataExchange()
        {
            Operation.InitializeExclusively(Handle);
            //await this.WriteAsync();
        }

        /// <summary>
        /// Deinitializes the remote data exchange.
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
                    await this.UpdatePersistentGroupFromPlcToRepository(identifier);
                    break;

                case ePersistentOperation.ReadAll:
                    await this.WriteAllPersistentGroupsFromRepositoryToPlc();
                    break;

                case ePersistentOperation.UpdateAll:
                    await this.UpdateAllPersistentGroupsToRepository();
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

        #endregion Data Exchange Implementation

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