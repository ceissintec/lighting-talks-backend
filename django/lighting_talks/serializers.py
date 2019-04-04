from rest_framework import serializers
from .models import Submission


class SubmissionSerializer(serializers.ModelSerializer):
    """ Serializer for Submission object"""
    class Meta:
        model = Submission
        fields = ('first_name', 'last_name', 'title',
                  'description', 'date')
        read_only_fields = ('date',)
