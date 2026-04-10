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
