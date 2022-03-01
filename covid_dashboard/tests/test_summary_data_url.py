from tests import DataUrlBoilerplate

from django.test import TestCase


class SummaryDataUrlTestCase(DataUrlBoilerplate, TestCase):
    ENDPOINT = "get_summary_data"

    def test_url_returns_valid_values(self):
        """Check whether the URL returns valid values."""

        for row in self.content:
            self.assertIsInstance(row[0], str)
            self.assertTrue(self._is_optional(row[1], int))
            self.assertTrue(self._is_optional(row[2], float))
            self.assertTrue(self._is_optional(row[3], int))
            self.assertTrue(self._is_optional(row[4], float))
            self.assertTrue(self._is_optional(row[5], int))
            self.assertTrue(self._is_optional(row[6], float))

            # Total instances is less than new instances
            self.assertTrue(self._is_ordered(row[1], row[2]))
            self.assertTrue(self._is_ordered(row[3], row[4]))
            self.assertTrue(self._is_ordered(row[5], row[6]))

    def test_url_returns_sorted_locations(self):
        """Check whether the URL returns rows sorted by location."""

        previous = None
        for location, *_ in self.content:
            if previous is not None:
                self.assertTrue(location <= previous)
            previous = location
