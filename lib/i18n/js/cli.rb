require "thor"
require "i18n/js/cli/version"

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
        desc: "The translation matchers (e.g. '*.date.*')",
        type: :array,
        aliases: "-i",
        default: []
      option :output_file,
        desc: "The output file path",
        type: :string,
        aliases: "-o",
        required: true
      option :namespace,
        desc: "The I18n namespace",
        type: :string,
        aliases: "-n",
        default: "I18n"
      option :require,
        desc: "Location of Rails application with translations or file to require",
        type: :string,
        aliases: "-r",
        banner: "[PATH|DIR]"
      option :gzip,
        desc: "Also generate .gz file for the exported translation",
        type: :boolean,
        default: false

      def export
        validate_config_option!
        validate_config_path!
        validate_require_path!
      end

      private

      def export_options
        @export_options ||= Thor::CoreExt::HashWithIndifferentAccess.new({}.merge(options.dup))
      end

      def validate_config_option!
        if export_options[:config] && export_options[:include].any?
          raise Error, "ERROR: --config and --include are mutually exclusive."
        end
      end

      def validate_require_path!
        path = export_options[:require] || "config/environment.rb"
        path = File.join(path, "config/environment.rb") if Dir.exist?(path)
        export_options[:require] = File.expand_path(path)

        return if File.file?(path)

        raise Error, "ERROR: --require must be a valid Rails directory or a file to be required; #{path} used."
      end

      def validate_config_path!
        return if export_options[:include].any?

        config = export_options[:config] || "config/i18njs.yml"
        export_options[:config] = File.expand_path(config)

        return if File.file?(config)

        raise Error, "ERROR: --config must be a valid file; #{config} used."
      end
    end
  end
end
