module Standard
  module Performance
    class LoadsYamlWithInheritance
      def load(path)
        YAML.load_file(path)
      end
    end
  end
end
