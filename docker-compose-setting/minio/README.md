# MinIO

## What is MinIO?

MinIO is an object storage compatible with Amazon S3 API. Perfect for local development as an AWS S3 replacement, eliminating cloud costs during development.

## Use Cases

- **File Storage** - Store file uploads (images, documents, videos)
- **Static Assets** - Host static files (CSS, JS, images)
- **Backup Storage** - Storage location for database or file backups
- **Data Lake** - Raw data storage for analytics

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
docker compose logs -f minio
```

## Configuration (.env)

| Variable | Default | Description |
|----------|---------|-------------|
| `MINIO_ROOT_USER` | - | Login username (required) |
| `MINIO_ROOT_PASSWORD` | - | Login password (required) |
| `MINIO_REGION` | id-cgk-1 | Region identifier |
| `MINIO_BUCKET` | develop | Auto-created bucket name |

## Access

| Service | URL | Description |
|---------|-----|-------------|
| Console | http://localhost:9001 | Web UI for management |
| API | http://localhost:9000 | S3-compatible API endpoint |

Login to console using `MINIO_ROOT_USER` and `MINIO_ROOT_PASSWORD`.

## Usage Example with AWS SDK

```javascript
// Node.js with AWS SDK
const { S3Client } = require('@aws-sdk/client-s3');

const s3 = new S3Client({
  endpoint: 'http://localhost:9000',
  region: 'id-cgk-1',
  credentials: {
    accessKeyId: 'MINIO_ROOT_USER',
    secretAccessKey: 'MINIO_ROOT_PASSWORD',
  },
  forcePathStyle: true,
});
```

## Stopping the Service

```bash
docker compose down

# With data volume removal
docker compose down -v
```
