# Use the official Python image from the Docker Hub
FROM python:3.12-slim
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
# Set the working directory
WORKDIR /app
RUN set -ex \
  && apt-get update \
  && apt-get install -qq -y --no-install-recommends \
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
  python-gdal \
  python3-dev \
  postgresql-client \
  wkhtmltopdf \
  nano \
  && pip install --upgrade pip \
  && pip install pipenv \
  && rm -rf /var/lib/apt/lists/*

# Copy Pipfile and Pipfile.lock to the container
COPY Pipfile Pipfile.lock ./

RUN pipenv install --system --deploy --dev --verbose
# Add to your Dockerfile
RUN apt-get update && apt-get install -y postgresql-client
RUN groupadd -g 9898 appuser && useradd -r -u 9898 -g appuser appuser -s /bin/bash
RUN usermod -aG sudo appuser
RUN mkdir /home/appuser && chown -R appuser /home/appuser
RUN mkdir -p /home/celery/var/run
RUN chown -R appuser:appuser /home/celery/var/run && chmod 755 /home/celery/var/run
RUN mkdir /public_assets

# Copy the rest of the project files
ADD . ./
RUN chown -R appuser:appuser /app \
    && chown -R appuser:appuser /etc/environment \
    && chown -R appuser:appuser /public_assets

RUN echo "appuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER appuser
# Expose the port the app runs on
EXPOSE 8000

# Command to run the application
#CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
