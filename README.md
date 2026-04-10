# fm-dx-webserver Docker

Automatic Docker wrapper for [fm-dx-webserver](https://github.com/NoobishSVK/fm-dx-webserver).

This repo automatically builds a new Docker image whenever a new commit is pushed to the official repo.

## Quick start

Run with Docker:

```bash
docker run -d \
  -p 8080:8080 \
  --device=/dev/ttyUSB0 \
  ghcr.io/YOURUSERNAME/fm-dx-webserver:latest
```

Or with docker-compose:

```bash
docker compose up -d
```

> Replace `YOURUSERNAME` with your GitHub username.

## Automatic updates

GitHub Actions checks daily at 04:00 UTC whether a new commit has been pushed to the official repo.
If so, a new image is built and pushed automatically to GitHub Container Registry (ghcr.io).

