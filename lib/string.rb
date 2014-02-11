class String

  def to_identifier
    self.gsub(/[^a-zA-Z0-9]/, '').downcase
  end

  def to_html_id
    self.gsub(":", "\\:")
  end
end
