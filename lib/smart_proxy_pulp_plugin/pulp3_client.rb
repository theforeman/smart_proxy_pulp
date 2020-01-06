require 'net/http'
require 'net/https'
require 'uri'
require 'smart_proxy_pulp_plugin/settings'
require 'proxy/log'

module PulpProxy
  class Pulp3Client
    def self.get(path)
      uri = URI.parse(::PulpProxy::Pulp3Plugin.settings.pulp_url.to_s)
      req = Net::HTTP::Get.new(URI.join(uri.to_s.chomp('/') + '/', path))
      req.add_field('Accept', 'application/json')
      self.http.request(req)
    end

    def self.capabilities
      body = JSON.parse(get("/pulp/api/v3/status/").body)
      body['versions'].map{|item| item['component'] }
    rescue => e
      logger.error("Could not fetch capabilities: #{e.message}")
      []
    end

    def self.logger
      Proxy::LoggerFactory.logger
    end

    def self.http
      uri = URI.parse(::PulpProxy::Pulp3Plugin.settings.pulp_url.to_s)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'
      http
    end
  end
end
