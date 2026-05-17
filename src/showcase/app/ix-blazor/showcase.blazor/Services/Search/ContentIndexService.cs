using showcase.Services;

namespace showcase.Services.Search;

/// <summary>
/// Loads and indexes content from source files referenced by showcase pages.
/// Uses FileSystemWatcher to automatically rebuild the index when files change.
/// </summary>
public class ContentIndexService : IDisposable
{
    private readonly CodeSnippetProvider _snippetProvider;
    private volatile List<ContentIndexEntry> _entries = [];
    private readonly TaskCompletionSource _initialReady = new();
    private readonly List<FileSystemWatcher> _watchers = [];
    private CancellationTokenSource? _debounceCts;
    private readonly object _debounceLock = new();

    public bool IsReady => _initialReady.Task.IsCompleted;
    public IReadOnlyList<ContentIndexEntry> Entries => _entries;

    public ContentIndexService(CodeSnippetProvider snippetProvider)
    {
        _snippetProvider = snippetProvider;
    }

    public async Task InitializeAsync()
    {
        await RebuildIndexAsync();
        _initialReady.TrySetResult();
        SetupFileWatchers();
    }

    private async Task RebuildIndexAsync()
    {
        var pages = ShowcasePageRegistry.GetAllPages();
        var entries = new List<ContentIndexEntry>();

        foreach (var page in pages)
        {
            foreach (var filePath in page.SourceFilePaths)
            {
                var snippet = await _snippetProvider.GetSnippetAsync(filePath);
                if (snippet.IsError || string.IsNullOrWhiteSpace(snippet.Content))
                    continue;

                var lines = snippet.Content.Split(["\r\n", "\n"], StringSplitOptions.None);
                entries.Add(new ContentIndexEntry
                {
                    Page = page,
                    FilePath = filePath,
                    Content = snippet.Content.ToLowerInvariant(),
                    Lines = lines,
                    Language = snippet.Language,
                    FileName = Path.GetFileName(filePath)
                });
            }
        }

        _entries = entries;
    }

    private void SetupFileWatchers()
    {
        // CodeSnippetProvider resolves paths relative to a project root.
        // We watch the src/ directory tree for relevant file types.
        var basePath = GetWatchPath();
        if (basePath == null || !Directory.Exists(basePath))
            return;

        var filters = new[] { "*.st", "*.md", "*.yml" };
        foreach (var filter in filters)
        {
            var watcher = new FileSystemWatcher(basePath, filter)
            {
                IncludeSubdirectories = true,
                NotifyFilter = NotifyFilters.LastWrite | NotifyFilters.FileName | NotifyFilters.CreationTime,
                EnableRaisingEvents = true
            };

            watcher.Changed += OnFileChanged;
            watcher.Created += OnFileChanged;
            watcher.Deleted += OnFileChanged;
            watcher.Renamed += OnFileRenamed;

            _watchers.Add(watcher);
        }
    }

    private void OnFileChanged(object sender, FileSystemEventArgs e) => DebouncedRebuild();
    private void OnFileRenamed(object sender, RenamedEventArgs e) => DebouncedRebuild();

    private void DebouncedRebuild()
    {
        lock (_debounceLock)
        {
            _debounceCts?.Cancel();
            _debounceCts?.Dispose();
            _debounceCts = new CancellationTokenSource();
            var token = _debounceCts.Token;

            _ = Task.Run(async () =>
            {
                try
                {
                    await Task.Delay(500, token);
                    await RebuildIndexAsync();
                }
                catch (OperationCanceledException)
                {
                    // Debounce reset — another change came in
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"ContentIndexService rebuild error: {ex.Message}");
                }
            }, token);
        }
    }

    private string? GetWatchPath()
    {
        // Walk up from AppContext.BaseDirectory to find the repo root with src/ directory
        var dir = new DirectoryInfo(AppContext.BaseDirectory);
        for (var i = 0; i < 15 && dir?.Parent != null; i++)
        {
            var srcDir = Path.Combine(dir.FullName, "src");
            if (Directory.Exists(srcDir) &&
                Directory.Exists(Path.Combine(srcDir, "showcase", "app", "src")))
            {
                return srcDir;
            }
            dir = dir.Parent;
        }
        return null;
    }

    public void Dispose()
    {
        foreach (var watcher in _watchers)
        {
            watcher.EnableRaisingEvents = false;
            watcher.Dispose();
        }
        _watchers.Clear();
        _debounceCts?.Cancel();
        _debounceCts?.Dispose();
    }
}
