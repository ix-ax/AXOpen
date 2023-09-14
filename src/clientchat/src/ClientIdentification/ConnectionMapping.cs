using System.Collections.Generic;
using System.Linq;

namespace clientchat.ClientIdentification;

/// <summary>
/// Class that maps user names to their connection ids. Connection ids are sotored in a HashSet as value in a Dictionary
/// with user name as the key.
/// </summary>
/// <typeparam name="T"> 
/// Type of user name.
/// </typeparam>
public class ConnectionMapping<T>
{
    private readonly Dictionary<T, HashSet<string>> _connections =
            new Dictionary<T, HashSet<string>>();

    /// <summary>
    /// Returns number of users names in the mapping.
    /// </summary>
    public int Count
    {
        get
        {
            return _connections.Count;
        }
    }

    /// <summary>
    /// Adds a connection id to a set of connection ids for a user name.
    /// </summary>
    /// <param name="key"></param>
    /// <param name="connectionId"></param>
    public void Add(T key, string connectionId)
    {
        if (key == null)
        {
            return;
        }

        lock (_connections)
        {
            HashSet<string>? connections;
            if (!_connections.TryGetValue(key, out connections))
            {
                connections = new HashSet<string>();
                _connections.Add(key, connections);
            }

            lock (connections)
            {
                connections.Add(connectionId);
            }
        }
    }

    public Dictionary<T, int> GetConnectionsCounts()
    {
        Dictionary<T, int> connectionsCounts = new();

        foreach (var key in _connections.Keys)
        {
            connectionsCounts.Add(key, _connections[key].Count);
        }

        return connectionsCounts;
    }

    /// <summary>
    /// Returns all connections for a given user name.
    /// </summary>
    /// <param name="key"></param>
    /// <returns>
    /// Set of connection ids for given user name.
    /// <code>Enumerable.Empty<string>()</code> if the <c>key</c> is null or it is not found.
    /// </returns>
    public IEnumerable<string> GetConnections(T key)
    {
        if (key == null)
        {
            return Enumerable.Empty<string>();
        }

        HashSet<string>? connections;
        if (_connections.TryGetValue(key, out connections))
        {
            return connections;
        }
        else
        {
            return Enumerable.Empty<string>();
        }
    }

    /// <summary>
    /// Removes a connection id from a set of connection ids associated with a user name.
    /// </summary>
    /// <param name="key"></param>
    /// <param name="connectionId"></param>
    public void Remove(T key, string connectionId)
    {
        if (key == null)
        {
            return;
        }

        lock (_connections)
        {
            HashSet<string>? connections;
            if (!_connections.TryGetValue(key, out connections))
            {
                return;
            }

            lock (connections)
            {
                connections.Remove(connectionId);

                if (connections.Count == 0)
                {
                    _connections.Remove(key);
                }
            }
        }
    }
}
