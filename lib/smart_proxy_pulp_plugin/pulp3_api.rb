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

    get '/status/disk_usage' do
      content_type :json
      if params[:size]
        size = params[:size] ? params[:size].to_sym : nil
        log_halt 400, "size parameter must be of: #{DiskUsage::SIZE.keys.join(',')}" unless DiskUsage::SIZE.include?(size)
      else
        size = :byte
      end

      monitor_dirs = Hash[::PulpProxy::Pulp3Plugin.settings.marshal_dump.select { |key, _| key == :pulp_dir || key == :pulp_content_dir }]
      begin
        pulp_disk = DiskUsage.new({:path => monitor_dirs, :size => size.to_sym})
        pulp_disk.to_json
      rescue ::Proxy::Error::ConfigurationError
        log_halt 500, 'Could not find df command to evaluate disk space'
      end
    end
  end
end
