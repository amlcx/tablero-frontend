FROM oven/bun:1.3.2-alpine AS builder
WORKDIR /app
COPY package*.json bun.lock* ./
ARG BETTER_AUTH_SECRET
ARG BETTER_AUTH_URL
ARG DATABASE_URL
RUN bun install --frozen-lockfile
COPY . .
RUN bun --bun run build

FROM oven/bun:1.3.2-alpine
WORKDIR /app
COPY --from=builder /app/build build/
COPY --from=builder /app/node_modules node_modules/
COPY package.json .
COPY drizzle.config.ts .
EXPOSE 3001
ENV NODE_ENV=production
ENV PORT=3001
ENV ORIGIN=${ORIGIN}
VOLUME [ "/data" ]
CMD ["bun", "start"]