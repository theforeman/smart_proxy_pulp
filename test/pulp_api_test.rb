require 'test_helper'
require 'webmock/test_unit'
require 'mocha/test_unit'
require "rack/test"

require 'smart_proxy_pulp_plugin/pulp_plugin'
require 'smart_proxy_pulp_plugin/pulp_api'

class PulpApiTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    PulpProxy::Api.new
  end

  def test_returns_pulp_status_on_200
    stub_request(:get, "#{::PulpProxy::Plugin.settings.pulp_url.to_s}/api/v2/status/").to_return(:body => "{\"api_version\":\"2\"}")
    get '/status'

    assert last_response.ok?, "Last response was not ok: #{last_response.body}"
    assert_equal("{\"api_version\":\"2\"}", last_response.body)
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
end