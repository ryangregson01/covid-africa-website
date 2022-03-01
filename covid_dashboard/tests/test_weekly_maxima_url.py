from tests import DataUrlBoilerplate

from django.test import TestCase


class WeeklyMaximaUrlTestCase(DataUrlBoilerplate, TestCase):
    ENDPOINT = "get_weekly_maxs"
    N_TOP = 5

    @staticmethod
    def _chunk(size, sliceable):
        for offset in range(0, len(sliceable), size):
            yield sliceable[offset:offset+size]

    def test_url_returns_valid_values(self):
        """Check whether the URL returns valid values."""

        for chunk in self._chunk(self.N_TOP, self.content):
            for location, value in chunk:
                self.assertIsInstance(location, str)
                self.assertIsInstance(value, float)

    def test_url_returns_sorted_values(self):
        """Check whether the URL returns rows sorted by week."""

        for chunk in self._chunk(self.N_TOP, self.content):
            previous = None
            for location, value in chunk:
                if previous is not None:
                    self.assertTrue(previous >= value)
                previous = value
