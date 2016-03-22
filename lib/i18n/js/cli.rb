require "thor"
require "yaml"
require "zlib"
require "i18n-js"
require "i18n/js/cli/version"
require "i18n/js/cli/exporter"

module I18n
  module JS
    class CLI < Thor
      check_unknown_options!

      def self.exit_on_failure?
        true
      end

      desc "version", "Display i18njs version"
      map %w[-v --version] => :version

      def version
        say "i18njs #{VERSION}"
      end

      desc "export", "Export translations files"
      option :config,
             desc: "The config file that will be used to export files",
             type: :string,
             aliases: "-c"
      option :include,
             desc: "The translation scopes that must be included",
             type: :array,
             aliases: "-i",
             default: []
      option :output_file,
             desc: "The output file path",
             type: :string,
             aliases: "-o"
      option :require,
             desc: "Location of Rails application with translations or file to require",
             type: :string,
             aliases: "-r",
             banner: "[PATH|DIR]"
      option :gzip,
             desc: "Also generate .gz file for the exported translation",
             type: :boolean,
             default: false
      option :module,
             desc: "Specify the module system that will be used.",
             type: :string,
             default: "globals",
             banner: "globals|amd|common"
      option :module_name,
             desc: "Specify the module name that will be used. For globals is the namespace. For AMD is the module name.",
             type: :string,
             default: "I18n"

      def export
        validate_require_path!
        validate_config_option!
        validate_config_path!
        validate_output_path!
        validate_module_systems!

        require export_options[:require]
        I18n::JS::CLI::Exporter.export(prepare_to_export)
        exit 0
      end

      private

      def exporting_items
        if export_options[:config]
          YAML.load_file(export_options[:config])["translations"]
        else
          [{
            file: export_options[:output_file],
            only: export_options[:include],
            module: export_options[:module],
            module_name: export_options[:module_name]
          }]
        end
      end

      def prepare_to_export
        exporting_items.map do |node|
          node[:namespace] = export_options[:namespace]
          node[:gzip] = export_options[:gzip]
          hash_with_indifferent_access(node)
        end
      end

      def export_options
        @export_options ||= hash_with_indifferent_access({}.merge(options.dup))
      end

      def validate_module_systems!
        module_systems = %w[globals amd common]
        module_system = export_options[:module]

        return if module_systems.include?(module_system)
        raise Error,
              "ERROR: --module value is not supported (#{module_system.inspect})."
      end

      def validate_config_option!
        if export_options[:config] && export_options[:include].any?
          raise Error,
                "ERROR: --config and --include are mutually exclusive."
        end

        if export_options[:config] && export_options[:output_file]
          raise Error,
                "ERROR: --config and --output-file are mutually exclusive."
        end
      end

      def validate_require_path!
        path = export_options[:require] || "config/environment.rb"

        if Dir.exist?(path)
          dir_path = path
          path = File.expand_path(File.join(path, "config/environment.rb"))
          Dir.chdir dir_path
        end

        export_options[:require] = File.expand_path(path)

        return if File.file?(path)

        raise Error,
              "ERROR: --require must be a valid Rails directory or a file to be required; #{export_options[:require]} used."
      end

      def validate_config_path!
        return if export_options[:include].any?

        config = File.expand_path(export_options[:config] || "config/i18njs.yml")
        export_options[:config] = config

        return if File.file?(config)

        raise Error,
              "ERROR: --config must be a valid file; #{config} used."
      end

      def validate_output_path!
        return if export_options[:config] && File.file?(export_options[:config])
        return if export_options[:output_file]

        raise Error,
              "ERROR: --output-file must be provided."
      end

      def hash_with_indifferent_access(hash)
        Thor::CoreExt::HashWithIndifferentAccess.new(hash)
      end
    end
  end
end
