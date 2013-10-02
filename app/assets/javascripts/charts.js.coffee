class this.Charts

  @fetch_data = (chart_panel, url, params) ->
    chart_panel.find(".chart-container").html("")
    chart_panel.find(".loading-indicator").show()

    # http://zargony.com/2012/02/29/google-charts-on-your-site-the-unobtrusive-way
    $.getJSON(url, params, (data) ->
      # Create DataTable from received chart data
      data_table = new google.visualization.DataTable()

      $.each(data.cols, (col_index, col)->
        if this["type"] == "date"
          # Vivify dates so we can use Google Visualization Date magic
          $.each(data.rows, (row_index, row) ->
            data.rows[row_index][col_index] = new Date(row[col_index]))
        data_table.addColumn(col))

      data_table.addRows(data.rows)

      if data.formatter
        if data.formatter.type == "TableBarFormat"
          formatter = new google.visualization.TableBarFormat(data.formatter.options)
        formatter.format(data_table, 1);

      # Draw the chart
      chart = new google.visualization.ChartWrapper()
      chart.setChartType(data.type)
      chart.setDataTable(data_table)
      chart.setOptions(data.options)
      chart.setOption('width', chart_panel.width())
      chart.setOption('height', chart_panel.height())

      chart_panel.find(".loading-indicator").hide()
      chart.draw(chart_panel.find(".chart-container")[0])
    )

    @fetch_multi_data = (chart_panels, url, params) ->
      $.each(chart_panels, (name, element)->
        element.find(".chart-container").html("")
        element.show()
        element.find(".loading-indicator").show())

      # http://zargony.com/2012/02/29/google-charts-on-your-site-the-unobtrusive-way
      $.getJSON(url, params, (data) ->

        $.each(data, (key, stats)->
          data_table = new google.visualization.DataTable()
          $.each(stats.cols, (col_index, col)->
            if this["type"] == "date"
              # Vivify dates so we can use Google Visualization Date magic
              $.each(stats.rows, (row_index, row) ->
                stats.rows[row_index][col_index] = new Date(row[col_index]))
            data_table.addColumn(col))

          sum = 0
          $.each(stats.rows, (index, row) ->
            sum += row[1])
          if sum == 0
            chart_panels[key].hide()
          else
            data_table.addRows(stats.rows)
            chart = new google.visualization.ChartWrapper()
            chart.setChartType(stats.type)
            chart.setDataTable(data_table)
            chart.setOptions(stats.options)
            chart.setOption('width', chart_panels[key].width())
            chart.setOption('height', chart_panels[key].height())
            chart_panels[key].find(".loading-indicator").hide()
            chart.draw(chart_panels[key].find(".chart-container")[0])
        )

      )
