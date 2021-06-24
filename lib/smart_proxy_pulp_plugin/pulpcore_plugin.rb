require 'smart_proxy_pulp_plugin/validators'

module PulpProxy
  class PulpcorePlugin < ::Proxy::Plugin
    plugin "pulpcore", ::PulpProxy::VERSION
    default_settings :pulp_url => 'https://localhost',
                     :container_registry_url => false,
                     :content_app_url => 'https://localhost:24816/',
                     :mirror => false,
                     :client_authentication => ['password', 'client_certificate']

    AUTH_TYPES = ['password', 'client_certificate', 'client_certificate_admin_only'].freeze

    load_validators include: ::PulpProxy::Validators::Include
    validate :pulp_url, :url => true
    validate :content_app_url, :url => true
    validate :client_authentication, :include => AUTH_TYPES

    load_programmable_settings do |setting|
      if settings[:container_registry_url] == true
        settings[:container_registry_url] = URI.join(settings[:pulp_url], '/pulpcore_registry')
      end
    end

    expose_setting :pulp_url
    expose_setting :mirror
    expose_setting :content_app_url
    expose_setting :container_registry_url
    expose_setting :username
    expose_setting :password
    expose_setting :client_authentication

    capability -> { PulpcoreClient.capabilities }
    rackup_path File.expand_path('pulpcore_http_config.ru', __dir__)
  end
end
