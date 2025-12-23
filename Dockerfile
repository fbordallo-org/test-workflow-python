FROM python:3.13-slim AS build

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set working directory
WORKDIR /app

# Copy project files
COPY pyproject.toml .
COPY .python-version .
COPY README.md .

# Copy application code
COPY src ./src

# Install dependencies and project
RUN uv sync --no-dev

FROM build AS test

# Install test dependencies
RUN uv sync --dev

# Run tests
COPY tests ./tests
RUN uv run pytest tests

FROM build AS release

# Set environment variables for production
ENV MY_PROD_ENVVAR=production_value

# Expose the port
EXPOSE 8000

# Run the application
CMD ["uv", "run", "uvicorn", "simple_api:app", "--host", "0.0.0.0", "--port", "8000"]
