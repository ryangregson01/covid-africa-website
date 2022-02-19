from django.http import JsonResponse
from django.shortcuts import render
from clickhouse_driver import Client

ch_client = Client("covid-database")


def index(request):
    return render(request, "index.html")


def get_covid_data(request):
    results = ch_client.execute("""
        SELECT
            Location,
            toStartOfWeek(UpdateDate) AS Week,
            ceil(avg(NewCases)) AS AvgNewCases
        FROM covid19.updates
        WHERE Continent='Africa'
        GROUP BY
            Location,
            Week
        ORDER BY Week ASC;
    """)
    return JsonResponse(results, safe=False,
                        json_dumps_params={"default": str})


def get_summary_data(request):
    results = ch_client.execute("""
        SELECT
            Location,
            MAX(TotalCases) AS Cases,
            ceil(avg(NewCasesPerMil)) AS NewCases,
            MAX(TotalDeaths) AS TotalDeaths,
            ceil(avg(NewDeathsPerMil)) AS NewDeaths,
            MAX(TotalVaccinations) AS Vaccinations,
            ceil(avg(NewVaccinationsSmoothPerMil)) AS NewVaccinations
        FROM covid19.updates
        WHERE
            Continent='Africa' AND UpdateDate>=today() - 7
        GROUP BY
            Location
        ORDER BY Location DESC;
    """)
    return JsonResponse(results, safe=False,
                        json_dumps_params={"default": str})

def get_weekly_maxs(request):
    results = ch_client.execute("""
        (SELECT TOP 1
            Location,
            ceil(AVG(NewCasesPerMil)) AS newCases
        FROM covid19.updates
        WHERE Continent='Africa' AND UpdateDate>=today() - 7
        GROUP BY Location
        ORDER BY newCases DESC)
        UNION ALL
        (SELECT TOP 1
            Location,
            ceil(AVG(NewDeathsPerMil)) AS newDeaths
        FROM covid19.updates
        WHERE Continent='Africa' AND UpdateDate>=today() - 7
        GROUP BY Location
        ORDER BY newDeaths DESC)
        UNION ALL
        (SELECT TOP 1
            Location,
            ceil(AVG(NewVaccinationsSmoothPerMil)) AS newVacc
        FROM covid19.updates
        WHERE Continent='Africa' AND UpdateDate>=today() - 7
        GROUP BY Location
        ORDER BY newVacc DESC)
    """)
    
    
    # nested query, inner to find max, outer to get country
    # inner gets max num and outer finds corresponding country
    return JsonResponse(results, safe=False,
                        json_dumps_params={"default": str})
