# syntax=docker/dockerfile:1
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    GRADIO_SERVER_NAME=0.0.0.0 \
    GRADIO_SERVER_PORT=8080 \
    HF_HOME=/home/app/.cache/huggingface \
    HF_HUB_DISABLE_TELEMETRY=1

# curl for healthcheck
RUN apt-get update && apt-get install -y --no-install-recommends curl \
  && rm -rf /var/lib/apt/lists/*

# Non-root user
RUN useradd -m -u 10001 app
WORKDIR /app

# Install deps (cache-friendly)
COPY requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt

# Copy app
COPY . /app

EXPOSE 8080

# Healthcheck hits Gradio root
HEALTHCHECK --interval=30s --timeout=3s --start-period=20s --retries=3 \
  CMD curl -fsS http://127.0.0.1:8080/ || exit 1

USER app
CMD ["python", "app.py"]
