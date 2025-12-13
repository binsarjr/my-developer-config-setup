# DragonflyDB

## What is DragonflyDB?

DragonflyDB is an in-memory database compatible with Redis and Memcached. Built with modern architecture utilizing multi-threading, it delivers higher performance than traditional Redis.

## Use Cases

- **Caching** - Store temporary data for faster access (session, API response, query results)
- **Rate Limiting** - Limit number of requests per user/IP
- **Queue/Pub-Sub** - Simple message broker for inter-service communication
- **Real-time Data** - Leaderboard, online status, live counters

## Running the Service

```bash
# Copy environment file
cp .env.example .env

# Edit configuration as needed
nano .env

# Run service
docker compose up -d

# Check status
docker compose ps

# View logs
docker compose logs -f dragonfly
```

## Configuration (.env)

| Variable | Default | Description |
|----------|---------|-------------|
| `DRAGONFLY_PORT` | 6379 | Redis connection port |
| `DRAGONFLY_PASSWORD` | - | Authentication password (required) |
| `DRAGONFLY_MAXMEMORY` | 4gb | Maximum memory usage limit |

## Connection

```
Host: localhost
Port: 6379 (or as set in DRAGONFLY_PORT)
Password: as set in DRAGONFLY_PASSWORD
```

Example connection with redis-cli:
```bash
redis-cli -p 6379 -a <password>
```

## Stopping the Service

```bash
docker compose down

# With data volume removal
docker compose down -v
```
