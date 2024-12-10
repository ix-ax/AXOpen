using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PlcSimAdvancedStarterTool.DTOs
{
    public class EditableItem
    {
        public string CuName { get; set; }
        public string DeclarationLocation { get; set; }
        public string AttributeDeclaration { get; set; }
        public string ComponentType { get; set; }
        public string MethodName { get; set; }
        public string MethodCall { get; set; }

        public EditableItem(
            string cuName,
            string declarationLocation,
            string attributeDeclaration,
            string componentType,
            string methodName,
            string methodCall)
        {
            CuName = cuName ?? throw new ArgumentNullException(nameof(cuName));
            DeclarationLocation = declarationLocation ?? throw new ArgumentNullException(nameof(declarationLocation));
            AttributeDeclaration = attributeDeclaration ?? throw new ArgumentNullException(nameof(attributeDeclaration));
            ComponentType = componentType ?? throw new ArgumentNullException(nameof(componentType));
            MethodName = methodName ?? throw new ArgumentNullException(nameof(methodName));
            MethodCall = methodCall ?? throw new ArgumentNullException(nameof(methodCall));
        }
    }
}
