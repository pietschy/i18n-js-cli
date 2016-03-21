require "test_helper"

class VersionTest < Minitest::Test
  test "outputs version" do
    out, _ = run_cli("version")

    assert_includes out, "i18njs #{I18n::JS::CLI::VERSION}"
  end
end
