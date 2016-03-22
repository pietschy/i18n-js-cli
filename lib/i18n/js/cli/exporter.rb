module I18n
  module JS
    class CLI < Thor
      class Exporter
        include ViewHelpers

        def self.export(items)
          items.each do |item|
            new(item).export
          end
        end

        attr_reader :item

        def initialize(item)
          @item = item
          deprecate_except_rule if item[:except]
        end

        def export
          set_config
          ensure_directory
          contents = generate_contents
          create_file(contents)
          create_gzip(contents) if item[:gzip]
        end

        private

        def generate_contents
          contents = store_translations(item[:only])

          case item[:module]
          when "amd"
            amd_module(contents)
          when "common"
            common_module(contents)
          else
            contents
          end
        end

        def common_module(contents)
          [
            %[var I18n = require("i18n");],
            %[module.exports = I18n;],
            contents
          ].join("\n")
        end

        def amd_module(contents)
          [
            %[define("#{item[:module_name]}", ["i18n"], function(I18n) {],
            contents.lines.map {|line| "  #{line}" }.join(""),
            %[  return I18n;],
            %[});]
          ].join("\n")
        end

        def create_gzip(contents)
          Zlib::GzipWriter.open("#{item[:file]}.gz") do |file|
            file << contents
          end
        end

        def create_file(contents)
          File.open(item[:file], "w") do |file|
            file << contents
          end
        end

        def ensure_directory
          FileUtils.mkdir_p(File.dirname(item[:file]))
        end

        def set_config
          I18n::JS.defaults!
          I18n::JS.output_namespace = item[:module_name] if globals?
          I18n::JS.json_encoder = lambda do |translations|
            json_encoder(translations)
          end
        end

        def globals?
          item[:module] == "globals"
        end

        def json_encoder(translations)
          translations = deep_sort(translations)
          JSON.pretty_generate(translations)
        end

        def deep_sort(hash)
          return hash unless hash.is_a?(Hash)

          hash.each_with_object(Hash[hash.sort]) do |(key, value), buffer|
            buffer[key] = deep_sort(value)
          end
        end

        def deprecate_except_rule
          warn ":except is not supported anymore:",
               JSON.pretty_generate(item)
        end
      end
    end
  end
end
