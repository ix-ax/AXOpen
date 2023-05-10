﻿using System.Collections.Generic;

namespace Security
{
    public interface IUser
    {
        bool CanUserChangePassword { get; set; }
        string Email { get; set; }
        string Level { get; set; }
        string[] Roles { get; set; }
        string UserName { get; set; }
    }
}