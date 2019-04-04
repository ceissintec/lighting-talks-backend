from rest_framework import viewsets, mixins
from .models import Submission
from lighting_talks import serializers


class SubmissionViewSet(viewsets.GenericViewSet,
                        mixins.ListModelMixin,
                        mixins.CreateModelMixin):
    """ Manage submissions in the database"""
    serializer_class = serializers.SubmissionSerializer
    queryset = Submission.objects.all()

    def get_queryset(self):
        """Return only submissions that have been accepted"""
        return self.queryset.filter(is_accepted=True).order_by('title')

    def perform_create(self, serializer):
        serializer.save()
