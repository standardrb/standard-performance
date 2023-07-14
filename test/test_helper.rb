$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "standard/performance"

require "minitest/autorun"
require "mocktail"

class Minitest::Test
  include Mocktail::DSL

  def teardown
    Mocktail.reset
  end
end
