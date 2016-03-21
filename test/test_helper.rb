require "bundler/setup"
require "i18n/js/cli"
require "minitest/utils"
require "minitest/autorun"

require "shellwords"

module Minitest
  class Test
    def run_cli(command)
      args = Shellwords.split(command)
      exitcode = nil

      out, err = capture_io do
        begin
          I18n::JS::CLI.start(args)
         rescue SystemExit => error
          exitcode = error.status
        end
      end

      [out, err, exitcode]
    end
  end
end
