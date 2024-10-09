# Use the official Python image from the Docker Hub
FROM python:3.12-slim
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
# Set the working directory
WORKDIR /app

# Copy Pipfile and Pipfile.lock to the container
COPY Pipfile Pipfile.lock ./

# Install pipenv
RUN pip install pipenv
# Install dependencies
RUN pipenv install --system --deploy --dev --verbose
# Copy the rest of the project files
ADD . ./
# Expose the port the app runs on
EXPOSE 8000

# Command to run the application
#CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
