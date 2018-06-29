require 'test_helper'
require 'webmock/test_unit'
require 'mocha/test_unit'

require 'smart_proxy_pulp_plugin/pulp_plugin'
require 'smart_proxy_pulp_plugin/pulp_client'

class PulpClientTest < Test::Unit::TestCase
  def test_get_status_with_trailing_slash
    PulpProxy::Plugin.load_test_settings('pulp_url' => 'http://localhost/pulp/')
    stub_request(:get, "http://localhost/pulp/api/v2/status/")

    result = PulpProxy::PulpClient.get("api/v2/status/")
    assert result.is_a?(Net::HTTPSuccess)
  end

  def test_get_status_without_trailing_slash
    PulpProxy::Plugin.load_test_settings('pulp_url' => 'http://localhost/pulp')
    stub_request(:get, "http://localhost/pulp/api/v2/status/")

    result = PulpProxy::PulpClient.get("api/v2/status/")
    assert result.is_a?(Net::HTTPSuccess)
  end
end
