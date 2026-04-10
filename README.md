# fm-dx-webserver Docker

Automatisk Docker-wrapper til [fm-dx-webserver](https://github.com/NoobishSVK/fm-dx-webserver).

Dette repo bygger automatisk et nyt Docker image, når der udkommer en ny officiel release.

## Hurtigt i gang

Kør med Docker:

```bash
docker run -d \
  -p 8080:8080 \
  --device=/dev/ttyUSB0 \
  ghcr.io/DITBRUGERNAVN/fm-dx-webserver:latest
```

Eller med docker-compose:

```bash
docker compose up -d
```

> Erstat `DITBRUGERNAVN` med dit GitHub-brugernavn.

## Automatisk opdatering

GitHub Actions tjekker dagligt kl. 04:00 UTC om der er en ny release på det officielle repo.
Hvis ja, bygges og pushes et nyt image automatisk til GitHub Container Registry (ghcr.io).

## Opsætning efter push til GitHub

1. Gå til dit repo på GitHub
2. Klik på **Settings** → **Actions** → **General**
3. Under "Workflow permissions" → vælg **Read and write permissions** → klik **Save**
4. Gå til **Actions**-fanen → vælg "Build and Push Docker Image" → klik **Run workflow**

Det første image bliver nu bygget og lagt på:
`ghcr.io/DITBRUGERNAVN/fm-dx-webserver:latest`
