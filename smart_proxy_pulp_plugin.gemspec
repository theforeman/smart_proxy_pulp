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
  gem.summary       = %q{Basic integration with Pulp}
  gem.description   = <<-EOS
    Basic integration with Pulp
  EOS

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  # todo: add a runtime dependency on smart-proxy
  gem.add_development_dependency('test-unit')
  gem.add_development_dependency('rake')
end
