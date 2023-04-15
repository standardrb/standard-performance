require "test_helper"

module Standard::Performance
  class PluginTest < Minitest::Test
    def setup
      @subject = Plugin.new({})
    end

    def test_paths
      assert_match "base.yml", @subject.rules(LintRoller::Context.new(target_ruby_version: RUBY_VERSION)).value.to_s
      assert_match "base.yml", @subject.rules(LintRoller::Context.new(target_ruby_version: Gem::Version.new("2.8.2"))).value.to_s
      assert_match "ruby-2.2.yml", @subject.rules(LintRoller::Context.new(target_ruby_version: Gem::Version.new("1.9.3"))).value.to_s
    end
  end
end
