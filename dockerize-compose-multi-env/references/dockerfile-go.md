# Dockerfile (Go, multi-stage)

```Dockerfile
# syntax=docker/dockerfile:1.6
ARG GO_VERSION=1.22.2

FROM golang:${GO_VERSION}-alpine AS build
WORKDIR /src
RUN apk add --no-cache ca-certificates
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /bin/app ./...

FROM alpine:3.19
RUN addgroup -S app && adduser -S app -G app
COPY --from=build /bin/app /bin/app
USER app
EXPOSE 8080
CMD ["/bin/app"]
```

Notes:

- If CGO is required, use `golang:<version>` and a distroless/base image instead of `alpine`.
- Adjust `EXPOSE` and build package path to match the repo.
