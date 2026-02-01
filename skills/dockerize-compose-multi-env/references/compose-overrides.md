# `docker-compose.<env>.yml` (overrides)

```yaml
# docker-compose.prod.yml
services:
  app:
    environment:
      APP_ENV: production
    restart: unless-stopped
```

```yaml
# docker-compose.staging.yml
services:
  app:
    environment:
      APP_ENV: staging
    restart: unless-stopped
```

```yaml
# docker-compose.test.yml
services:
  app:
    environment:
      APP_ENV: test
    ports: []

  tests:
    build:
      context: .
      dockerfile: Dockerfile
    image: ${APP_IMAGE:-app}
    command: ["/bin/sh", "-c", "echo 'set test command'"]
    depends_on:
      app:
        condition: service_started
```

Notes:

- Use `ports: []` in test to avoid exposing to host.
- Add `migrate` or `worker` only if confirmed.
