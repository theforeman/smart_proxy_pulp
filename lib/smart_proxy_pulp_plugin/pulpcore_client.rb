# frozen_string_literal: true

require 'net/http'
require 'net/https'
require 'uri'
require 'proxy/log'

module PulpProxy
  class PulpcoreClient
    def self.get(path)
      uri = URI.parse(pulp_url)
      req = Net::HTTP::Get.new(URI.join("#{uri.to_s.chomp('/')}/", path))
      req.add_field('Accept', 'application/json')
      http.request(req)
    end

    def self.capabilities
      body = JSON.parse(get("/pulp/api/v3/status/").body)
      body['versions'].map { |item| item['component'] }
    rescue StandardError => e
      logger.error("Could not fetch capabilities: #{e.message}")
      []
    end

    def self.logger
      Proxy::LoggerFactory.logger
    end

    def self.http
      ssl_ca = ::PulpProxy::PulpcorePlugin.settings.ssl_ca ||
               ::Proxy::SETTINGS.foreman_ssl_ca ||
               ::Proxy::SETTINGS.ssl_ca_file
      uri = URI.parse(pulp_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'
      http.ca_file = ssl_ca if http.use_ssl? && ssl_ca && !ssl_ca.empty?
      http
    end

    def self.pulp_url
      ::PulpProxy::PulpcorePlugin.settings.pulp_url.to_s
    end
  end
end
