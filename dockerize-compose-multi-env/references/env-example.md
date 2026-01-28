# .env.example (baseline)

```
# Common
APP_ENV=production
API_PORT=8000
APP_IMAGE=app

# Database
POSTGRES_DB=app
POSTGRES_USER=app
POSTGRES_PASSWORD=changeme
DATABASE_URL=postgresql://app:changeme@db:5432/app

# Cache
REDIS_URL=redis://redis:6379/0

# Secrets (placeholders)
JWT_SECRET=changeme
SENTRY_DSN=

# Production-only
# EXAMPLE_PROD_ONLY=

# Staging-only
# EXAMPLE_STAGING_ONLY=

# Test-only
# EXAMPLE_TEST_ONLY=
```
