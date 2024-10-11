# frozen_string_literal: true

require 'smart_proxy_pulp_plugin/validators'

module PulpProxy
  class PulpcorePlugin < ::Proxy::Plugin
    plugin "pulpcore", ::PulpProxy::VERSION
    default_settings :pulp_url => 'https://localhost',
                     :content_app_url => 'https://localhost:24816/',
                     :mirror => false,
                     :client_authentication => ['password', 'client_certificate'],
                     :rhsm_url => 'https://localhost/rhsm'

    AUTH_TYPES = ['password', 'client_certificate', 'client_certificate_admin_only'].freeze

    load_validators include: ::PulpProxy::Validators::Include
    validate :pulp_url, :url => true
    validate :content_app_url, :url => true
    validate :client_authentication, :include => AUTH_TYPES
    validate :rhsm_url, :url => true
    validate :ssl_ca, :file_readable => true

    expose_setting :pulp_url
    expose_setting :mirror
    expose_setting :content_app_url
    expose_setting :username
    expose_setting :password
    expose_setting :client_authentication
    expose_setting :rhsm_url

    capability -> { PulpcoreClient.capabilities }
    rackup_path File.expand_path('pulpcore_http_config.ru', __dir__)
  end
end
