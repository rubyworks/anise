class Symbol

  # Create new combination symbol with slash.
  #
  # @example
  #   :foo/:bar  #=> :"foo/bar"
  # 
  def /(other)
    "#{self}/#{other}".to_sym
  end

end
