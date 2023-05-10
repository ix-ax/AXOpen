using System;
using System.Collections.Generic;
using System.Linq;

namespace Security
{
    public interface ISecurityManager
    {
        IEnumerable<string> AvailableGroups();

        /// <summary>
        /// Get the existing role or add the rule if not present in the system.
        /// </summary>
        /// <param name="role">Role to create or retrieve.</param>
        /// <returns>Requested role</returns>
        Role GetOrCreateRole(Role role);

        IEnumerable<Role> AvailableRoles { get; }      
    }
}
