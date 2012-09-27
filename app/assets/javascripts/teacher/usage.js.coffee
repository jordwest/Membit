if window.charts?
  jQuery(document).ready ->
    device_usage = new Highcharts.Chart({
      chart: {
          renderTo: 'device-usage-chart',
          type: 'bar'
        },
        title: {
          text: 'Device Usage'
        },
        xAxis: {
          categories: ['Desktop and Mobile', 'Desktop Only', 'Mobile Only', 'Never Logged In']
        },
        yAxis: {
          title: {text: 'Number of Users'}
        },
        series: [{
          name: 'Users',
          data: window.charts.device_usage
        }]
      })

    user_review_count = new Highcharts.Chart({
      chart: {
        renderTo: 'user-review-count',
        type: 'bar'
      },
      title: {text: 'User review count'},
      xAxis: {
        title: {text: '# of reviews'}
        categories: _.keys(window.charts.user_review_count)
      },
      yAxis: {
        title: {text: 'Number of users'}
      },
      series: [{
        name: 'Users',
        data: _.values(window.charts.user_review_count)
      }]
    })

    reviews_over_semester = new Highcharts.Chart({
      chart: {
        renderTo: 'reviews-over-semester',
        type: 'spline'
      },
      title: {text: 'Reviews over the semester'},
      xAxis: {
        title: {text: 'Week of semester'}
        categories: _.map(window.charts.reviews_over_semester, (val) ->
          val.week
        )
      },
      yAxis: {
        title: {text: 'Average # of reviews'}
      },
      series: [
        {
          name: 'Average Reviews for All Users',
          data: _.map(window.charts.reviews_over_semester, (val) ->
            val.total
          )
        },
        {
        name: 'Active User Average Reviews',
        data: _.map(window.charts.reviews_over_semester, (val) ->
          val.active
        )
        },
        {
        name: 'Inactive User Average Reviews',
        data: _.map(window.charts.reviews_over_semester, (val) ->
          val.inactive
        )
        },
      ]
    })

    reviews_since_registering = new Highcharts.Chart({
    chart: {
      renderTo: 'reviews-since-registering',
      type: 'spline'
    },
    title: {text: 'Reviews since registering'},
    xAxis: {
      title: {text: 'Days since registering'}
      categories: _.map(window.charts.reviews_since_registering, (val) ->
        val.label
      )
    },
    yAxis: {
      title: {text: 'Average # of reviews'}
    },
    series: [
      {
        name: 'Average Reviews for All Users',
        data: _.map(window.charts.reviews_since_registering, (val) ->
          val.average
        )
      },
      {
        name: 'Active User Average Reviews',
        data: _.map(window.charts.reviews_since_registering, (val) ->
          val.average_active
        )
      },
      {
        name: 'Inactive User Average Reviews',
        data: _.map(window.charts.reviews_since_registering, (val) ->
          val.average_inactive
        )
      },
      {
      name: 'Users Registered',
      data: _.map(window.charts.reviews_since_registering, (val) ->
        val.total_users
      )
      },
    ]
    })