# myapp/urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('', views.simple_page, name='simple_page'),
]
