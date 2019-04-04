from django.db import models

# Create your models here.


class Submission(models.Model):
    first_name = models.CharField(max_length=125)
    last_name = models.CharField(max_length=125)
    title = models.CharField(max_length=255)
    description = models.TextField()
    is_accepted = models.BooleanField(default=False)
    scheduled_date = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return self.title
