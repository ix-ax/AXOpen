using AXOpen.Core.Interfaces;
using AXOpen.Data;
using AXSharp.Presentation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core.ViewModels
{
    public class DataExchangeBaseViewModel : RenderableViewModelBase
    {
        public IDataViewModel DataViewModel
        {
            get;
            private set;
        }
        public override object Model
        {
            get => this.DataViewModel.DataExchange;
            set
            {
                CreateBrowsable((AxoDataExchange)value);
            }
        }


        private void CreateBrowsable(AxoDataExchange dataExchangeObject)
        {
            try
            {
                var properties = dataExchangeObject.GetType().GetProperties();
                PropertyInfo? DataPropertyInfo = null;

                // iterate properties and look for DataEntityAttribute
                foreach (var prop in properties)
                {
                    var attr = prop.GetCustomAttribute<DataEntityAttribute>();
                    if (attr != null)
                    {
                        //if already set, that means multiple dataatributtes are present, we want to throw error
                        if(DataPropertyInfo != null)
                        {
                            throw new MultipleDataEntityAttributeException($"{dataExchangeObject.GetType().ToString()} contains multiple {nameof(DataEntityAttribute)}s! Make sure it contains only one.");
                        }
                        DataPropertyInfo = prop;
                        break;
                    }
                }

                // if not found, throw exception
                if (DataPropertyInfo == null)
                {
                    throw new DataEntityAttributeNotFoundException($"{ dataExchangeObject.GetType().ToString()} must implement member, which inherits from {nameof(AxoDataEntity)} and is annotated with {nameof(DataEntityAttribute)}.");
                }

                //// if is not sublass of DataEntity, throw exception
                if (!DataPropertyInfo.PropertyType.IsSubclassOf(typeof(AxoDataEntity)))
                {
                    throw new Exception($"Data object must inherits from DataEntity!");
                }


                var dataOfType = DataPropertyInfo.PropertyType.Name;
                var dataNameSpace = DataPropertyInfo.PropertyType.Namespace;
                var dataAssembly = DataPropertyInfo.PropertyType.Assembly.ManifestModule.Name;
                if (dataAssembly.LastIndexOf(".") >= 0)
                    dataAssembly = dataAssembly.Substring(0, dataAssembly.LastIndexOf("."));


                MethodInfo method = typeof(IxDataViewModelCreator).GetMethod("Create");
                var genericTypeNamePoco = $"Pocos.{dataNameSpace}.{dataOfType}, {dataAssembly}";
                var genericTypePoco = Type.GetType(genericTypeNamePoco);
                var genericTypeNameBase = $"{dataNameSpace}.{dataOfType}, {dataAssembly}";
                Type genericTypeBase = Type.GetType(genericTypeNameBase);

                if (genericTypePoco == null || genericTypeBase == null)
                {
                    throw new Exception($"Could not retrieve {genericTypeNamePoco} or {genericTypeNameBase} when creating browsable object.");
                }

                MethodInfo generic = method.MakeGenericMethod(genericTypePoco, genericTypeBase);
                DataViewModel = (IDataViewModel)generic.Invoke(null, new object[] { dataExchangeObject.GetRepository(), dataExchangeObject });

            }
            catch
            {
                throw;//new BrowsableObjectCreationException("Unable to create browsable object for the view. For details see inner exception.", ex);
            }

        }
    }
}
