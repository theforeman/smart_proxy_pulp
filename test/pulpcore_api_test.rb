# frozen_string_literal: true

require 'test_helper'
require 'webmock/test_unit'
require 'mocha/test_unit'
require 'rack/test'

require 'smart_proxy_pulp_plugin/pulpcore_plugin'
require 'smart_proxy_pulp_plugin/pulpcore_api'

class PulpcoreApiTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    PulpProxy::PulpcoreApi.new
  end

  def test_returns_pulp_status_on_200_ok
    PulpProxy::PulpcorePlugin.load_test_settings(
      pulp_url: 'http://pulpcore.example.com/',
      content_app_url: 'http://pulpcore.example.com/pulp/content',
      rhsm_url: 'https://rhsm.example.com/rhsm',
    )
    stub_request(:get, "http://pulpcore.example.com/pulp/api/v3/status/").to_return(:body => "{\"api_version\":\"3\"}")
    get '/status'

    assert last_response.ok?, "Last response was not ok: #{last_response.body}"
    assert_equal("{\"api_version\":\"3\"}", last_response.body)
  end

  def test_returns_50x_on_connection_refused
    Net::HTTP.any_instance.expects(:request).raises(Errno::ECONNREFUSED)
    get '/status'
    assert last_response.server_error?
  ensure
    Net::HTTP.any_instance.unstub(:request)
  end

  def test_returns_50x_on_socket_error
    Net::HTTP.any_instance.expects(:request).raises(SocketError)
    get '/status'
    assert last_response.server_error?
  ensure
    Net::HTTP.any_instance.unstub(:request)
  end
end
