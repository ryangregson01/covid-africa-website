from django.urls import reverse
from django.test import Client


class DataUrlBoilerplate:
    def setUp(self):
        self.client = Client()
        self.content = self._get_content(self.ENDPOINT)

    def _get_content(self, endpoint):
        response = self.client.get(reverse(f"dashboard:{endpoint}"))
        self.assertEqual(response.status_code, 200)
        return response.json()

    @staticmethod
    def _is_optional(value, type):
        return value is None or isinstance(value, type)

    @staticmethod
    def _is_ordered(a, b):
        if a is not b is not None:
            return a >= b
        return True

    def test_url_returns_data(self):
        """Check whether the URL returns structured data."""

        self.assertTrue(len(self.content) > 0)
        self.assertIsInstance(self.content, list)
