$: << 'lib'

tests = Dir[File.join(File.dirname(__FILE__), 'test_*')]

tests.each do |t|
  require t
end

