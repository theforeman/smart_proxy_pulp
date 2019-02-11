module PulpNodeProxy
  class Plugin < ::Proxy::Plugin
    plugin "pulpnode", ::PulpProxy::VERSION
    default_settings :pulp_url => 'https://localhost/pulp',
                     :pulp_dir => '/var/lib/pulp',
                     :pulp_content_dir => '/var/lib/pulp/content',
                     :puppet_content_dir => '/etc/puppet/environments',
                     :mongodb_dir => '/var/lib/mongodb'

    expose_setting :pulp_url
    http_rackup_path File.expand_path("pulp_node_http_config.ru", File.expand_path("../", __FILE__))
    https_rackup_path File.expand_path("pulp_node_http_config.ru", File.expand_path("../", __FILE__))
  end
end
