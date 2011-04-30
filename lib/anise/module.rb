class Module
  # Module extension to return attribute methods. These are all methods
  # that start with `attr_`. This method can be overriden in special cases
  # to work with attribute annotations.
  def attribute_methods
    list = []
    public_methods(true).each do |m|
      list << m if m.to_s =~ /^attr_/
    end
    protected_methods(true).each do |m|
      list << m if m.to_s =~ /^attr_/
    end
    private_methods(true).each do |m|
      list << m if m.to_s =~ /^attr_/
    end
    return list
  end
end

