module ApplicationHelper

  def kramdown(text)
    html = Kramdown::Document.new(text).to_html
    return raw(html)
  end
end
