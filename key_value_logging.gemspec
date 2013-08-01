# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'key_value_logging/version'

Gem::Specification.new do |gem|
  gem.name          = "key_value_logging"
  gem.version       = KeyValueLogging::VERSION
  gem.authors       = ["Maximilian Schulz"]
  gem.email         = ["m.schulz@kulturfluss.de"]
  gem.description   = %q{KeyValue based replacement for rails TaggedLogging}
  gem.summary       = %q{Rails TaggedLogging only support simple tags.
                      When using logging solutions with automatic data detection,
                      key-value pairs are more useful. This gem allows you to
                      log tags as key-value paris and format them as you like.}
  gem.homepage      = "https://github.com/railslove/key_value_logging"
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'activesupport', '>= 3'
  gem.add_runtime_dependency 'rack', '>=1.0.0'
  gem.add_runtime_dependency 'railties', '>= 3'
  gem.add_runtime_dependency 'formatted_rails_logger'

  gem.add_development_dependency 'rspec'
end
