module ApplicationHelper

  def kramdown(text)
    html = Kramdown::Document.new(text).to_html
    return raw(html)
  end

  def group_metrics(activity)
    grouped_metrics = []
    activity.metrics.each_with_index do |metric, i|
      grouped_metrics << [] if (i % 2 == 0)
      grouped_metrics[-1] << metric
    end
    grouped_metrics
  end
end
