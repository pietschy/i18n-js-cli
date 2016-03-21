require "./lib/i18n/js/cli/version"

Gem::Specification.new do |spec|
  spec.name          = "i18n-js-cli"
  spec.version       = I18n::JS::CLI::VERSION
  spec.authors       = ["Nando Vieira"]
  spec.email         = ["fnando.vieira@gmail.com"]

  spec.summary       = "Command-line tool to export translations for i18n-js."
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/fnando/i18n-js-cli"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject {|f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) {|f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "i18n-js"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest-utils"
  spec.add_development_dependency "pry-meta"
  spec.add_development_dependency "mocha"
end
