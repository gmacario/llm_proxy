# syntax=docker/dockerfile:1

# Use official Python image as base
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy project files
COPY ollama_proxy.py ./
COPY pyproject.toml ./
COPY uv.lock ./
COPY sample.env ./

# Install pip and uv (for dependency management)
RUN pip install --no-cache-dir uv

# Install dependencies
RUN uv pip install --system --requirement pyproject.toml

# Expose port (change if your app uses a different port)
EXPOSE 11434

# Set environment variables (optional, recommend using .env at runtime)
# ENV TARGET_API_KEY=MY_API_KEY_HERE
# ENV TARGET_URL=http://10.1.204.21:11434

# Default command (update if your entrypoint is different)
CMD ["python", "ollama_proxy.py"]
