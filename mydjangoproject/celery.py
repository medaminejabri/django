import os
from celery import Celery

# Set the default Django settings module
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'mydjangoproject.settings')

app = Celery('mydjangoproject')

# Load task modules from all registered Django app configs
app.config_from_object('django.conf:settings', namespace='CELERY')

# Auto-discover tasks from registered Django apps
app.autodiscover_tasks()

# Make sure to include the broker URL again if you need to
app.conf.broker_url = 'amqp://guest:guest@rabbitmq:5672// '
app.conf.result_backend = 'rpc://'
