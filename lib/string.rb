class String
  
  def to_identifier
    self.gsub(/[\s()\{\}_'"-]/, '').downcase
  end
end
