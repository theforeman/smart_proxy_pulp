module PulpProxy
  class Plugin < ::Proxy::Plugin
    plugin "pulp", ::PulpProxy::VERSION
    default_settings :pulp_url => 'https://localhost/pulp'

    http_rackup_path File.expand_path("pulp_http_config.ru", File.expand_path("../", __FILE__))
    https_rackup_path File.expand_path("pulp_http_config.ru", File.expand_path("../", __FILE__))
  end
end