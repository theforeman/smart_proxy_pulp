require 'sinatra'
require 'smart_proxy_pulp_plugin/pulp3_client'
require 'smart_proxy_pulp_plugin/disk_usage'

module PulpProxy
  class Pulp3Api < Sinatra::Base
    helpers ::Proxy::Helpers

    get '/status' do
      content_type :json
      begin
        result = Pulp3Client.get("/pulp/api/v3/status/")
        return result.body if result.is_a?(Net::HTTPSuccess)
        log_halt result.code, "Pulp server at #{::PulpProxy::Settings.settings.pulp_url} returned an error: '#{result.message}'"
      rescue SocketError, Errno::ECONNREFUSED => e
        log_halt 503, "Communication error with '#{URI.parse(::PulpProxy::Settings.settings.pulp_url.to_s).host}': #{e.message}"
      end
    end
  end
end
