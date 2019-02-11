require 'test_helper'
require 'webmock/test_unit'
require 'mocha/test_unit'
require 'rack/test'

require 'smart_proxy_pulp_plugin/pulp3_plugin'
require 'smart_proxy_pulp_plugin/pulp3_api'

class Pulp3ApiTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    PulpProxy::Pulp3Api.new
  end

  def test_returns_pulp_status_on_200
    stub_request(:get, "#{::PulpProxy::Pulp3Plugin.settings.pulp_url.to_s}api/v3/status/").to_return(:body => "{\"api_version\":\"3\"}")
    get '/status'

    assert last_response.ok?, "Last response was not ok: #{last_response.body}"
    assert_equal("{\"api_version\":\"3\"}", last_response.body)
  end

  def test_returns_50X_on_connection_refused
    Net::HTTP.any_instance.expects(:request).raises(Errno::ECONNREFUSED)
    get '/status'
    assert last_response.server_error?
  ensure
    Net::HTTP.any_instance.unstub(:request)
  end

  def test_returns_50X_on_socket_error
    Net::HTTP.any_instance.expects(:request).raises(SocketError)
    get '/status'
    assert last_response.server_error?
  ensure
    Net::HTTP.any_instance.unstub(:request)
  end

  def test_returns_pulp_disk_on_200
    PulpProxy::Pulp3Plugin.load_test_settings(:pulp_dir => ::Sinatra::Application.settings.root,
                                         :pulp_content_dir => ::Sinatra::Application.settings.root,
                                         :mongodb_dir => ::Sinatra::Application.settings.root)
    get '/status/disk_usage'
    response = JSON.parse(last_response.body)
    assert last_response.ok?, "Last response was not ok: #{last_response.body}"
    assert_equal(%w(filesystem 1-blocks used available percent mounted path size).to_set, response['pulp_dir'].keys.to_set)
  end

  def test_change_pulp_disk_size
    PulpProxy::Pulp3Plugin.load_test_settings(:pulp_dir => ::Sinatra::Application.settings.root,
                                         :pulp_content_dir => ::Sinatra::Application.settings.root,
                                         :mongodb_dir => ::Sinatra::Application.settings.root)
    get '/status/disk_usage?size=megabyte'
    response = JSON.parse(last_response.body)
    assert last_response.ok?, "Last response was not ok: #{last_response.body}"
    assert_equal('megabyte', response['pulp_dir']['size'])
  end

  def test_default_pulp_disk_size
    PulpProxy::Pulp3Plugin.load_test_settings(:pulp_dir => ::Sinatra::Application.settings.root,
                                         :pulp_content_dir => ::Sinatra::Application.settings.root,
                                         :mongodb_dir => ::Sinatra::Application.settings.root)
    get '/status/disk_usage?size=pitabyte'
    response = JSON.parse(last_response.body)
    assert last_response.ok?, "Last response was not ok: #{last_response.body}"
    assert_equal('byte', response['pulp_dir']['size'])
  end
end
