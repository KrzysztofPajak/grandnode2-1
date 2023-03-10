using System.Reflection;

namespace Grand.Infrastructure
{
    public static class GrandVersion
    {
        /// <summary>
        /// Gets the major version
        /// </summary>
        public const string MajorVersion = "2";

        /// <summary>
        /// Gets the minor version
        /// </summary>
        public const string MinorVersion = "1";

        /// <summary>
        /// Gets the patch version
        /// </summary>
        public const string PatchVersion = "0-develop";

        /// <summary>
        /// Gets the full version
        /// </summary>
        public const string FullVersion = $"{MajorVersion}.{MinorVersion}.{PatchVersion}";

        /// <summary>
        /// Gets the Supported DB version
        /// </summary>
        public const string SupportedDBVersion = $"{MajorVersion}.{MinorVersion}";

        /// <summary>
        /// Gets the Supported plugin version
        /// </summary>
        public const string SupportedPluginVersion = $"{MajorVersion}.{MinorVersion}";

        /// <summary>
        /// Gets the git branch
        /// </summary>
        public const string GitBranch = "";

        /// <summary>
        /// Gets the git commit
        /// </summary>
        public static string GitCommit = GetGitHash();
        
        private static string GetGitHash()
        {
            if (!string.IsNullOrEmpty(_gitHash)) return _gitHash;
            
            var version = "1.0.0+LOCALBUILD"; // Dummy version for local dev
            var appAssembly = typeof(GrandVersion).Assembly;
            var infoVerAttr = (AssemblyInformationalVersionAttribute)appAssembly
                .GetCustomAttributes(typeof(AssemblyInformationalVersionAttribute)).FirstOrDefault();
            if (infoVerAttr is { InformationalVersion.Length: > 6 })
            {
                // Hash is embedded in the version after a '+' symbol, e.g. 1.0.0+a34a913742f8845d3da5309b7b17242222d41a21
                version = infoVerAttr.InformationalVersion;
            }
            _gitHash = version[(version.IndexOf('+') + 1)..];

            return _gitHash;
        }

        private static string _gitHash { get; set; }
    }
}
