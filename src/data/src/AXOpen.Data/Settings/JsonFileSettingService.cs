using Newtonsoft.Json;

namespace AXOpen.Data
{
    public abstract class JsonFileSettingService<DATA> : ISettingService<DATA> where DATA : IDataSettingsBase
    {
        private const string jsonPostfirx = ".json";

        //private string SerializationPath;

        private object _SyncFile = new object();

        public JsonFileSettingService(string DocumentName, string SettingsFolderName = "Settings")
        {
            this.JsonDocumentName = DocumentName + jsonPostfirx;
            Data = (DATA)System.Activator.CreateInstance<DATA>();
            this.Load();
        }

        public string JsonDocumentName { get; set; }

        private string _SettingFolderName = "Settings";

        public string SettingFolderName
        {
            get { return _SettingFolderName; }
            protected set { _SettingFolderName = value; }
        }

        private string _FolderSettings;

        protected string FolderSettings
        {
            get
            {
                if (_FolderSettings == null)
                {
                    _FolderSettings = Path.Combine(AppContext.BaseDirectory, SettingFolderName);
                }
                return _FolderSettings;
            }
        }

        private string _PathWithDocumentName;

        public string PathWithDocumentName
        {
            get
            {
                if (_PathWithDocumentName == null)
                {
                    _PathWithDocumentName = Path.Combine(FolderSettings, JsonDocumentName);
                }
                return this._PathWithDocumentName;
            }
        }

        public DATA Data { get; set; }

        public string SettingsSourceName { get; protected set; }

        public void CreatePath(string folderPath)
        {
            if (!System.IO.Directory.Exists(System.IO.Path.GetDirectoryName(PathWithDocumentName)))
            {
                System.IO.Directory.CreateDirectory(System.IO.Path.GetDirectoryName(PathWithDocumentName));
            }
        }

        public void Save()
        {
            this.CreatePath(PathWithDocumentName);
            Save(PathWithDocumentName);
        }

        public void Load()
        {
            this.CreatePath(PathWithDocumentName);

            if (!System.IO.File.Exists(PathWithDocumentName))
            {
                Data.SettingsName = "default";
                Save(PathWithDocumentName);
            }

            Load(PathWithDocumentName);
        }

        public void Save(string fileName)
        {
            if (!string.IsNullOrEmpty(fileName))
            {
                JsonSerializerSettings settings = new JsonSerializerSettings
                {
                    TypeNameHandling = TypeNameHandling.All,
                    ObjectCreationHandling = ObjectCreationHandling.Replace
                };
                lock (this._SyncFile)
                {
                    using (var swr = new System.IO.StreamWriter(fileName))
                    {
                        Data.Updated = DateTime.Now;
                        string output = JsonConvert.SerializeObject(Data, settings);
                        swr.Write(output);
                    }
                }
            }
            else
            {
                Console.WriteLine("Unable to save data object due to path is empty");
                return;
            }
        }

        public void Load(string fileName)
        {
            this.CreatePath(fileName);

            if (!System.IO.File.Exists(fileName))
            {
                Save(fileName);
            }

            JsonSerializerSettings settings = new JsonSerializerSettings
            {
                TypeNameHandling = TypeNameHandling.All,
                ObjectCreationHandling = ObjectCreationHandling.Replace
            };

            lock (this._SyncFile)
            {
                using (var sr = new System.IO.StreamReader(fileName))
                {
                    string input = sr.ReadToEnd().ToString();

                    DATA readValue = JsonConvert.DeserializeObject<DATA>(input, settings);

                    if (readValue == null) return;

                    foreach (var item in readValue.GetType().GetProperties())
                    {
                        System.Reflection.PropertyInfo prop = readValue.GetType().GetProperty(item.Name, System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Instance);
                        if (null != prop && prop.CanWrite)
                        {
                            prop.SetValue(Data, item.GetValue(readValue, null), null);
                        }
                    }
                }
            }
        }
    }
}