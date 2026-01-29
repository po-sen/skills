# docker-compose.yml (base)

```yaml
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    image: ${APP_IMAGE:-app}
    environment:
      APP_ENV: ${APP_ENV:-production}
      DATABASE_URL: ${DATABASE_URL}
    ports:
      - "${API_PORT:-8000}:8000"
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - db_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U $$POSTGRES_USER -d $$POSTGRES_DB"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  db_data:
  redis_data:
```

Notes:

- Remove `db`/`redis` if not required.
- Keep secrets in env files, not in YAML.
