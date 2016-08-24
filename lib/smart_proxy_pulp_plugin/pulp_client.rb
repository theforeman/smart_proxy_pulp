require 'net/http'
require 'net/https'
require 'uri'
require 'smart_proxy_pulp_plugin/settings'

module PulpProxy
  class PulpClient
    def self.get(path)
      uri = URI.parse(::PulpProxy::Settings.settings.pulp_url.to_s)
      path = [uri.path, path].join('/') unless uri.path.empty?
      req = Net::HTTP::Get.new(URI.join(uri.to_s, path).path)
      req.add_field('Accept', 'application/json')
      req.content_type = 'application/json'
      response = self.http.request(req)
    end

    def self.http
      uri = URI.parse(::PulpProxy::Settings.settings.pulp_url.to_s)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      if http.use_ssl?
        if Proxy::SETTINGS.ssl_ca_file && !Proxy::SETTINGS.ssl_ca_file.to_s.empty?
          http.ca_file = Proxy::SETTINGS.ssl_ca_file
          http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        end

        if Proxy::SETTINGS.ssl_certificate && !Proxy::SETTINGS.ssl_certificate.to_s.empty? && Proxy::SETTINGS.ssl_private_key && !Proxy::SETTINGS.ssl_private_key.to_s.empty?
          http.cert = OpenSSL::X509::Certificate.new(File.read(Proxy::SETTINGS.ssl_certificate))
          http.key  = OpenSSL::PKey::RSA.new(File.read(Proxy::SETTINGS.ssl_private_key), nil)
        end
      end
      http
    end
  end
end
