module Anise

  #
  def self.metadata
    @metadata ||= (
      require 'yaml'
      YAML.load(File.new(File.dirname(__FILE__) + '/../anise.yml'))
    )
  end

  #
  def self.const_missing(name)
    metadata[name.to_s.downcase] || super(name)
  end

end

