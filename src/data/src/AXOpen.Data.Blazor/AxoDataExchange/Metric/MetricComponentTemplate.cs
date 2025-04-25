using Microsoft.AspNetCore.Components;
using System.ComponentModel.DataAnnotations;

namespace AXOpen.Data
{
    public class MetricComponentTemplate<T> : ComponentBase, IMetricComponentTemplate
    {
        [Parameter]
        public List<T> Data { set; get; } = new List<T>();

        public Type ItemResultType { get => typeof(T); }

    }

    public interface IMetricComponentTemplate
    {
        Type ItemResultType { get; }
    }
   

}