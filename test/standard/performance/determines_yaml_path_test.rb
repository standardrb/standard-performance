require "test_helper"

module Standard::Performance
  class DeterminesYamlPathTest < Minitest::Test
    def setup
      @subject = DeterminesYamlPath.new
    end

    def test_paths
      assert_match "base.yml", @subject.determine(RUBY_VERSION).to_s
      assert_match "base.yml", @subject.determine(Gem::Version.new("2.8.2")).to_s
      assert_match "ruby-1.8.yml", @subject.determine(Gem::Version.new("1.8.7")).to_s
      assert_match "ruby-1.9.yml", @subject.determine(Gem::Version.new("1.9.3")).to_s
      assert_match "ruby-2.0.yml", @subject.determine(Gem::Version.new("2.0.0")).to_s
      assert_match "ruby-2.1.yml", @subject.determine(Gem::Version.new("2.1.10")).to_s
      assert_match "ruby-2.2.yml", @subject.determine(Gem::Version.new("2.2.10")).to_s
    end
  end
end
