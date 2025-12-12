# DragonflyDB

## Apa itu DragonflyDB?

DragonflyDB adalah in-memory database yang kompatibel dengan Redis dan Memcached. Dikembangkan dengan arsitektur modern yang memanfaatkan multi-threading, sehingga memiliki performa lebih tinggi dibanding Redis tradisional.

## Kegunaan

- **Caching** - Menyimpan data sementara untuk mempercepat akses (session, API response, query results)
- **Rate Limiting** - Membatasi jumlah request per user/IP
- **Queue/Pub-Sub** - Message broker sederhana untuk komunikasi antar service
- **Real-time Data** - Leaderboard, online status, live counters

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
docker compose logs -f dragonfly
```

## Konfigurasi (.env)

| Variable | Default | Keterangan |
|----------|---------|------------|
| `DRAGONFLY_PORT` | 6379 | Port untuk koneksi Redis |
| `DRAGONFLY_PASSWORD` | - | Password autentikasi (wajib diisi) |
| `DRAGONFLY_MAXMEMORY` | 4gb | Batas maksimal penggunaan memory |

## Koneksi

```
Host: localhost
Port: 6379 (atau sesuai DRAGONFLY_PORT)
Password: sesuai DRAGONFLY_PASSWORD
```

Contoh koneksi dengan redis-cli:
```bash
redis-cli -p 6379 -a <password>
```

## Menghentikan Service

```bash
docker compose down

# Dengan menghapus volume data
docker compose down -v
```
