require "test_helper"

# Remove after 2.7 is dropped
return unless RUBY_VERSION > "3"

module Standard::Performance
  class BuildsRulesetTest < Minitest::Test
    def setup
      @determines_yaml_path = Mocktail.of_next(DeterminesYamlPath)
      @merges_upstream_metadata = Mocktail.of_next(LintRoller::Support::MergesUpstreamMetadata)
      @loads_yaml_with_inheritance = Mocktail.of_next(LoadsYamlWithInheritance)

      @subject = BuildsRuleset.new
    end

    def test_it
      stubs { @determines_yaml_path.determine("7.0") }.with { "/my/config" }
      stubs { @loads_yaml_with_inheritance.load("/my/config") }.with { {my: :config} }
      stubs {
        @loads_yaml_with_inheritance.load(
          Pathname.new(Gem.loaded_specs["rubocop-performance"].full_gem_path).join("config/default.yml")
        )
      }.with { {their: :stuff} }
      stubs { @merges_upstream_metadata.merge({my: :config}, {their: :stuff}) }.with { {merged: :config} }

      result = @subject.build("7.0")

      assert_equal({merged: :config}, result)
    end
  end
end
