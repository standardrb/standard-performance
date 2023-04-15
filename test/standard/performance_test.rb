require "test_helper"
require "rubocop"

class Standard::PerformanceTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Standard::Performance::VERSION
  end

  BASE_CONFIG = "config/base.yml"
  INHERITED_OPTIONS = %w[
    Description
    Reference
    Safe
    SafeAutoCorrect
    StyleGuide
    VersionAdded
    VersionChanged
  ].freeze
  def test_configures_all_performance_cops
    expected = YAML.load_file(Pathname.new(Gem.loaded_specs["rubocop-performance"].full_gem_path).join("config/default.yml"))
    actual = YAML.load_file(BASE_CONFIG)
    missing = (expected.keys - actual.keys).grep(/\//) # ignore groups like "Layout"
    extra = actual.keys - expected.keys - ["require"]
    if missing.any?
      puts "These cops need to be configured in `#{BASE_CONFIG}'. Defaults:"
      missing.each do |(name)|
        puts "\n#{name}:\n" + to_indented_yaml(expected[name], INHERITED_OPTIONS)
      end
    end

    assert_equal missing, [], "Configure these cops as either Enabled: true or Enabled: false in #{BASE_CONFIG}"
    assert_equal extra, [], "These cops do not exist and should not be configured in #{BASE_CONFIG}"
  end

  def test_does_not_require_rubocop_performance_and_change_the_default_rubocop_config
    @subject = Standard::Performance::Plugin.new({})

    @subject.rules(LintRoller::Context.new(target_ruby_version: RUBY_VERSION))

    assert defined?(RuboCop::Cop::Performance), "RuboCop::Cop::Performance not be defined (the cops aren't loaded and configuring them will blow up)"
    # Load *a* config to prove it's loaded, because #rules does not actually call RuboCop
    defaults = RuboCop::ConfigLoader.default_configuration
    assert(
      defaults.to_h.none? { |k, v| k.start_with?("Performance") },
      "Performance cops should not be injected into RuboCop defaults (someone is requiring `rubocop-performance`)"
    )
  end

  def test_alphabetized_config
    actual = YAML.load_file(BASE_CONFIG).keys - ["require"]
    expected = actual.sort

    assert_equal actual, expected, "Cop names should be alphabetized! (See this script to do it for you: https://github.com/testdouble/standard/pull/222#issue-744335213 )"
  end

  private

  def to_indented_yaml(cop_hash, without_keys = [])
    cop_hash.reject { |(k, v)|
      without_keys.include?(k)
    }.to_h.to_yaml.gsub(/^---\n/, "").gsub(/^/, "  ")
  end
end
