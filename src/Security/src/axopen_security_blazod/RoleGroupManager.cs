using AxOpen.Security.Entities;
using AXOpen.Base.Data;
using Microsoft.AspNetCore.Identity;
using System.Xml.Linq;


namespace AxOpen.Security
{
    public class RoleGroupManager
    {
        private IRepository<Group> groupRepo;

        public List<Role> inAppRoleCollection { get; set; } = new List<Role>();

        public RoleGroupManager(IRepository<Group> groupRepo)
        {
            this.groupRepo = groupRepo;
            CreateDefaultRoleAndGroup();
        }

        private void CreateDefaultRoleAndGroup()
        {
            CreateRole(new Role("Administrator"));

            if (!GetAllGroup().Any())
            {
                CreateGroup("AdminGroup");
                AddRoleToGroup("AdminGroup", "Administrator");
            }
        }

        public IdentityResult CreateRole(Role role)
        {
            if (role == null)
                throw new ArgumentNullException(nameof(role));

            this.inAppRoleCollection.Add(role);
            return IdentityResult.Success;
        }

        public IdentityResult CreateRoles(List<Role> roles)
        {
            if (roles == null)
                throw new ArgumentNullException(nameof(roles));

            foreach(Role role in roles)
            {
                this.inAppRoleCollection.Add(role);
            }
            
            return IdentityResult.Success;
        }

        public IdentityResult CreateGroup(string name)
        {
            if (name == null || name == "")
                throw new ArgumentNullException(nameof(name));

            try
            {
                var data = new Group(name);
                data.RolesHash = new PasswordHasher<Group>().HashPassword(data, "");
                data.Created = DateTime.Now;
                groupRepo.Create(name, data);
            }
            catch (DuplicateIdException)
            {
                return IdentityResult.Failed(new IdentityError { Description = $"Group with name {name} already exists." });
            }

            //TcoAppDomain.Current.Logger.Information($"New Group '{name}' created. {{@sender}}", new { Name = name });

            return IdentityResult.Success;
        }

        public IdentityResult DeleteGroup(string name)
        {
            if (name == null || name == "")
                throw new ArgumentNullException(nameof(name));

            groupRepo.Delete(name);

            //TcoAppDomain.Current.Logger.Information($"Group '{name}' deleted. {{@sender}}", new { Name = name });

            return IdentityResult.Success;
        }

        public IdentityResult AddRoleToGroup(string group, string role)
        {
            if (group == null || group == "")
                throw new ArgumentNullException(nameof(group));
            if (role == null || role == "")
                throw new ArgumentNullException(nameof(role));

            try
            {
                Group data = null;
                data = groupRepo.Read(group);
                if (data != null)
                {
                    data.Roles.Add(role);
                    data.RolesHash = new PasswordHasher<Group>().HashPassword(data, String.Join(",", data.Roles));
                    data.Modified = DateTime.Now;
                }
                else
                {
                    return IdentityResult.Failed(new IdentityError { Description = $"Group with name {group} doesn't exists." });
                }

                groupRepo.Update(group, data);
            }
            catch (UnableToLocateRecordId)
            {
                return IdentityResult.Failed(new IdentityError { Description = $"Group with name {group} doesn't exists." });
            }

            return IdentityResult.Success;
        }

        public IdentityResult AddRolesToGroup(string group, IEnumerable<string> roles)
        {
            if (group == null || group == "")
                throw new ArgumentNullException(nameof(group));
            if (roles == null)
                throw new ArgumentNullException(nameof(roles));

            try
            {
                Group data = null;
                data = groupRepo.Read(group);
                if (data != null)
                {
                    foreach (var role in roles)
                    {
                        data.Roles.Add(role);
                    }
                    data.RolesHash = new PasswordHasher<Group>().HashPassword(data, String.Join(",", data.Roles));
                    data.Modified = DateTime.Now;
                }
                else
                {
                    return IdentityResult.Failed(new IdentityError { Description = $"Group with name {group} doesn't exists." });
                }

                groupRepo.Update(group, data);
            }
            catch (UnableToLocateRecordId)
            {
                return IdentityResult.Failed(new IdentityError { Description = $"Group with name {group} doesn't exists." });
            }

            //TcoAppDomain.Current.Logger.Information($"Group '{group}' assign '{String.Join(",", roles)}'. {{@sender}}", new { Name = group, Roles = String.Join(",", roles) });

            return IdentityResult.Success;
        }

        public IdentityResult RemoveRolesFromGroup(string group, IEnumerable<string> roles)
        {
            if (group == null || group == "")
                throw new ArgumentNullException(nameof(group));
            if (roles == null)
                throw new ArgumentNullException(nameof(roles));

            try
            {
                Group? data = null;
                data = groupRepo.Read(group);
                if (data != null)
                {
                    foreach (var role in roles)
                    {
                        data.Roles.Remove(role);
                    }
                    data.RolesHash = new PasswordHasher<Group>().HashPassword(data, String.Join(",", data.Roles));
                    data.Modified = DateTime.Now;
                }
                else
                {
                    return IdentityResult.Failed(new IdentityError { Description = $"Group with name {group} doesn't exists." });
                }

                //TcoAppDomain.Current.Logger.Information($"Group '{group}' remove '{String.Join(",", roles)}'. {{@sender}}", new { Name = group, Roles = String.Join(",", roles) });

                groupRepo.Update(group, data);
            }
            catch (UnableToLocateRecordId)
            {
                return IdentityResult.Failed(new IdentityError { Description = $"Group with name {group} doesn't exists." });
            }

            return IdentityResult.Success;
        }

        public List<string> GetRolesFromGroup(string group)
        {
            if (group == null || group == "")
                return new List<string>();

            Group data = null;

            try
            {
                if (!groupRepo.Exists(group))
                {
                    return new List<string>();
                }
                data = groupRepo.Read(group);

                if (new PasswordHasher<Group>().VerifyHashedPassword(data, data.RolesHash, String.Join(",", data.Roles)) == PasswordVerificationResult.Failed)
                    return new List<string>();
            }
            catch (UnableToLocateRecordId)
            {
                return new List<string>();
            }

            return new List<string>(data.Roles);
        }

        public string GetRolesFromGroupString(string group)
        {
            return String.Join(",", GetRolesFromGroup(group));
        }

        public List<Group> GetAllGroup()
        {
            List<Group> data = null;
            data = groupRepo.GetRecords().ToList();
            return data;
        }
    }
}