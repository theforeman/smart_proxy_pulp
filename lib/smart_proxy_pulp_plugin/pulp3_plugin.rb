module PulpProxy
  class Pulp3Plugin < ::Proxy::Plugin
    plugin "pulp3", ::PulpProxy::VERSION
    default_settings :pulp_url => 'https://localhost/pulp/',
                     :pulp_dir => '/var/lib/pulp',
                     :pulp_content_dir => '/var/lib/pulp/content',
                     :mirror => false

    expose_setting :pulp_url
    expose_setting :mirror
    capability( lambda do ||
      Pulp3Client.capabilities
    end)
    http_rackup_path File.expand_path("pulp3_http_config.ru", File.expand_path("../", __FILE__))
    https_rackup_path File.expand_path("pulp3_http_config.ru", File.expand_path("../", __FILE__))
  end
end
