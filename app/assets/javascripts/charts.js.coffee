class this.Charts

  @fetch_data = (chart_container, url, params) ->
    chart_container.find(".chart-container").html("")
    chart_container.find(".loading-indicator").show()

    # http://zargony.com/2012/02/29/google-charts-on-your-site-the-unobtrusive-way
    $.getJSON(url, params, (data) ->
      # Create DataTable from received chart data
      table = new google.visualization.DataTable()
      $.each(data.cols, ->
        table.addColumn(this))
      table.addRows(data.rows)
      # Draw the chart
      chart = new google.visualization.ChartWrapper()
      chart.setChartType(data.type)
      chart.setDataTable(table)
      chart.setOptions(data.options)
      chart.setOption('width', chart_container.width())
      chart.setOption('height', chart_container.height())
      chart_container.find(".loading-indicator").hide()
      chart.draw(chart_container.find(".chart-container")[0])
    )