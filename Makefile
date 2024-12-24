run_uwsgi:
    python manage.py collectstatic --no-input -v 0 && uwsgi --http :8000 --enable-threads --http-keepalive --processes 4 --wsgi-file mydjangoproject/wsgi.py --check-static /public_assets --static-map /static=/public_assets --static-map /media=/app/media --static-map /favicon.ico=/public_assets/favicon.ico --logto /dev/stdout --logto2 /dev/stderr --mimefile /etc/mime.types --buffer-size 32768

run_worker:
    celery -A mydjangoproject worker -B -E --loglevel=warning --without-gossip --heartbeat-interval 15 -n default_queue@%h

migrate:
    python manage.py migrate
