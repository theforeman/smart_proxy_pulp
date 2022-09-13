require 'sinatra'
require 'smart_proxy_pulp_plugin/pulpcore_client'

module PulpProxy
  class PulpcoreApi < Sinatra::Base
    helpers ::Proxy::Helpers

    get '/status' do
      content_type :json
      begin
        result = PulpcoreClient.get("/pulp/api/v3/status/")
        return result.body if result.is_a?(Net::HTTPSuccess)

        log_halt result.code, "Pulp server at #{PulpcoreClient.pulp_url} returned an error: '#{result.message}'"
      rescue SocketError, Errno::ECONNREFUSED => e
        log_halt 503, "Communication error with '#{URI.parse(PulpcoreClient.pulp_url).host}': #{e.message}"
      end
    end
  end
end
