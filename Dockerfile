# Use a slim Python image
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system deps (sqlite included), build essentials for sklearn wheels if needed
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY . .

# Ensure data directories exist (Fly volumes should mount to /data)
RUN mkdir -p /data/models /data/logs

EXPOSE 8080

# Use gunicorn for production
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8080", "main:app"]
