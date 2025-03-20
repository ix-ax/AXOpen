namespace AXOpen.Data
{
    
    /// <summary>
    /// Represents the configuration for a column in a data grid or similar UI component.
    /// </summary>
    public class ColumnDataContent
    {
        /// <summary>
        /// Gets or sets the display name of the column.
        /// </summary>
        public string ColumnName { get; set; }

        /// <summary>
        /// Gets or sets the binding path for the column's value.
        /// This should correspond to the property name in the data source to enable proper data binding.
        /// </summary>
        public string BindingValuePath { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether clicking on the column item will trigger a detailed view.
        /// </summary>
        public bool ClickEnabled { get; set; }
       
        //public  PresentableConverter { get; set; }
    }
}