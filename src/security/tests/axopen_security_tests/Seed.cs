using AxOpen.Security;

namespace AxOpen.Security.Tests
{
    public class Seed
    {
        public Seed()
        {
            SeedData();
        }
        public void SeedData()
        {
            ExistUser = new User("exist", "exist@exist.com", new List<string>().ToArray(), false)
            {
                Id = "exist",
                SecurityStamp = Guid.NewGuid().ToString(),
                PasswordHash = Hasher.CalculateHash("exist", "exist"),
                RoleHash = Hasher.CalculateHash("", "exist")
            };

            NoExistUser = new User("noexist", "noexist@noexist.com", new List<string>().ToArray(), false)
            {
                Id = "noexist",
                SecurityStamp = Guid.NewGuid().ToString(),
                PasswordHash = Hasher.CalculateHash("noexist", "noexist"),
                RoleHash = Hasher.CalculateHash("", "noexist")
            };

            CreateUser = new User("create", "create@create.com", new List<string>().ToArray(), false)
            {
                Id = "create",
                SecurityStamp = Guid.NewGuid().ToString(),
                PasswordHash = Hasher.CalculateHash("create", "create"),
                RoleHash = Hasher.CalculateHash("", "create")
            };

            RemoveUser = new User("remove", "remove@remove.com", new List<string>().ToArray(), false)
            {
                Id = "remove",
                SecurityStamp = Guid.NewGuid().ToString(),
                PasswordHash = Hasher.CalculateHash("remove", "remove"),
                RoleHash = Hasher.CalculateHash("", "remove")
            };

            UpdateUser = new User("update", "update@update.com", new List<string>().ToArray(), false)
            {
                Id = "update",
                SecurityStamp = Guid.NewGuid().ToString(),
                PasswordHash = Hasher.CalculateHash("update", "update"),
                RoleHash = Hasher.CalculateHash("", "update")
            };

            AdminUser = new User("admin", "admin@admin.com", new string[] { "AdminGroup" }, false)
            {
                Id = "admin",
                SecurityStamp = Guid.NewGuid().ToString(),
                PasswordHash = Hasher.CalculateHash("admin", "admin"),
                RoleHash = Hasher.CalculateHash("AdminGroup", "admin")
            };

            DefaultUser = new User("default", "default@default.com", new string[] { "DefaultGroup" }, false)
            {
                Id = "default",
                SecurityStamp = Guid.NewGuid().ToString(),
                PasswordHash = Hasher.CalculateHash("default", "default"),
                RoleHash = Hasher.CalculateHash("", "default")
            };
        }

        public User ExistUser { get; set; }
        public User NoExistUser { get; set; }
        public User CreateUser { get; set; }
        public User RemoveUser { get; set; }
        public User UpdateUser { get; set; }
        public User AdminUser { get; set; }
        public User DefaultUser { get; set; }
    }
}
