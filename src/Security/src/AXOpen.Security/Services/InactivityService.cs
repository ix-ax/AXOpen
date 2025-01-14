namespace AxOpen.Security.Services
{
    public class InactivityService : IDisposable
    {
        private TimeSpan _timeoutPeriod { get; set; }
        private Timer? _timer { get; set; }
        private Action _onTimeout { get; set; }

        public void StartMonitoring(TimeSpan timeoutPeriod)
        {
            _timeoutPeriod = timeoutPeriod;

            _timer = new Timer(OnTimerElapsed, null, _timeoutPeriod, Timeout.InfiniteTimeSpan);
        }

        private void OnTimerElapsed(object state)
        {
            _onTimeout?.Invoke();
            _timer?.Dispose();
        }

        public void SetAction(Action onTimeout)
        {
            _onTimeout = onTimeout;
        }

        public void Reset()
        {
            if (_timer != null)
                _timer.Change(_timeoutPeriod, Timeout.InfiniteTimeSpan);
        }

        public void Dispose()
        {
            _timer?.Dispose();
        }
    }
}
