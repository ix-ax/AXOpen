using AXSharp.Connector;

namespace AXOpen.Core
{
    public static class AxoStepHelper
    {
        public static string Description(AxoStep step)
        {
            var text = string.IsNullOrEmpty(step.StepDescription.Cyclic)
                ? step.Order.Cyclic.ToString()
                : step.StepDescription.GetCyclic();

            if (step.IsActive.Cyclic)
            {
                return $"{text}";
            }

            return text;
        }

        public static string StepRowColor(AxoStep step)
        {
            switch ((eAxoTaskState)step.Status.Cyclic)
            {
                case eAxoTaskState.Disabled:
                    return "bg-secondary text-white";
                case eAxoTaskState.Ready:
                    return "bg-primary text-white";
                case eAxoTaskState.Kicking:
                    return "bg-light text-dark";
                case eAxoTaskState.Busy:
                    return "bg-warning text-dark";
                case eAxoTaskState.Done:
                    return "bg-success text-white";
                case eAxoTaskState.Error:
                    return "bg-danger text-white";
                default:
                    return "bg-white text-dark";
            }
        }

        public static void GetPrimitivesDescription(this AxoStep step, IList<ITwinPrimitive> ListOfPrimitives)
        {
            ListOfPrimitives.Add(step.StepDescription);
            ListOfPrimitives.Add(step.StartTimeStamp);
        }

        public static void GetPrimitivesDescriptionErrorDetails(this AxoStep step, IList<ITwinPrimitive> ListOfPrimitives )
        {
            ListOfPrimitives.Add(step.StepDescription); 
            ListOfPrimitives.Add(step.ErrorDetails); 
        }

        public static void GetPrimitivesDurationStatus(this AxoStep step, IList<ITwinPrimitive> ListOfPrimitives)
        {
            ListOfPrimitives.Add(step.Status);
            ListOfPrimitives.Add(step.Duration);
            ListOfPrimitives.Add(step.StartTimeStamp);
        }

    }
}
