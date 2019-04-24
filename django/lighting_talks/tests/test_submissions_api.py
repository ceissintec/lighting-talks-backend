from django.test import TestCase
from django.urls import reverse

from rest_framework.test import APIClient
from rest_framework import status

from ..models import Submission
from ..serializers import SubmissionSerializer

SUBMISSION_URL_LIST = reverse('lighting_talks:submission-list')


def create_submission(title, accepted=True):
    return Submission.objects.create(
        first_name="Test",
        last_name="Case",
        title=title,
        description='Description',
        is_accepted=accepted,
        email='test@testing.com'
    )


def submission_url_detail(data):
    return reverse('lighting_talks:submission-detail', kwargs=data)


class PublicLightingTalksApiTests(TestCase):

    def setUp(self):
        self.client = APIClient()

    def test_retrieve_submission_list(self):
        """Test retrieving a list of submissions"""
        create_submission('Lighting talk 1')
        create_submission('Lighting talk 2')
        create_submission('Lighting talk 3')

        submissions = Submission.objects.all().order_by('title')
        serializer = SubmissionSerializer(submissions, many=True)
        res = self.client.get(SUBMISSION_URL_LIST)

        self.assertEqual(res.status_code, status.HTTP_200_OK)
        self.assertEqual(res.data, serializer.data)

    def test_retrieve_all_accepted_submissions(self):
        """
        Tests only retrive submissions which have been previously accepted
        """
        sample_talk = create_submission('Lighting talk 1')
        create_submission('Lighting talk 2')
        create_submission('Lighting talk 3', accepted=False)

        res = self.client.get(SUBMISSION_URL_LIST)

        self.assertEqual(res.status_code, status.HTTP_200_OK)
        self.assertEqual(len(res.data), 2)
        self.assertEqual(res.data[0]['title'], sample_talk.title)

    def test_create_submission_successful(self):
        """Test creating a new submission"""
        payload = {
            'first_name': 'Test',
            'last_name': 'Case',
            'title': 'Test title',
            'description': 'Test description',
            'email': 'test@test.com'
        }
        self.client.post(SUBMISSION_URL_LIST, payload)

        exists = Submission.objects.filter(**payload).exists()

        self.assertTrue(exists)

    def test_create_submission_invalid(self):
        """Test creating an invalid submission fails"""
        payload = {
            'first_name': 'Test',
            'last_name': '',
            'title': '',
            'description': ''
        }
        res = self.client.post(SUBMISSION_URL_LIST, payload)

        self.assertEqual(res.status_code, status.HTTP_400_BAD_REQUEST)

    def test_retrieve_single_submission(self):
        """Test retrieving a single valid submission"""
        submission = create_submission('Lighting Talk 1')
        serializer = SubmissionSerializer(submission)
        create_submission('Lighting Talk 2')
        # Postgres doesn't reset ids to 1 after each test
        payload = {'pk': 6}

        res = self.client.get(submission_url_detail(payload))
        self.assertEqual(res.status_code, status.HTTP_200_OK)
        self.assertEqual(res.data, serializer.data)

    def test_retrieve_single_submission_not_accepted_fails(self):
        """Test retrieving a single valid submission but not accepted fails"""
        create_submission('A lighting talk', accepted=False)
        payload = {'pk': 8}

        exists = Submission.objects.filter(title='A lighting talk').exists()

        res = self.client.get(submission_url_detail(payload))
        self.assertEqual(res.status_code, status.HTTP_404_NOT_FOUND)
        self.assertTrue(exists)

    def test_invalid_submission_detail_fails(self):
        """
        Tests trying to retrieve a submission with an invalid format fails
        """
        payload = {'pk': 'invalid_format'}

        res = self.client.get(submission_url_detail(payload))
        self.assertEqual(res.status_code, status.HTTP_400_BAD_REQUEST)
