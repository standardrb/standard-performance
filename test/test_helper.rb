$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "standard/performance"

require "minitest/autorun"

# Remove branch after 2.7 is dropped
if RUBY_VERSION > "3"
  require "mocktail"

  class Minitest::Test
    include Mocktail::DSL

    def teardown
      Mocktail.reset
    end
  end
end
