FROM node:21.6-alpine3.18 AS build

COPY . /app

WORKDIR /app

RUN npm install

FROM node:21.6-alpine3.18 AS app

WORKDIR /app

COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package.json .
COPY --from=build /app/database ./database
COPY --from=build /app/app.js .

EXPOSE 3000
COPY /docker/app/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]

CMD ["npm", "run", "start"]
