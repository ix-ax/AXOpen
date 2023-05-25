using Microsoft.AspNetCore.Identity;

namespace AxOpen.Security.Entities
{
    public class Role : IdentityRole<string>
    {       
        public Role(string Name)
        {
            var normalizer = new UpperInvariantLookupNormalizer();
            this.Name = Name;
            this.NormalizedName = normalizer.NormalizeName(this.Name);
        }

        public override string ToString() => Name;
    }
}
