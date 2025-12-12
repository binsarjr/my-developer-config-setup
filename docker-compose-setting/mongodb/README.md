# MongoDB

Database NoSQL document-oriented untuk development.

## Setup

```bash
cp .env.example .env
# Edit .env sesuai kebutuhan
docker compose up -d
```

## Connection

**Connection String:**
```
mongodb://admin:MyStr0ngP@ssw0rd123@localhost:27017/app?authSource=admin
```

**Environment Variables untuk aplikasi:**
```env
MONGO_URI=mongodb://admin:MyStr0ngP@ssw0rd123@localhost:27017/app?authSource=admin
```

## Configuration

| Variable | Default | Deskripsi |
|----------|---------|-----------|
| `MONGO_ROOT_USER` | admin | Username root |
| `MONGO_ROOT_PASSWORD` | - | Password root |
| `MONGO_DATABASE` | app | Database default |
| `MONGO_PORT` | 27017 | Port MongoDB |

## Commands

```bash
# Start
docker compose up -d

# Stop
docker compose down

# Lihat logs
docker compose logs -f

# Masuk ke mongo shell
docker exec -it mongodb mongosh -u admin -p
```
