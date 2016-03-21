require "thor"
require "i18n/js/cli/version"

module I18n
  module JS
    class CLI < Thor
      check_unknown_options!

      desc "version", "Display i18njs version"
      map %w[-v --version] => :version

      def version
        say "i18njs #{VERSION}"
      end
    end
  end
end
