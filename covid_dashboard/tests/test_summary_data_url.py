from tests import DataUrlBoilerplate

from django.test import TestCase


class SummaryDataUrlTestCase(DataUrlBoilerplate, TestCase):
    ENDPOINT = "get_summary_data"

    def test_url_returns_valid_values(self):
        """Check whether the URL returns valid values."""

        for row in self.content:
            self.assertIsInstance(row[0], str)
            self.assertTrue(self._is_optional(row[1], float))
            self.assertTrue(self._is_optional(row[2], int))
            self.assertTrue(self._is_optional(row[3], float))
            self.assertTrue(self._is_optional(row[4], float))
            self.assertTrue(self._is_optional(row[5], int))
            self.assertTrue(self._is_optional(row[6], float))
            self.assertTrue(self._is_optional(row[7], float))
            self.assertTrue(self._is_optional(row[8], int))
            self.assertTrue(self._is_optional(row[9], float))
            self.assertTrue(self._is_optional(row[10], float))

            # Total instances is less than new instances for per 100k values
            self.assertTrue(self._is_ordered(row[3], row[4]))
            self.assertTrue(self._is_ordered(row[6], row[7]))
            self.assertTrue(self._is_ordered(row[9], row[10]))

    def test_url_returns_sorted_locations(self):
        """Check whether the URL returns rows sorted by location."""

        previous = None
        for location, *_ in self.content:
            if previous is not None:
                self.assertTrue(location <= previous)
            previous = location
