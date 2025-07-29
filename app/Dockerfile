FROM node:24-alpine

WORKDIR /app
COPY ./ /app
RUN npm install
RUN apk add curl

CMD ["npm","start"]