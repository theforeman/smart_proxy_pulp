# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'smart_proxy_pulp_plugin/version'

Gem::Specification.new do |gem|
  gem.name          = "smart_proxy_pulp_plugin"
  gem.version       = PulpProxy::VERSION
  gem.authors       = ['Dmitri Dolguikh']
  gem.email         = ['dmitri@redhat.com']
  gem.homepage      = "https://github.com/witlessbird/smart-proxy-pulp-plugin"
  gem.summary       = %q{Basic Pulp support for Foreman Smart-Proxy}
  gem.description   = <<-EOS
    Basic Pulp support for Foreman Smart-Proxy
  EOS

  gem.files         = Dir['{bundler.d,lib,settings.d}/**/*', 'LICENSE', 'Gemfile']
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.license = 'GPLv3'

  # todo: add a runtime dependency on smart-proxy
  gem.add_development_dependency('test-unit', '~> 0')
  gem.add_development_dependency('rake', '~> 0')
end


