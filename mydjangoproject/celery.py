import os
from celery import Celery

# Set the default Django settings module
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'mydjangoproject.settings')

app = Celery('mydjangoproject')

# Load task modules from all registered Django app configs
app.config_from_object('django.conf:settings', namespace='CELERY')

# Use RabbitMQ as the broker
app.conf.broker_url = 'amqp://guest:guest@localhost//'

# Auto-discover tasks from registered Django apps
app.autodiscover_tasks()
