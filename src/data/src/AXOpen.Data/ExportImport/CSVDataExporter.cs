using AXOpen.Base.Data;
using AXSharp.Connector;
using AXSharp.Connector.ValueTypes;
using AXSharp.Connector.ValueTypes.Online;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;


namespace AXOpen.Data
{
    public class CSVDataExporter<TPlain, TOnline> : IDataExporter<TPlain, TOnline> where TOnline : IAxoDataEntity
    where TPlain : Pocos.AXOpen.Data.IAxoDataEntity, new()
    {
        public CSVDataExporter()
        {
        }

        public void Export(IRepository<TPlain> repository, string path, Expression<Func<TPlain, bool>> expression, char separator = ';')
        {            
            var prototype = Activator.CreateInstance(typeof(TOnline), new object[] { ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(new object[] { }), "_data", "_data" }) as ITwinObject;
            
            
            var exportables = repository.Queryable.Where(expression);
            var itemExport = new StringBuilder();
            var export = new List<string>();

            // Create header
            var valueTags = prototype.RetrievePrimitives();
            foreach (var valueTag in valueTags)
            {
                itemExport.Append($"{valueTag.Symbol}{separator}");
            }

            export.Add(itemExport.ToString());
            itemExport.AppendLine();

            itemExport.Clear();
            foreach (var valueTag in valueTags)
            {
                itemExport.Append($"{valueTag.HumanReadable}{separator}");
            }

            export.Add(itemExport.ToString());
            itemExport.AppendLine();


            foreach (var document in exportables)
            {
                itemExport.Clear();
                ((dynamic)prototype).PlainToShadow(document);
                var values = prototype.RetrievePrimitives();
                foreach (var @value in values)
                {
                    var val = (string)(((dynamic)@value).Shadow.ToString());
                    if (val.Contains(separator))
                    {
                        val = val.Replace(separator, '►');
                    }

                    itemExport.Append($"{val}{separator}");
                }

                export.Add(itemExport.ToString());

            }

            using (var sw = new StreamWriter(path + ".csv"))
            {
                foreach (var item in export)
                {
                    sw.Write(item + "\r");
                }
            }
        }

        public void Import(IRepository<TPlain> dataRepository, string path, ITwinObject crudDataObject = null, char separator = ';')
        {
            var imports = new List<string>();
            foreach (var item in File.ReadAllLines(path + ".csv"))
            {
                imports.Add(item);
            }

            var documents = imports.ToArray();
            var header = documents[0];

            var headerItems = header.Split(separator);
            var dictionary = new List<ImportItems>();

            ITwinObject prototype;

            if (crudDataObject == null)
                prototype = Activator.CreateInstance(typeof(TOnline), new object[] { ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(new object[] { }), "_data", "_data" }) as ITwinObject;
            else
                prototype = crudDataObject;

            var valueTags = prototype.RetrievePrimitives();

            // Get headered dictionary
            foreach (var headerItem in headerItems)
            {
                dictionary.Add(new ImportItems() { Key = headerItem });
            }


            // Load values
            for (int i = 2; i < documents.Count(); i++)
            {
                var documentItems = documents[i].Split(separator);
                for (int a = 0; a < documentItems.Count(); a++)
                {
                    dictionary[a].Value = documentItems[a];
                }

                UpdateDocument(dataRepository, dictionary, valueTags, prototype);
            }
        }

        private void UpdateDocument(IRepository<TPlain> dataRepository, List<ImportItems> dictionary, IEnumerable<ITwinPrimitive> valueTags, ITwinObject prototype)
        {
            string id = dictionary.FirstOrDefault(p => p.Key.Contains("DataEntityId")).Value;
            var existing = dataRepository.Queryable.Where(p => p.DataEntityId == id).FirstOrDefault();
            if (existing != null)
            {
                ((dynamic)prototype).PlainToShadow(existing);
            }

            ((dynamic)prototype).DataEntityId.Shadow = id;

            if (existing != null) ((dynamic)prototype).ChangeTracker.StartObservingChanges();
            // Swap values to shadow
            foreach (var item in dictionary)
            {
                if (!string.IsNullOrEmpty(item.Key))
                {
                    var tag = valueTags.FirstOrDefault(p => p.Symbol == item.Key);

                    if (tag == null)
                    {
                        continue; // not exist!
                    }

                    OnlinerBase type = tag as OnlinerBase;

                    if (type is OnlinerString || type is OnlinerWString)
                    {
                        ((dynamic)tag).Shadow = (CastValue(type, item.Value) as string)?.Replace('►', ';');
                    }
                    else
                    {
                        ((dynamic)tag).Shadow = CastValue(type, item.Value);
                    }
                }
            }

            if (existing != null) ((dynamic)prototype).ChangeTracker.StopObservingChanges();


            if (existing != null)
            {
                ((dynamic)prototype).ChangeTracker.Import(existing);

                //((dynamic)existing).ShadowToPlain((dynamic)prototype);
                existing = existing.ShadowToPlain1<TPlain>(prototype);
                dataRepository.Update(existing.DataEntityId, existing);
            }
            else
            {
                TPlain newRecord = new TPlain();
                ((dynamic)prototype).ChangeTracker.Import(newRecord);
                //((dynamic)newRecord).ShadowToPlain((dynamic)prototype);
                newRecord = newRecord.ShadowToPlain1<TPlain>(prototype);

                Task.Delay(1000).Wait();

                dataRepository.Create(newRecord.DataEntityId, newRecord);
            }
        }

        private class ImportItems
        {
            internal string Key { get; set; }
            internal dynamic Value { get; set; }
        }

        private dynamic CastValue(OnlinerBase type, string @value)
        {
            switch (type)
            {
                case OnlinerBool c:
                    return bool.Parse(@value);
                case OnlinerByte c:
                    return byte.Parse(@value);

                case OnlinerDate c:
                    return DateTime.Parse(@value);

                case OnlinerDInt c:
                    return int.Parse(@value);

                case OnlinerDWord c:
                    return uint.Parse(@value);

                case OnlinerInt c:
                    return short.Parse(@value);

                case OnlinerLInt c:
                    return long.Parse(@value);

                case OnlinerLReal c:
                    return double.Parse(@value);

                case OnlinerLTime c:
                    return TimeSpan.Parse(@value);

                case OnlinerLWord c:
                    return ulong.Parse(@value);

                case OnlinerReal c:
                    return float.Parse(@value);

                case OnlinerSInt c:
                    return sbyte.Parse(@value);

                case OnlinerString c:
                    return @value;

                case OnlinerTime c:
                    return TimeSpan.Parse(@value);

                case OnlinerTimeOfDay c:
                    return TimeSpan.Parse(@value);

                case OnlinerDateTime c:
                    return DateTime.Parse(@value);

                case OnlinerUDInt c:
                    return uint.Parse(@value);

                case OnlinerUInt c:
                    return ushort.Parse(@value);

                case OnlinerULInt c:
                    return ulong.Parse(@value);

                case OnlinerUSInt c:
                    return byte.Parse(@value);

                case OnlinerWord c:
                    return ushort.Parse(@value);

                case OnlinerWString c:
                    return @value;
                default:
                    throw new Exception($"Unknown type {type.GetType()}");

            }
        }
    }
}
