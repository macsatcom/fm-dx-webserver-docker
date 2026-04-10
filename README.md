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

## Setup after pushing to GitHub

1. Go to your repo on GitHub
2. Click **Settings** → **Actions** → **General**
3. Under "Workflow permissions" → select **Read and write permissions** → click **Save**
4. Go to the **Actions** tab → select "Build and Push Docker Image" → click **Run workflow**

The first image will now be built and available at:
`ghcr.io/YOURUSERNAME/fm-dx-webserver:latest`
