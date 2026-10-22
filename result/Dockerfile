FROM node:22-slim@sha256:de170b39439eb0e5a3444ad7d60b015614a381e10fecae2e30ec9e735122f38d

# curl for health checks, tini so the app shuts down cleanly
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl tini && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd --system --gid 10001 appgroup && \
    useradd --system --uid 10001 --gid appgroup --create-home appuser

WORKDIR /usr/local/app

# nodemon is only used by docker-compose for local development
RUN npm install -g nodemon

COPY package*.json ./

RUN npm ci && \
    npm cache clean --force && \
    mv /usr/local/app/node_modules /node_modules

COPY --chown=appuser:appgroup . .

# A non-root user cannot listen on ports below 1024 on Kubernetes, so use 8080
ENV PORT=8080
EXPOSE 8080

USER 10001:10001

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["node", "server.js"]
