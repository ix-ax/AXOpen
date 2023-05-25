using AxOpen.Security;
using AxOpen.Security.Entities;
using Microsoft.AspNetCore.Identity;

namespace AxOpen.Security.Tests
{
    public class Seed
    {
        public PasswordHasher<User> Hasher { get; set; }
        public Seed(PasswordHasher<User> _hasher)
        {
            Hasher = _hasher;
            SeedData();
        }
        public void SeedData()
        {
            ExistUser = new User("EXIST", "exist@exist.com", "", false)
            {
                Id = "EXIST",
                SecurityStamp = Guid.NewGuid().ToString()
            };
            ExistUser.PasswordHash = Hasher.HashPassword(ExistUser, "EXIST");
            ExistUser.GroupHash = Hasher.HashPassword(ExistUser, "");

            NoExistUser = new User("NOEXIST", "noexist@noexist.com", "", false)
            {
                Id = "NOEXIST",
                SecurityStamp = Guid.NewGuid().ToString()
            };
            NoExistUser.PasswordHash = Hasher.HashPassword(NoExistUser, "NOEXIST");
            NoExistUser.GroupHash = Hasher.HashPassword(NoExistUser, "");

            CreateUser = new User("CREATE", "create@create.com", "", false)
            {
                Id = "CREATE",
                SecurityStamp = Guid.NewGuid().ToString()
            };
            CreateUser.PasswordHash = Hasher.HashPassword(CreateUser, "CREATE");
            CreateUser.GroupHash = Hasher.HashPassword(CreateUser, "");

            RemoveUser = new User("REMOVE", "remove@remove.com", "", false)
            {
                Id = "REMOVE",
                SecurityStamp = Guid.NewGuid().ToString()
            };
            RemoveUser.PasswordHash = Hasher.HashPassword(RemoveUser, "REMOVE");
            RemoveUser.GroupHash = Hasher.HashPassword(RemoveUser, "");

            UpdateUser = new User("UPDATE", "update@update.com", "", false)
            {
                Id = "UPDATE",
                SecurityStamp = Guid.NewGuid().ToString()
            };
            UpdateUser.PasswordHash = Hasher.HashPassword(UpdateUser, "UPDATE");
            UpdateUser.GroupHash = Hasher.HashPassword(UpdateUser, "");

            AdminUser = new User("ADMIN", "admin@admin.com", "AdminGroup", false)
            {
                Id = "ADMIN",
                SecurityStamp = Guid.NewGuid().ToString()
            };
            AdminUser.PasswordHash = Hasher.HashPassword(AdminUser, "ADMIN");
            AdminUser.GroupHash = Hasher.HashPassword(AdminUser, "AdminGroup");

            DefaultUser = new User("DEFAULT", "default@default.com", "DefaultGroup", false)
            {
                Id = "DEFAULT",
                SecurityStamp = Guid.NewGuid().ToString()
            };
            DefaultUser.PasswordHash = Hasher.HashPassword(DefaultUser, "DEFAULT");
            DefaultUser.GroupHash = Hasher.HashPassword(DefaultUser, "DefaultGroup");

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
