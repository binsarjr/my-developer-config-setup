# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a development utilities repository containing Docker Compose configurations for local infrastructure services and standalone binary tools.

## Structure

- `docker-compose-setting/` - Docker Compose configurations for local services
  - `dragonfly/` - DragonflyDB (Redis-compatible in-memory database)
  - `minio/` - MinIO (S3-compatible object storage)
- `binary-files/` - Standalone binary tools (gitignored, only .gitkeep and README tracked)
- `configs/` - Shell configuration files (config.zsh, starship.toml, install-helper)

## Common Commands

### DragonflyDB
```bash
cd docker-compose-setting/dragonfly
cp .env.example .env  # Then edit with your values
docker compose up -d
```

### MinIO
```bash
cd docker-compose-setting/minio
cp .env.example .env  # Then edit with your values
docker compose up -d
```
MinIO console available at port 9001, API at port 9000.

## Environment Files

Each service has a `.env.example` file. Copy to `.env` and configure before running. The `.env` files are gitignored.
