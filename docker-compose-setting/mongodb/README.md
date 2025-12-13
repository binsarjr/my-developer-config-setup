# MongoDB

NoSQL document-oriented database for development.

## Setup

```bash
cp .env.example .env
# Edit .env as needed
docker compose up -d
```

## Connection

**Connection String:**
```
mongodb://admin:MyStr0ngP@ssw0rd123@localhost:27017/app?authSource=admin
```

**Environment Variables for application:**
```env
MONGO_URI=mongodb://admin:MyStr0ngP@ssw0rd123@localhost:27017/app?authSource=admin
```

## Configuration

| Variable | Default | Description |
|----------|---------|-----------|
| `MONGO_ROOT_USER` | admin | Root username |
| `MONGO_ROOT_PASSWORD` | - | Root password |
| `MONGO_DATABASE` | app | Default database |
| `MONGO_PORT` | 27017 | MongoDB port |

## Commands

```bash
# Start
docker compose up -d

# Stop
docker compose down

# View logs
docker compose logs -f

# Enter mongo shell
docker exec -it mongodb mongosh -u admin -p
```
