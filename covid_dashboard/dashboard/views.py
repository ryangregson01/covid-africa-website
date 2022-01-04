from django.http import JsonResponse
from django.shortcuts import render
from clickhouse_driver import Client

ch_client = Client("covid-database")


def index(request):
    return render(request, "index.html")


def get_covid_data(request):
    results = ch_client.execute("""
        SELECT
            toStartOfWeek(UpdateDate) AS Week,
            ceil(avg(NewCases)) AS AvgNewCases
        FROM covid19.updates
        WHERE Continent='Africa'
        GROUP BY Week
        ORDER BY Week DESC
        LIMIT 100;
    """)
    return JsonResponse(results, safe=False,
                        json_dumps_params={"default": str})
