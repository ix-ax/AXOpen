using System.Reflection;

namespace Ix.Connector
{
    public static class ITwinElementExtensions
    {
        public static PropertyInfo GetPropertyViaSymbol(this ITwinElement twinObject)
        {
            if (twinObject == null) return null;
            var propertyName = string.Join("", twinObject.GetSymbolTail().TakeWhile(p => !p.Equals('.')));

            if (twinObject.Symbol == null)
                return null;

            if (twinObject.Symbol.EndsWith("]"))
            {
                propertyName = propertyName?.Substring(0, propertyName.IndexOf('[') - 1);
            }

            var propertyInfo = twinObject?.GetParent()?.GetType().GetProperty(propertyName);

            return propertyInfo;
        }
        public static T GetAttribute<T>(this ITwinElement twinObject) where T : Attribute
        {
            if (twinObject == null) return null;

            try
            {
                var propertyInfo = GetPropertyViaSymbol(twinObject);
                if (propertyInfo != null)
                {
                    if (propertyInfo.GetCustomAttributes().FirstOrDefault(p => p is T) is T propertyAttribute)
                    {
                        return propertyAttribute;
                    }
                }

                if (twinObject
                    .GetType()
                    .GetCustomAttributes(true)
                    .FirstOrDefault(p => p is T) is T typeAttribute)
                {
                    return typeAttribute;
                }
            }
            catch (Exception)
            {
                //throw;
            }

            return null;
        }
    }
}

