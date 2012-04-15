module StringUtils
  
  def as_identifier(str)
    str ? str.gsub(/[^a-zA-Z0-9]/, '').downcase : nil
  end

end
