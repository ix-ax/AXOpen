namespace AXOpen.Dev.Requisites;

/// <summary>Abstracts <c>Invoke-WebRequest -OutFile</c> downloads used by the installers.</summary>
public interface IFileDownloader
{
    Task DownloadAsync(string url, string outputPath, CancellationToken ct = default);
}

/// <summary>Default <see cref="HttpClient"/>-based downloader.</summary>
public sealed class HttpFileDownloader : IFileDownloader
{
    public async Task DownloadAsync(string url, string outputPath, CancellationToken ct = default)
    {
        using var client = new HttpClient { Timeout = TimeSpan.FromMinutes(10) };
        await using var source = await client.GetStreamAsync(url, ct);
        await using var target = File.Create(outputPath);
        await source.CopyToAsync(target, ct);
    }
}
