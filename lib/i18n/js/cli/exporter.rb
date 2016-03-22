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
          contents = store_translations(item[:only])
          create_file(contents)
          create_gzip(contents) if item[:gzip]
        end

        private

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
          I18n::JS.json_encoder = ->(translations) { json_encoder(translations) }
          I18n::JS.output_namespace = item[:namespace]
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
