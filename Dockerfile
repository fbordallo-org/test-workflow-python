FROM python:3.13-slim AS build

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Create non-root user
RUN useradd --create-home --shell /bin/bash appuser

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

# Change ownership to non-root user
RUN chown -R appuser:appuser /app

FROM build AS test

# Install test dependencies
RUN uv sync --dev

# Run tests
COPY tests ./tests
RUN uv run pytest tests

FROM build AS release

# Set environment variables for production
ENV MY_PROD_ENVVAR=production_value

# Switch to non-root user
USER appuser

# Expose the port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

# Run the application
CMD ["uv", "run", "uvicorn", "simple_api:app", "--host", "0.0.0.0", "--port", "8000"]
