module WorkHelper

  def get_recorded_value(work, metric)
    #TODO get the original unit from the activity_set via routine, joining on activity and distinct-ing
    metric_name = metric.name.downcase
    value = eval("work.measurement.#{metric_name}")
    [value, 'None']
  end
end
