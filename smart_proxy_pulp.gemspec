# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'smart_proxy_pulp_plugin/version'

Gem::Specification.new do |gem|
  gem.name          = "smart_proxy_pulp"
  gem.version       = PulpProxy::VERSION
  gem.authors       = ['Dmitri Dolguikh']
  gem.email         = ['dmitri@redhat.com']
  gem.homepage      = "https://github.com/theforeman/smart-proxy-pulp-plugin"
  gem.summary       = 'Basic Pulp support for Foreman Smart-Proxy'
  gem.description   = 'Basic Pulp support for Foreman Smart-Proxy'

  gem.files         = Dir['{bundler.d,lib,settings.d}/**/*', 'LICENSE', 'Gemfile']
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.license = 'GPL-3.0'

  gem.required_ruby_version = '>= 2.7', '< 4'
end
