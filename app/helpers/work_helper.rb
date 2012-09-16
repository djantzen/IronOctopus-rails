module WorkHelper

  def get_recorded_value(work, metric)
    metric_name = metric.name.downcase
    value = eval("work.measurement.#{metric_name}")
    [value, 'None']
  end
end
