using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Controls;

namespace AXOpen.Core
{
    public static class AxoSequncerHelper
    {

        public static IList<ITwinPrimitive> GetStepsOrderElements(this IEnumerable<AxoStep> steps)
        {
            List<ITwinPrimitive> activeProperties = new();

            foreach (AxoStep step in steps)
            {
                activeProperties.Add(step.Order);
            }

            return activeProperties;
        }


        //public static void UpdateValuesOnChangePrimitives(this AxoSequencer sequencer,  IList<ITwinPrimitive> ListOfPrimitives)
        //{
        //    throw new NotImplementedException();
        //}
    }
}
