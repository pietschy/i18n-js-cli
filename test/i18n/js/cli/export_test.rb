require "test_helper"

class ExportTest < Minitest::Test
  test "requires output file" do
    _, err, exitcode = run_cli("export")

    assert_equal 1, exitcode
    assert_includes err, "No value provided for required options '--output-file'"
  end

  test "requires valid config file" do
    _, err, exitcode = run_cli("export --config some-file.yml --output-file translations.js")

    assert_equal 1, exitcode
    assert_includes err, "ERROR: --config must be a valid file; some-file.yml used."
  end

  test "rejects default config file when missing" do
    _, err, exitcode = run_cli("export --output-file translations.js")

    assert_equal 1, exitcode
    assert_includes err, "ERROR: --config must be a valid file; config/i18njs.yml used."
  end

  test "rejects mutually exclusive options (--config and --include)" do
    _, err, exitcode = run_cli("export --config some-file.yml --include * --output-file translations.js")

    assert_equal 1, exitcode
    assert_includes err, "ERROR: --config and --include are mutually exclusive."
  end

  test "rejects invalid --require" do
    _, err, exitcode = run_cli("export --require /invalid/file.rb --config test/support/configs/empty.yml --output-file translations.js")

    assert_equal 1, exitcode
    assert_includes err, "ERROR: --require must be a valid Rails directory or a file to be required; /invalid/file.rb used."
  end

  test "rejects default --require when file doesn't exist" do
    _, err, exitcode = run_cli("export --config test/support/configs/empty.yml --output-file translations.js")

    assert_equal 1, exitcode
    assert_includes err, "ERROR: --require must be a valid Rails directory or a file to be required; config/environment.rb used."
  end

  test "rejects --require directory when file doesn't exist" do
    _, err, exitcode = run_cli("export --config test/support/configs/empty.yml --require #{Dir.pwd} --output-file translations.js")

    assert_equal 1, exitcode
    assert_includes err, "ERROR: --require must be a valid Rails directory or a file to be required; #{Dir.pwd}/config/environment.rb used."
  end

  test "accepts Rails directory as --require"
  test "accepts ruby file as --require"
end
