from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/lightingtalks/', include('lighting_talks.urls'))
]
