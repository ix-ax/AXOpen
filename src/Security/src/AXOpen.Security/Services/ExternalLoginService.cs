using AxOpen.Security.Entities;
using AxOpen.Security.Services;
using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Security.Services
{
    public class ExternalLoginService
    {
        private readonly IRepositoryService _repositoryService;
        private readonly SignInManager<User> _signInManager;

        public ExternalLoginService(IRepositoryService repositoryService, SignInManager<User> signInManager)
        {
            _repositoryService = repositoryService;
            _signInManager = signInManager;
        }

        public async Task<string?> LoginAsync(string externalAuthId, bool isPersistent = false)
        {
            if (string.IsNullOrWhiteSpace(externalAuthId))
                return "Missing externalAuthId.";

            string externalAuthIdHashed = Encoding.ASCII.GetString(System.Security.Cryptography.SHA512.HashData(Encoding.ASCII.GetBytes(externalAuthId)));
            List<User> users = _repositoryService.UserRepository.GetRecords().Where(user => user.ExternalAuthId != null && user.ExternalAuthId.Equals(externalAuthIdHashed)).ToList();
            if (users.Any())
            {
                if (users.Count() == 1)
                {
                    await _signInManager.SignOutAsync();

                    await _signInManager.SignInAsync(users.First(), isPersistent: false);
                    return null;
                }
                else
                    return "Multiple users with same external id!";
            }
            else
                return "User not found.";
        }
    }
}
