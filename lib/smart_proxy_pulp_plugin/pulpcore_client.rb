require 'net/http'
require 'net/https'
require 'uri'
require 'proxy/log'

module PulpProxy
  class PulpcoreClient
    def self.get(path)
      uri = URI.parse(pulp_url)
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
      uri = URI.parse(pulp_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'
      http
    end

    def self.pulp_url
      ::PulpProxy::PulpcorePlugin.settings.pulp_url.to_s
    end
  end
end
