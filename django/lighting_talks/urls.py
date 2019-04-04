from django.urls import path, include
from rest_framework.routers import DefaultRouter
from lighting_talks import views

router = DefaultRouter()
router.register('submission', views.SubmissionViewSet)

app_name = 'lighting_talks'
urlpatterns = [
    path('', include(router.urls))
]
