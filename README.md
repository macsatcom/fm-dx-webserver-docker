# fm-dx-webserver Docker

Automatic Docker wrapper for [fm-dx-webserver](https://github.com/NoobishSVK/fm-dx-webserver).

This repo automatically builds a new Docker image whenever a new commit is pushed to the official repo.

## Quick start

Run with Docker:

```bash
docker run -d \
  -p 8080:8080 \
  --device=/dev/ttyUSB0 \
  ghcr.io/macsatcom/fm-dx-webserver:latest
```

Or with docker-compose:

```yaml
services:
  fm-dx-webserver:
    image: ghcr.io/macsatcom/fm-dx-webserver:latest
    ports:
      - "8080:8080"
    devices:
      - "/dev/ttyUSB0:/dev/ttyUSB0"
    restart: unless-stopped
```

```bash
docker compose up -d
```

This uses `docker-compose.yml`, which pulls the pre-built image from ghcr.io.

If you want to build the image locally instead, use:

```bash
docker compose -f docker-compose-build.yml up -d
```

## Automatic updates

GitHub Actions checks daily at 04:00 UTC whether a new commit has been pushed to the official repo.
If so, a new image is built and pushed automatically to GitHub Container Registry (ghcr.io).
