# Use slim Python base image
FROM python:3.11-slim

# Prevent Python from creating .pyc files and buffering output
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install required system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libffi-dev \
    libpq-dev \
    libstdc++6 \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install pip packages
COPY backend/requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY backend /app

# Tell Railway which port to expose
EXPOSE 8000

# Set environment variable for Railway
ENV PORT=8000

# Launch FastAPI app
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
