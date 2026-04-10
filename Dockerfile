FROM node:20-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates git cmake make g++ python3 alsa-utils udev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone --depth 1 https://github.com/NoobishSVK/fm-dx-webserver.git .

RUN npm install --production

EXPOSE 8080

CMD ["node", "index.js"]
