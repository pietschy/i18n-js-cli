require "test_helper"

class VersionTest < Minitest::Test
  test "outputs version" do
    out, _ = capture_io do
      I18n::JS::CLI.start(["version"])
    end

    assert_includes out, "i18njs #{I18n::JS::CLI::VERSION}"
  end
end
