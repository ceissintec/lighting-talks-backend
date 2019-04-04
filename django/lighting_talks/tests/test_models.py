from django.test import TestCase
from lighting_talks.models import Submission


class ModelTests(TestCase):
    def test_submission_str(self):
        """Text the submission string representation"""
        submission = Submission.objects.create(
            first_name='Test',
            last_name='Case',
            title='Test title',
            description='Test description'
        )
        self.assertEqual(str(submission), submission.title)
