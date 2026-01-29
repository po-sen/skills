# Dockerfile (Python, multi-stage)

```Dockerfile
# syntax=docker/dockerfile:1.6
ARG PYTHON_VERSION=3.12.2

FROM python:${PYTHON_VERSION}-slim AS builder
WORKDIR /app
ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1

COPY requirements.txt ./
RUN pip install --prefix=/install -r requirements.txt

FROM python:${PYTHON_VERSION}-slim AS runtime
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
RUN useradd -ms /bin/bash app
COPY --from=builder /install /usr/local
COPY . .
USER app
EXPOSE 8000
CMD ["gunicorn", "app.main:app", "-k", "uvicorn.workers.UvicornWorker", "-b", "0.0.0.0:8000"]
```

Notes:

- For Poetry/uv, export a requirements file or install to `/install` in the builder.
- Do not run migrations automatically by default.
