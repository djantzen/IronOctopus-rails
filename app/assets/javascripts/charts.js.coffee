class this.Charts

  @fetch_data = (chart_panel, url, params) ->
    chart_panel.find(".chart-container").html("")
    chart_panel.find(".loading-indicator").show()

    # http://zargony.com/2012/02/29/google-charts-on-your-site-the-unobtrusive-way
    $.getJSON(url, params, (data) ->
      # Create DataTable from received chart data
      data_table = new google.visualization.DataTable()
      $.each(data.cols, ->
        data_table.addColumn(this))
      data_table.addRows(data.rows)

      formatter = new google.visualization.TableBarFormat({drawZeroLine: true, base: 0, showValue: true, min: -200, max: 200, colorPositive: "green"});
      formatter.format(data_table, 1);

      # Draw the chart
      chart = new google.visualization.ChartWrapper()
      chart.setChartType(data.type)
      console.log(data.options)
      chart.setDataTable(data_table)
      chart.setOption('width', chart_panel.width())
      chart.setOption('height', chart_panel.height())
      chart.setOptions(data.options)

      chart_panel.find(".loading-indicator").hide()
      chart.draw(chart_panel.find(".chart-container")[0], data.options)
    )