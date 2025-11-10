# syntax=docker/dockerfile:1
FROM python:3.11-slim

# System deps for OpenCV (used by DeepFace)
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
    libgomp1 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgthread-2.0-0 \
    curl \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Pre-copy requirements to leverage Docker layer caching
COPY requirements.txt /app/requirements.txt
RUN pip install --upgrade pip \
  && pip install -r /app/requirements.txt

# Copy source
COPY . /app

# Create uploads directory
RUN mkdir -p /app/uploads

# Env
ENV PYTHONUNBUFFERED=1
ENV PORT=7860
ENV PYTHONPATH=/app

# Expose port (Hugging Face Spaces uses 7860)
EXPOSE 7860

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:${PORT}/health || exit 1

# Create startup script
RUN echo '#!/bin/bash\n\
echo "Starting Face Recognition Attendance System on port ${PORT}..."\n\
sleep 2\n\
exec uvicorn main:app --host 0.0.0.0 --port ${PORT} --workers 1\n\
' > /app/start.sh && chmod +x /app/start.sh

# Use startup script
CMD ["/app/start.sh"]
