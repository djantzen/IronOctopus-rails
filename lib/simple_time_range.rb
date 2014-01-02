class SimpleTimeRange < Range

  ALMOST_ISO_8601 = "%H:%M:%S"

  def to_identifier
    "from-#{min.to_s}-to-#{max.to_s}"
  end

  def self.from_identifier(identifier)
    from = identifier.match(/^from-(.*?)-to/).captures[0]
    to = identifier.match(/to-(.*?)$/).captures[0]
    SimpleTimeRange.new(SimpleTime.parse(from), SimpleTime.parse(to))
  end

  def to_query
    "[\"#{min.to_s}\",\"#{max.to_s}\"]"
  end

end