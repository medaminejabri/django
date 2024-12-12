from celery import Celery

# Set the default Django settings module for the 'celery' program.
import os
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'mydjangoproject.settings')

app = Celery('mydjangoproject')

# Using a string here means the worker doesn't have to serialize
# the configuration object to child processes.
app.config_from_object('django.conf:settings', namespace='CELERY')

# Autodiscover tasks from installed apps
app.autodiscover_tasks()

@app.task(bind=True)
def debug_task(self):
    print(f'Request: {self.request!r}')
