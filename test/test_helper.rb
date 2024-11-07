$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
begin
  require "simplecov"
  SimpleCov.start do
    load_profile "test_frameworks"
  end
rescue LoadError
end

require "standard/performance"

require "minitest/autorun"

require "mocktail"

class Minitest::Test
  include Mocktail::DSL

  def teardown
    Mocktail.reset
  end
end
