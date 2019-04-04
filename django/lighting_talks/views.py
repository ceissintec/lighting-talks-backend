from rest_framework import viewsets, mixins
from .models import Submission
from lighting_talks import serializers
from django.shortcuts import get_object_or_404
from rest_framework.exceptions import ValidationError


class SubmissionViewSet(viewsets.GenericViewSet,
                        mixins.ListModelMixin,
                        mixins.CreateModelMixin,
                        mixins.RetrieveModelMixin):
    """Manage submissions in the database"""
    serializer_class = serializers.SubmissionSerializer
    queryset = Submission.objects.all()

    def get_queryset(self):
        """Return only submissions that have been accepted"""
        return self.queryset.filter(is_accepted=True).order_by('title')

    def perform_create(self, serializer):
        serializer.save()

    def get_object(self, pk=None):
        pk_field = self.kwargs[self.lookup_field]
        try:
            return get_object_or_404(
                self.queryset,
                pk=pk_field,
                is_accepted=True)
        except ValueError:
            raise ValidationError
