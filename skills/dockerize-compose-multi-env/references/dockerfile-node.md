# Dockerfile (Node, multi-stage)

```Dockerfile
# syntax=docker/dockerfile:1.6
ARG NODE_VERSION=20.11.1

FROM node:${NODE_VERSION}-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json* pnpm-lock.yaml* yarn.lock* ./
# Choose ONE install method:
# RUN npm ci
# RUN corepack enable && pnpm i --frozen-lockfile
# RUN corepack enable && yarn install --frozen-lockfile

FROM node:${NODE_VERSION}-alpine AS build
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
# RUN npm run build

FROM node:${NODE_VERSION}-alpine AS prod-deps
WORKDIR /app
COPY package.json package-lock.json* pnpm-lock.yaml* yarn.lock* ./
# Choose ONE install method:
# RUN npm ci --omit=dev
# RUN corepack enable && pnpm i --frozen-lockfile --prod
# RUN corepack enable && yarn install --frozen-lockfile --production

FROM node:${NODE_VERSION}-alpine AS runtime
ENV NODE_ENV=production
WORKDIR /app
RUN addgroup -S app && adduser -S app -G app
COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY --from=build /app/package.json ./
USER app
EXPOSE 3000
CMD ["node", "dist/index.js"]
```

Notes:

- If no build step, remove the build stage and copy source instead.
- If using a different entrypoint, update `CMD`.
