module PulpProxy
  class PulpcorePlugin < ::Proxy::Plugin
    plugin "pulpcore", ::PulpProxy::VERSION
    default_settings :pulp_url => 'https://localhost',
                     :content_app_url => 'https://localhost:24816/',
                     :mirror => false

    validate :pulp_url, :url => true
    validate :content_app_url, :url => true

    expose_setting :pulp_url
    expose_setting :mirror
    expose_setting :content_app_url
    expose_setting :username
    expose_setting :password
    capability( lambda do ||
      PulpcoreClient.capabilities
    end)
    http_rackup_path File.expand_path("pulpcore_http_config.ru", File.expand_path("../", __FILE__))
    https_rackup_path File.expand_path("pulpcore_http_config.ru", File.expand_path("../", __FILE__))
  end
end
