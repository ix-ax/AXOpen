using AXOpen.Messaging.Static;
using AXSharp.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Components.Cognex.Vision
{
    public partial class AxoVisionProNetSpecificDataContainer<TOnline, TPlain> where TOnline : AxoVisionProNetSpecificData
    where TPlain : Pocos.AXOpen.Components.Cognex.Vision.AxoVisionProNetSpecificData//, new()
    {
        partial void PostConstruct(ITwinObject parent, string readableTail, string symbolTail)
        {
            
        }

       
        private TOnline _onlineData;
        public TOnline OnlineData
        {
            get
            {
                if (_onlineData == null) _onlineData = (TOnline)GetDataSetProperty<AxoVisionProNetAttribute>();

                return _onlineData;
            }
        }

        public async Task<TPlain> GetPlainDataAsync(eAccessPriority priority = eAccessPriority.Normal) 
        {
            var onlineData = OnlineData;
            return await onlineData.OnlineToPlain<TPlain>(priority);
        }

        public async Task<(TOnline Online, TPlain Plain)> GetDataAsync(eAccessPriority priority = eAccessPriority.Normal)
        {
            var onlineData = OnlineData;
            var plainData = await onlineData.OnlineToPlain<TPlain>(priority);
            return (onlineData, plainData);
        }

        public async Task PlainToOnlineAsync(TPlain plain, eAccessPriority priority = eAccessPriority.Normal)
        {
            var onlineData = OnlineData;
            await onlineData.PlainToOnline(plain, priority);
        }

        private AxoVisionProNetSpecificData? GetDataSetProperty<TA>() where TA : Attribute
        {
            var dataObjectPropertyInfo = GetDataSetPropertyInfo<TA>();
            var dataObject = dataObjectPropertyInfo?.GetValue(this) as AxoVisionProNetSpecificData;
            if (dataObject == null)
                throw new Exception(
                    $"Data member annotated with '{nameof(TA)}' in '{Symbol}'  does not inherit from '{nameof(AxoVisionProNetSpecificData)}'");

            return dataObject;
        }

        private PropertyInfo? GetDataSetPropertyInfo<TA>() where TA : Attribute
        {
            var properties = GetType().GetProperties();
            PropertyInfo? DataPropertyInfo = null;

            // iterate properties and look for AxoDataEntityAttribute
            foreach (var prop in properties)
            {
                var attr = prop.GetCustomAttribute<TA>();
                if (attr != null)
                {
                    //if already set, that means multiple data attributes are present, we want to throw error
                    if (DataPropertyInfo != null)
                        throw new Exception(
                            $"{GetType()} contains multiple {nameof(TA)}s! Make sure it contains only one.");
                    DataPropertyInfo = prop;
                    break;
                }
            }

            if (DataPropertyInfo == null)
                throw new Exception($"There is no member annotated with '{nameof(AxoVisionProNetAttribute)}' in '{Symbol}'.");

            return DataPropertyInfo;
        }

        

    }

    
}
