# CI baseline (GitHub Actions)

Use this as a minimal baseline and adapt to the repo's actual boundary commands. Prefer a unified
entrypoint when available; otherwise use separate steps when multiple languages exist.

```yaml
name: boundaries

on:
  pull_request:
  push:
    branches:
      - main
      - master

jobs:
  boundaries:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "BOUNDARIES_DONE=false" >> $GITHUB_ENV

      - name: Setup Node
        if: ${{ hashFiles('package.json') != '' }}
        uses: actions/setup-node@v4
        with:
          node-version: "20"
          cache: "npm"

      - name: Setup Python
        if: ${{ hashFiles('pyproject.toml', 'requirements.txt') != '' }}
        uses: actions/setup-python@v5
        with:
          python-version: "3.12"
          cache: "pip"

      - name: Setup Go
        if: ${{ hashFiles('go.mod') != '' }}
        uses: actions/setup-go@v5
        with:
          go-version: "1.22"
          cache: true

      - name: Install dependencies
        run: |
          if [ -f package.json ]; then npm ci; fi
          if [ -f requirements.txt ]; then
            python -m pip install -r requirements.txt
          elif [ -f pyproject.toml ]; then
            python -m pip install -U pip
          fi
          if [ -f go.mod ]; then go mod download; fi

      - name: Boundary check (Repo entrypoint, if present)
        run: |
          set -e
          if make -qn lint-boundaries >/dev/null 2>&1; then
            make lint-boundaries
            echo "BOUNDARIES_DONE=true" >> $GITHUB_ENV
            exit 0
          fi
          if [ -f package.json ]; then
            # --if-present => do nothing (success) if missing
            npm run -s lint:boundaries --if-present
            # If script exists, npm returns 0 after running it; mark as done.
            if node -e "p=require('./package.json');process.exit(p.scripts&&p.scripts['lint:boundaries']?0:1)"; then
              echo "BOUNDARIES_DONE=true" >> $GITHUB_ENV
              exit 0
            fi
          fi
          echo "No unified boundary entrypoint found; falling back to per-language checks."

      - name: Boundary check (Node)
        if: ${{ env.BOUNDARIES_DONE != 'true' && hashFiles('package.json') != '' }}
        run: npm run lint:boundaries

      - name: Boundary check (Python)
        if:
          ${{ env.BOUNDARIES_DONE != 'true' && hashFiles('pyproject.toml', 'requirements.txt') != ''
          }}
        run: |
          if command -v lint-imports >/dev/null 2>&1; then
            lint-imports
          else
            echo "lint-imports not installed. Prefer adding a unified repo entrypoint (make lint-boundaries) or installing import-linter." && exit 1
          fi

      - name: Boundary check (Go)
        if: ${{ env.BOUNDARIES_DONE != 'true' && hashFiles('go.mod') != '' }}
        run: |
          if ! command -v golangci-lint >/dev/null 2>&1; then
            go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
            echo "$(go env GOPATH)/bin" >> $GITHUB_PATH
          fi
          golangci-lint run
```

Notes:

- Replace the boundary commands with the repo's actual entrypoints.
- If you use a single unified command (e.g., `make lint-boundaries`), use one step instead.
- For multi-language repos, keep each boundary checker in its own step so all must pass.
