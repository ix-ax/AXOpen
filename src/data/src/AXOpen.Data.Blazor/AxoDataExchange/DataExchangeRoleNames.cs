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
        public static IEnumerable<Role> GetRoles()
        {
            return new List<Role>
            {
                new Role(DataExchangeRoleNames.can_data_item_create),
                new Role(DataExchangeRoleNames.can_data_item_edit),
                new Role(DataExchangeRoleNames.can_data_item_copy),
                new Role(DataExchangeRoleNames.can_data_item_delete),
                new Role(DataExchangeRoleNames.can_data_send_to_plc),
                new Role(DataExchangeRoleNames.can_data_load_from_plc),
                new Role(DataExchangeRoleNames.can_data_export),
                new Role(DataExchangeRoleNames.can_data_import),
                new Role(DataExchangeRoleNames.can_data_filter_advanced),
            };
        }
        
        public const string can_data_item_create = nameof(can_data_item_create);
        public const string can_data_item_edit = nameof(can_data_item_edit);
        public const string can_data_item_copy = nameof(can_data_item_copy);
        public const string can_data_item_delete = nameof(can_data_item_delete);

        public const string can_data_send_to_plc = nameof(can_data_send_to_plc);
        public const string can_data_load_from_plc = nameof(can_data_send_to_plc);

        public const string can_data_export = nameof(can_data_export);
        public const string can_data_import = nameof(can_data_import);

        public const string can_data_filter_advanced = nameof(can_data_filter_advanced);

    }
}