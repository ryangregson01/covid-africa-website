from tests import DataUrlBoilerplate

from django.test import TestCase


class WeeklyMaximaUrlTestCase(DataUrlBoilerplate, TestCase):
    ENDPOINT = "get_weekly_maxs"

    def test_url_returns_valid_values(self):
        """Check whether the URL returns valid values."""

        # Each chunk is a different top 5
        for chunk in self.content:
            for country in chunk:
                # location
                self.assertIsInstance(country[0], str)
                # value
                self.assertIsInstance(country[1], float)

    def test_url_returns_sorted_values(self):
        """Check whether the URL returns rows sorted by size of value."""

        for chunk in self.content:
            previous = None
            for country in chunk:
                if previous is not None:
                    self.assertTrue(previous >= country[1])
                previous = country[1]
