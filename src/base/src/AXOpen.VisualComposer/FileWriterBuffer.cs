using AXOpen.VisualComposer.Serializing;
using AXSharp.Connector.Localizations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.VisualComposer
{
    internal class FileWriterBuffer<T> : IDisposable
    {
        private string? _path;
        private T? _content;
        private Timer _timer;

        public FileWriterBuffer()
        {
            _timer = new Timer(callback, null, Timeout.InfiniteTimeSpan, TimeSpan.FromSeconds(1));
        }

        private async void callback(object state)
        {
            await SaveAsync();
        }

        public async Task AddToBufferAsync(string path, T content)
        {
            if(_path != path)
            {
                await SaveAsync();
                _path = path;
            }

            _content = content;

            _timer.Change(TimeSpan.FromSeconds(1), TimeSpan.FromSeconds(1));
        }

        public async Task SaveAsync()
        {
            if(_path != null && _content != null)
                await Serializing.Serializing<T>.SerializeAsync(_path, _content);

            _timer.Change(Timeout.InfiniteTimeSpan, TimeSpan.FromSeconds(1));
        }

        public async void Dispose()
        {
            await SaveAsync();
        }
    }
}
