FROM node:20-alpine

RUN apk add --no-cache git cmake make g++ python3 alsa-utils

WORKDIR /app

RUN git clone --depth 1 https://github.com/NoobishSVK/fm-dx-webserver.git .

RUN npm install --production

EXPOSE 8080

CMD ["node", "index.js"]
