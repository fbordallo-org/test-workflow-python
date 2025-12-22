FROM python:3.13-slim as build

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set working directory
WORKDIR /app

# Copy project files
COPY pyproject.toml .
COPY .python-version .

# Install dependencies
RUN uv sync --no-dev --no-install-project

# Copy application code
COPY main.py .

FROM build as test

# Install test dependencies
RUN uv sync --dev --no-install-project

# Run tests
COPY tests ./tests
RUN uv run pytest tests

FROM build as release

# Expose the port
EXPOSE 8000

# Run the application
CMD ["uv", "run", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
