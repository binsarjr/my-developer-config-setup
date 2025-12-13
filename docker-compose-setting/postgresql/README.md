# PostgreSQL

Relational database for development.

## Setup

```bash
cp .env.example .env
# Edit .env as needed
docker compose up -d
```

## Connection

**Connection String:**
```
postgresql://postgres:MyStr0ngP@ssw0rd123@localhost:5432/app
```

**Environment Variables for application:**
```env
DATABASE_URL=postgresql://postgres:MyStr0ngP@ssw0rd123@localhost:5432/app
```

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `POSTGRES_USER` | postgres | Username |
| `POSTGRES_PASSWORD` | - | Password |
| `POSTGRES_DB` | app | Default database |
| `POSTGRES_PORT` | 5432 | PostgreSQL port |

## Commands

```bash
# Start
docker compose up -d

# Stop
docker compose down

# View logs
docker compose logs -f

# Enter psql
docker exec -it postgresql psql -U postgres -d app
```
