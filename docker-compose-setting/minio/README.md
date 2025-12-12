# MinIO

## Apa itu MinIO?

MinIO adalah object storage yang kompatibel dengan Amazon S3 API. Cocok untuk development lokal sebagai pengganti AWS S3, sehingga tidak perlu biaya cloud saat development.

## Kegunaan

- **File Storage** - Menyimpan file upload (gambar, dokumen, video)
- **Static Assets** - Hosting file statis (CSS, JS, images)
- **Backup Storage** - Tempat penyimpanan backup database atau file
- **Data Lake** - Penyimpanan data mentah untuk analytics

## Cara Menjalankan

```bash
# Copy environment file
cp .env.example .env

# Edit konfigurasi sesuai kebutuhan
nano .env

# Jalankan service
docker compose up -d

# Cek status
docker compose ps

# Lihat logs
docker compose logs -f minio
```

## Konfigurasi (.env)

| Variable | Default | Keterangan |
|----------|---------|------------|
| `MINIO_ROOT_USER` | - | Username untuk login (wajib diisi) |
| `MINIO_ROOT_PASSWORD` | - | Password untuk login (wajib diisi) |
| `MINIO_REGION` | id-cgk-1 | Region identifier |
| `MINIO_BUCKET` | develop | Nama bucket yang dibuat otomatis |

## Akses

| Service | URL | Keterangan |
|---------|-----|------------|
| Console | http://localhost:9001 | Web UI untuk manajemen |
| API | http://localhost:9000 | S3-compatible API endpoint |

Login ke console menggunakan `MINIO_ROOT_USER` dan `MINIO_ROOT_PASSWORD`.

## Contoh Penggunaan dengan AWS SDK

```javascript
// Node.js dengan AWS SDK
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

## Menghentikan Service

```bash
docker compose down

# Dengan menghapus volume data
docker compose down -v
```
