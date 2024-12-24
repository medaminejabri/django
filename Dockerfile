# Use the official Python image from the Docker Hub
FROM python:3.12-slim

# Set environment variables to avoid Python bytecode generation and buffer flushing
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory in the container
WORKDIR /app

# Install system dependencies, including GDAL and other essential tools
RUN set -ex \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
  sudo \
  make \
  curl \
  gcc \
  unzip \
  git \
  jq \
  openssh-client \
  gettext \
  procps \
  python3-dev \
  postgresql-client \
  wkhtmltopdf \
  nano \
  gdal-bin \
  libgdal-dev \
  && rm -rf /var/lib/apt/lists/*  # Clean up apt cache to reduce image size

# Upgrade pip and install pipenv globally
RUN pip install --upgrade pip && pip install pipenv

# Copy Pipfile and Pipfile.lock to the container for pipenv installation
COPY Pipfile Pipfile.lock ./

# Install Python dependencies using pipenv
RUN pipenv install --system --deploy --dev --verbose

# Create a user for running the application
RUN groupadd -g 9898 appuser && useradd -r -u 9898 -g appuser appuser -s /bin/bash
RUN usermod -aG sudo appuser
RUN mkdir -p /home/appuser && chown -R appuser:appuser /home/appuser

# Fix potential issues with the directories
RUN mkdir -p /home/celery/var/run
RUN mkdir -p /home/appuser && chown -R appuser:appuser /home/appuser
RUN mkdir -p /public_assets && chown -R appuser:appuser /public_assets

# Ensure appuser has access to the relevant directories
RUN chown -R appuser:appuser /home/celery /home/appuser /public_assets
RUN chmod -R 755 /home/celery/var/run

# Copy the rest of the application files into the container
ADD . ./

# Set permissions for the app folder and environment files
RUN chown -R appuser:appuser /app \
    && chown -R appuser:appuser /etc/environment \
    && chown -R appuser:appuser /public_assets

# Grant sudo privileges to the appuser without password
RUN echo "appuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the non-root user 'appuser' for security
USER appuser

# Expose the port the app runs on
EXPOSE 8000

# Command to run the application (uncomment as needed)
# CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
