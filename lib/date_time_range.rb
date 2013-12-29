class DateTimeRange < Range

  ALMOST_ISO_8601 = "%Y-%m-%d_%H:%M:%S%:z"

  def to_identifier
    "from-#{min.strftime(ALMOST_ISO_8601)}-to-#{max.strftime(ALMOST_ISO_8601)}"
  end

  def self.from_identifier(identifier)
    from = identifier.match(/^from-(.*?)-to/).captures[0].gsub("_", " ")
    to = identifier.match(/to-(.*?)$/).captures[0].gsub("_", " ")
    DateTimeRange.new(DateTime.parse(from), DateTime.parse(to))
  end

  def to_query
    "[\"#{min.iso8601}\",\"#{max.iso8601}\"]"
  end

end