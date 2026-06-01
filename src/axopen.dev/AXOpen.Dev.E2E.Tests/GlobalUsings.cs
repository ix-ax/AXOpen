global using Xunit;

// End-to-end tests change the process working directory (commands use relative paths), so they
// must not run in parallel with each other.
[assembly: CollectionBehavior(DisableTestParallelization = true)]
