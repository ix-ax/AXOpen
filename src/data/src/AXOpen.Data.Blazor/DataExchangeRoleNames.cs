using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AxOpen.Security.Entities;


namespace AXOpen.Data
{
    public static class DataExchangeRoleNames
    {
        // insert all new role names in the middle of documentation tag
        //<DataExchangeRoleNames>

        public const string can_data_item_create = nameof(can_data_item_create);
        public const string can_data_item_edit = nameof(can_data_item_edit);
        public const string can_data_item_copy = nameof(can_data_item_copy);
        public const string can_data_item_delete = nameof(can_data_item_delete);

        public const string can_data_send_to_plc = nameof(can_data_send_to_plc);
        public const string can_data_load_from_plc = nameof(can_data_load_from_plc);
        public const string can_data_update_from_plc = nameof(can_data_update_from_plc);

        public const string can_data_export = nameof(can_data_export);
        public const string can_data_import = nameof(can_data_import);

        public const string can_data_filter_advanced = nameof(can_data_filter_advanced);

        //</DataExchangeRoleNames>
    }
}