require "test_helper"

module Standard::Performance
  class LoadsYamlWithInheritanceTest < Minitest::Test
    make_my_diffs_pretty!

    def setup
      @subject = LoadsYamlWithInheritance.new
    end

    def test_base_is_base
      base_config_path = File.expand_path("../../../config/base.yml", __dir__)

      assert_equal YAML.load_file(base_config_path), @subject.load(base_config_path)
    end

    def test_inheritance_overrides_on_merge
      base_config_path = File.expand_path("../../../config/base.yml", __dir__)
      old_config_path = File.expand_path("../../../config/ruby-1.9.yml", __dir__)
      expected = YAML.load_file(base_config_path).merge(
        "Performance/ConcurrentMonotonicTime" => {"Enabled" => false},
        "Performance/DoubleStartEndWith" => {
          "Enabled" => false,
          "IncludeActiveSupportAliases" => false
        },
        "Performance/EndWith" => {"Enabled" => false},
        "Performance/StartWith" => {"Enabled" => false}
      )

      result = @subject.load(old_config_path)

      assert_equal expected, result
    end
  end
end
