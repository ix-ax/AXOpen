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
            return new []
            {
                new Role(nameof(can_data_item_create)),
                new Role(nameof(can_data_item_edit)),
                new Role(nameof(can_data_item_copy)),
                new Role(nameof(can_data_item_delete)),

                new Role(nameof(can_data_send_to_plc)),
                new Role(nameof(can_data_load_from_plc)),
                new Role(nameof(can_data_update_from_plc)),

                new Role(nameof(can_data_export)),
                new Role(nameof(can_data_import)),

                new Role(nameof(can_data_filter_advanced)),
            };
        }
        // insert all new role names in the middle of documentation tag
        //<DataExchangeRoleNames>

        public static IEnumerable<Role> GetRoles()
        {
            return new List<Role>
            {
                new Role(can_data_item_create),
                new Role(can_data_item_edit),
                new Role(can_data_item_copy),
                new Role(can_data_item_delete),

                new Role(can_data_send_to_plc),
                new Role(can_data_load_from_plc),
                new Role(can_data_update_from_plc),

                new Role(can_data_export),
                new Role(can_data_import),

                new Role(can_data_filter_advanced)
            };
        }
        
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