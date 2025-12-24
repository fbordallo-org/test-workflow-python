# Simple API

A simple FastAPI Hello World application.

## Requirements

- Python 3.13+
- uv (package manager)

## Installation

```bash
uv sync
```

## Running locally

```bash
uv run uvicorn simple_api:app --reload
```

The API will be available at http://localhost:8000

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/` | Returns Hello World message |
| GET | `/health` | Returns health status |

## Running tests

```bash
uv run pytest tests
```

## Docker

Build and run with Docker:

```bash
# Build the image
docker build --target release -t simple-api .

# Run the container
docker run -p 8000:8000 simple-api
```

Run tests in Docker:

```bash
docker build --target test -t simple-api-test .
```
