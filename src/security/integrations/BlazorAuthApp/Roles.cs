using AxOpen.Security;

namespace BlazorAuthApp
{
    public static class Roles
    {
        public static List<Role> CreateRoles()
        {
            var roles = new List<Role>
            {
                new Role(process_settings_access),
                new Role(process_traceability_access),
                new Role(can_user_open_technological_settings),
                new Role(ground_position_start),
                new Role(automat_start),
                new Role(station_details),
                new Role(technology_settings_access),
                new Role(manual_start),
                new Role(sequencer_step),
                new Role(technology_automat_all),
                new Role(technology_ground_all)
            };

            return roles;
        }

        public const string process_settings_access = nameof(process_settings_access);
        public const string process_traceability_access = nameof(process_traceability_access);
        public const string can_user_open_technological_settings = nameof(can_user_open_technological_settings);
        public const string ground_position_start = nameof(ground_position_start);
        public const string automat_start = nameof(automat_start);
        public const string station_details = nameof(station_details);
        public const string technology_settings_access = nameof(technology_settings_access);
        public const string manual_start = nameof(manual_start);
        public const string sequencer_step = nameof(sequencer_step);
        public const string technology_automat_all = nameof(technology_automat_all);
        public const string technology_ground_all = nameof(technology_ground_all);
    }
}
