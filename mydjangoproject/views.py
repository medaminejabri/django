# myapp/views.py
from django.http import HttpResponse

def simple_page(request):
    return HttpResponse("<h1>Welcome to the Simple Page!</h1>")
