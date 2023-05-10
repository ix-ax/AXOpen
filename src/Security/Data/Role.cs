﻿using Microsoft.AspNetCore.Identity;

namespace Security
{
    public class Role : IdentityRole<string>
    {       
        public string DefaultGroup { get; private set; }

        public Role(string Name, string DefaultGroup)
        {
            var normalizer = new UpperInvariantLookupNormalizer();
            this.Name = Name;
            this.DefaultGroup = DefaultGroup;
            this.NormalizedName = normalizer.NormalizeName(this.Name);
        }

        public Role(string Name)
        {
            var normalizer = new UpperInvariantLookupNormalizer();
            this.Name = Name;
            this.NormalizedName = normalizer.NormalizeName(this.Name);
        }

        public override string ToString() => Name;
    }
}