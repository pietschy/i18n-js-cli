# i18n-js-cli

Export translations to use with [i18n-js](https://github.com/fnando/i18-js).

![This project is under development and may not be fully functional.](http://messages.hellobits.com/warning.svg?message=This%20project%20is%20under%20development%20and%20may%20not%20be%20fully%20functional.)

## Installation

Add this line to your application's Gemfile:

```ruby
gem "i18n-js-cli"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install i18n-js-cli

## Usage

In a Rails project, this is the minimum command you can run:

```
$ i18njs export
```

This will use default configuration as following:

- `--require` will be set to `./config/environment.rb`.
- `--config` will be set to `./config/i18njs.yml`.

Exported files will always have keys sorted and pretty print; you don't have to do anything. If you want to minify the output file, use another tool for this.

### CLI

The `export` command has several options.

- `--config`: The config file that will be used to export files. This the YAML containing your rules.
- `--gzip`: Also export a `.gz` version of your translation file.
- `--include`: Specify the scopes you want to include. For several scopes, just do something like `--include '*.date.*' '*.time.*' '*.number.*'`.
- `--module-name`: Use this option if you need to specify the namespace (`globals`) or the AMD's module name.
- `--module`: Specify the module system that must be used. Can be one of `globals`, `amd` or `common`.
- `--namespace`: You can use a different namespace for the translations. Useful when you can't use the global `I18n`.
- `--output-file`: If you're not using a configuration file, you have to specify this option. It's the path of the output file. Existing file will be replaced.
- `--require`: To load your translations, you have to specify a entry file that will be required.

### Configuration file

You can define several files in a configuration file. You must specify the `file` output path and the scopes that will be exported.

```yaml
translations:
  - file: 'app/assets/javascripts/locales/en.js'
    only: 'en.*'

  - file: 'app/assets/javascripts/locales/pt-BR.js'
    only: 'pt-BR.*'

  - file: 'app/assets/javascripts/locales/es.js'
    only: 
      - 'es.date.*'
      - 'es.time.*'
```

You can specify the output namespace (globals) and module name (AMD).

```yaml
translations:
  - file: 'app/assets/javascripts/locales/en.js'
    only: 'en.*'
    module: amd
    module_name: locales/en
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec i18n-js-cli` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fnando/i18n-js-cli. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
