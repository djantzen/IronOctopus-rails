class String

  def to_identifier
#    self.gsub(/[\s()\{\}_'"-\/]/, '').downcase
    self.gsub(/[^a-zA-Z0-9]/, '').downcase
  end
end
