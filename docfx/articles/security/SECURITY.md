# AXOpen.Security

AxOpen.Security is library which provides authentication and authorization in Blazor AX applications. It is based on a default solution for authentication in Blazor, which is extended by using implemented repositories within Ax.Open.Data. As a result, multiple storage providers for security can be used.

## Installation

The security library is available in form of NuGet package. Detailed installation instructions of security into empty Blazor project is located in [security installation article](SECURITYINSTALLATION.md).

## Basic concepts

Each user is limited to having just a single group. A group is formed by a collection of multiple roles. When a user is assigned to a group, they possess all the roles associated with that group.
It is possible for a single role to be assigned to multiple groups.

## Security views

SecurityManagementView component serves for managing users. It is available only if user is logged in with administrator rights.

When user is logged in with administrator rights, it is possible to modify all available users and groups. Administrator can delete users or change group.

### User management

The SecurityManagementView component includes a tab dedicated to user management. Within this tab, users can be updated or newly created. When a user is selected, a card is displayed showing the current data for that user, there is an option to update or delete user.

![Custom columns](~/images/UserManagement.png)

### Group Management

The SecurityManagementView component includes a tab for group management. Within this tab, groups can be updated or newly created. When a group is selected, a card is displayed showing the assigned roles for that group. Users have the option assigned or unassign roles or delete group.

![Custom columns](~/images/GroupManagement.png)

### Account Management

In account management view is possible to change the your user data, like email address or password.

![Custom columns](~/images/AccountManagement.png)

### User Create

In user create view is possible to new user.

![Custom columns](~/images/CreateUser.png)

## AuthorizeView

from view

from code