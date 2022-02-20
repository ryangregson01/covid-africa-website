
function create_summary_table(summaryContent) {
    var dataset = summaryContent;
    $('#all-countries-table').DataTable( {
        "scrollY":        "250px",
        "scrollCollapse": true,
        "paging":         false,
        "data": dataset,
        "columns": [
            { "title": "Country" },
            { "title": "Cases" },
            { "title": "New Cases" },
            { "title": "Deaths" },
            { "title": "New Deaths" },
            { "title": "Vaccinated" },
            { "title": "New Vaccinations" },
        ],
        columnDefs: [
            {targets: [1,3,5],
                className: 'dt-center',
                render: function (data, type, row) {
                    var color = 'black';
                    return '<span style="color:' + color + '">' + data + '</span>';
                }
            },
            {targets: [2,4],
                className: 'dt-center',
                render: function ( data, type, row ) {
                    var color = 'black';
                    if (data < 0) {
                    color = 'green';
                    } 
                    if (data > 0) {
                    color = 'red';
                    }
                    return '<span style="color:' + color + '">' + data + '</span>';
                }
            },
            {targets: 6,
                className: 'dt-center',
                render: function ( data, type, row ) {
                    var color = 'black';
                    if (data > 0) {
                    color = 'green';
                    }
                    return '<span style="color:' + color + '">' + data + '</span>';
                }
            }
        ]
    } );
}


function insert_weekly_maxs(weeklyMaxsContent) {
    var box_type = ["case", "death", "vacc"];
    weeklyMaxsContent.forEach((item, index) => {
        var i = Math.floor(index / 5) // first 5 use "case", next 5 use "death"...

        var newDiv = document.createElement('div')
        
        var boxSpanCountry = document.createElement('span')
        boxSpanCountry.innerHTML = item[0];

        var boxSpanNum = document.createElement('span')
        boxSpanNum.innerHTML = "  +"+item[1];
       
        newDiv.appendChild(boxSpanCountry);
        newDiv.appendChild(boxSpanNum);
        document.getElementById(box_type[i] + '-box').appendChild(newDiv);
    });
}


function draw_map(content) {

    var location_cases = {}

    content.forEach((row) => {
        var location_ = row[0];
        var n_cases = row[2];

        var cur_location = location_cases[location_];
        if (cur_location === undefined) {
            location_cases[location_] = {
                name: location_,
                data: [n_cases],
            };
        } else {
            cur_location.data.push(n_cases)
        }
    });

    // Dictionary from Highcharts hc-key mappings from country names
    var convert = {'Uganda':'ug', 'Nigeria':'ng',
        'Sao Tome and Principe':'st', 'Tanzania':'tz', 'Sierra Leone':'sl',
        'Guinea-Bissau':'gw', 'Cape Verde':'cv', 'Seychelles':'sc',
        'Tunisia':'tn', 'Madagascar':'mg', 'Kenya':'ke',
        'Democratic Republic of Congo':'cd', 'France':'fr', 'Mauritania':'mr',
        'Algeria':'dz', 'Eritrea':'er', 'Equatorial Guinea':'gq',
        'Mauritius':'mu', 'Senegal':'sn', 'Comoros':'km',
        'Ethiopia':'et', 'Cote d\'Ivoire':'ci', 'Ghana':'gh',
        'Zambia':'zm', 'Namibia':'na', 'Rwanda':'rw',
        'Somaliland':'sx', 'Somalia':'so', 'Cameroon':'cm',
        'Congo':'cg', 'Western Sahara':'eh', 'Benin':'bj',
        'Burkina Faso':'bf', 'Togo':'tg', 'Niger':'ne',
        'Libya':'ly', 'Liberia':'lr', 'Malawi':'mw',
        'Gambia':'gm', 'Chad':'td', 'Gabon':'ga',
        'Djibouti':'dj', 'Burundi':'bi', 'Angola':'ao',
        'Guinea':'gn', 'Zimbabwe':'zw', 'South Africa':'za',
        'Mozambique':'mz', 'Eswatini':'sz', 'Mali':'ml',
        'Botswana':'bw', 'Sudan':'sd', 'Morocco':'ma',
        'Egypt':'eg', 'Lesotho':'ls', 'South Sudan':'ss',
        'Central African Republic':'cf'
    }

    var map_arr = []
    for (var key in location_cases) {
        var hc_key = convert[key];
        if (hc_key != undefined) {
            var country = location_cases[key];
            // For seeing all cases on map
            var summed_cases = country.data.reduce((a, b) => a+b, 0);
            // Finding cases in most recent week
            var all_cases_arr = country.data;
            var recent_week_cases = all_cases_arr[all_cases_arr.length-1];

            if (recent_week_cases > 0 && recent_week_cases != null) {
                map_arr.push([hc_key, recent_week_cases]);
            } else {
                map_arr.push([hc_key, 0]);
            }
        }
    }

    Highcharts.mapChart('choropleth', {
        chart: {
            map: 'custom/africa',
            height: (9/16*100)+'%'
        },

        title: {
            text: 'Interactive Map'
        },

        /* For when data is normalised
        colorAxis: {
            minColor: '#80ff80',
            maxColor: '#ff8080'
        }, */

        series: [{
            data: map_arr,
            name: 'Weekly cases',
            color: '#b3b3b3',
            states: {                
                hover: {
                    color: '#cccccc',
                    borderColor: 'red'
                }
            },
            dataLabels: {
                enabled: true,
                format: '{point.name}'
            }
        }]
    });
}

function draw_average_cases(content) {

var location_cases = {};
var dates = [];
var last_date = undefined;

content.forEach((row) => {
    var location_ = row[0];
    var datestamp = row[1];
    var n_cases = row[2];

    var cur_location = location_cases[location_];
    if (cur_location === undefined) {
        location_cases[location_] = {
            name: location_,
            data: [n_cases],
            date_recorded: [datestamp]
        };
    } else {
        cur_location.data.push(n_cases);
        cur_location.date_recorded.push(datestamp);
    }

    if (datestamp != last_date) {
        last_date = datestamp;
        dates.push(datestamp);
    }
});

var main_data = []
const countries = Object.keys(location_cases);
for (var i=0; i < countries.length; i += 1) {
    var country = countries[i]
    var xValues = location_cases[country].date_recorded
    var yValues = location_cases[country].data

    var data = [{
        type: 'scatter',
        name: country,
        meta: [country],
        x: xValues,
        y: yValues,
        mode: 'lines',
        hovertemplate: '%{x} <br> %{meta[0]}: %{y} cases <extra></extra>'
    }];

    main_data.push(data[0])
}

var layout = {
    title: 'Average Number of New Cases per Week',
    height: 600,
    xaxis: {
        showgrid: false,
        linecolor: 'black',
        rangeselector: {buttons: [
            {
                count: 1,
                label: '1m',
                step: 'month',
                stepmode: 'backward'
            },
            {
                count: 3,
                label: '3m',
                step: 'month',
                stepmode: 'backward'
            },
            {
                count: 6,
                label: '6m',
                step: 'month',
                stepmode: 'backward'
            },
            {
                count: 1,
                label: '1y',
                step: 'year',
                stepmode: 'backward'
            },
            {
                step: 'all'
            }
        ]}
    },
    yaxis: {
        title: {text: 'Number of New Cases'}
    },
    hovermode: 'closest',
    hoverlabel: {bgcolor: 'white'},
    legend: {text: 'country'},
};

Plotly.newPlot("average-cases", main_data, layout);
};