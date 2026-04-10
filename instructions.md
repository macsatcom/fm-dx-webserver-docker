# Instruktioner til Claude Code: fm-dx-webserver-docker

## Opgave
Opret et nyt projekt kaldet `fm-dx-webserver-docker`.
Det er en Docker-wrapper, der automatisk bygger og distribuerer det officielle fm-dx-webserver projekt:
https://github.com/NoobishSVK/fm-dx-webserver

Opret følgende filer med **præcis** det indhold der er angivet nedenfor.

---

## Fil 1: `Dockerfile`

```dockerfile
FROM node:20-alpine

RUN apk add --no-cache git

WORKDIR /app

ARG VERSION=latest

RUN if [ "$VERSION" = "latest" ]; then \
      git clone --depth 1 https://github.com/NoobishSVK/fm-dx-webserver.git .; \
    else \
      git clone --depth 1 --branch $VERSION https://github.com/NoobishSVK/fm-dx-webserver.git .; \
    fi

RUN npm install --production

EXPOSE 8080

CMD ["node", "server.js"]
```

---

## Fil 2: `docker-compose.yml`

```yaml
version: '3.8'

services:
  fm-dx-webserver:
    image: fm-dx-webserver:latest
    build:
      context: .
      args:
        VERSION: latest
    ports:
      - "8080:8080"
    devices:
      - "/dev/ttyUSB0:/dev/ttyUSB0"
    restart: unless-stopped
```

---

## Fil 3: `.github/workflows/build-and-push.yml`

Opret mappen `.github/workflows/` og placer filen der.

```yaml
name: Build and Push Docker Image

on:
  schedule:
    - cron: '0 4 * * *'
  workflow_dispatch:

jobs:
  check-and-build:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      packages: write

    steps:
      - name: Checkout dette repo
        uses: actions/checkout@v4

      - name: Hent seneste release fra officielt repo
        id: upstream
        run: |
          LATEST=$(curl -s https://api.github.com/repos/NoobishSVK/fm-dx-webserver/releases/latest | jq -r '.tag_name')
          echo "version=$LATEST" >> $GITHUB_OUTPUT
          echo "Seneste version: $LATEST"

      - name: Tjek om vi allerede har bygget denne version
        id: check
        run: |
          CURRENT=$(cat .last-built-version 2>/dev/null || echo "none")
          echo "Sidst bygget: $CURRENT"
          if [ "$CURRENT" = "${{ steps.upstream.outputs.version }}" ]; then
            echo "skip=true" >> $GITHUB_OUTPUT
          else
            echo "skip=false" >> $GITHUB_OUTPUT
          fi

      - name: Set up Docker Buildx
        if: steps.check.outputs.skip == 'false'
        uses: docker/setup-buildx-action@v3

      - name: Log ind på GitHub Container Registry
        if: steps.check.outputs.skip == 'false'
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Byg og push Docker image
        if: steps.check.outputs.skip == 'false'
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          build-args: VERSION=${{ steps.upstream.outputs.version }}
          tags: |
            ghcr.io/${{ github.repository_owner }}/fm-dx-webserver:latest
            ghcr.io/${{ github.repository_owner }}/fm-dx-webserver:${{ steps.upstream.outputs.version }}

      - name: Gem seneste byggede version
        if: steps.check.outputs.skip == 'false'
        run: |
          echo "${{ steps.upstream.outputs.version }}" > .last-built-version
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add .last-built-version
          git commit -m "chore: built version ${{ steps.upstream.outputs.version }}"
          git push
```

---

## Fil 4: `.last-built-version`

Opret filen med følgende indhold (blot én linje):

```
none
```

---

## Fil 5: `README.md`

```markdown
# fm-dx-webserver Docker

Automatisk Docker-wrapper til [fm-dx-webserver](https://github.com/NoobishSVK/fm-dx-webserver).

Dette repo bygger automatisk et nyt Docker image, når der udkommer en ny officiel release.

## Hurtigt i gang

Kør med Docker:

\`\`\`bash
docker run -d \
  -p 8080:8080 \
  --device=/dev/ttyUSB0 \
  ghcr.io/DITBRUGERNAVN/fm-dx-webserver:latest
\`\`\`

Eller med docker-compose:

\`\`\`bash
docker compose up -d
\`\`\`

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
```

---

## Trin efter filerne er oprettet

Udfør følgende kommandoer i projektmappen:

```bash
# 1. Initialiser git
git init

# 2. Tilføj alle filer
git add .

# 3. Første commit
git commit -m "feat: initial Docker wrapper for fm-dx-webserver"

# 4. Opret et nyt tomt GitHub repo kaldet fm-dx-webserver-docker
#    (gør dette manuelt på github.com eller via GitHub CLI:)
gh repo create fm-dx-webserver-docker --public --source=. --remote=origin --push

# Hvis du ikke bruger GitHub CLI, kør i stedet:
# git remote add origin https://github.com/DITBRUGERNAVN/fm-dx-webserver-docker.git
# git branch -M main
# git push -u origin main
```

---

## Vigtige noter til Claude Code

- Brug **GitHub Container Registry (ghcr.io)** – det kræver ingen ekstra tokens, da `GITHUB_TOKEN` er automatisk tilgængeligt i Actions.
- `.last-built-version` bruges til at undgå at genbygge samme version hver dag.
- Workflowet kører dagligt, men kan også startes manuelt via GitHub Actions UI.
- Sørg for at `.github/workflows/` mappen eksisterer, inden du opretter workflow-filen.
