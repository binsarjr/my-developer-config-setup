# PostgreSQL

Database relasional untuk development.

## Setup

```bash
cp .env.example .env
# Edit .env sesuai kebutuhan
docker compose up -d
```

## Connection

**Connection String:**
```
postgresql://postgres:MyStr0ngP@ssw0rd123@localhost:5432/app
```

**Environment Variables untuk aplikasi:**
```env
DATABASE_URL=postgresql://postgres:MyStr0ngP@ssw0rd123@localhost:5432/app
```

## Configuration

| Variable | Default | Deskripsi |
|----------|---------|-----------|
| `POSTGRES_USER` | postgres | Username |
| `POSTGRES_PASSWORD` | - | Password |
| `POSTGRES_DB` | app | Database default |
| `POSTGRES_PORT` | 5432 | Port PostgreSQL |

## Commands

```bash
# Start
docker compose up -d

# Stop
docker compose down

# Lihat logs
docker compose logs -f

# Masuk ke psql
docker exec -it postgresql psql -U postgres -d app
```
