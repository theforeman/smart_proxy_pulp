require 'test_helper'
require 'webmock/test_unit'
require 'mocha/test_unit'

require 'smart_proxy_pulp_plugin/pulpcore_plugin'
require 'smart_proxy_pulp_plugin/pulpcore_client'

class PulpcoreClientTest < Test::Unit::TestCase
  def test_get_status_with_trailing_slash
    PulpProxy::PulpcorePlugin.load_test_settings('pulp_url' => 'http://localhost/')
    stub_request(:get, "http://localhost/pulp/api/v3/status/")

    result = PulpProxy::PulpcoreClient.get("/pulp/api/v3/status/")
    assert result.is_a?(Net::HTTPSuccess)
  end

  def test_get_status_without_trailing_slash
    PulpProxy::PulpcorePlugin.load_test_settings('pulp_url' => 'http://localhost/')
    stub_request(:get, "http://localhost/pulp/api/v3/status/")

    result = PulpProxy::PulpcoreClient.get("/pulp/api/v3/status/")
    assert result.is_a?(Net::HTTPSuccess)
  end

  def test_get_capabilities
    capabilities = {'versions' => [{'component' => 'foo', 'version' => '1.0'}]}
    PulpProxy::PulpcorePlugin.load_test_settings('pulp_url' => 'http://localhost/')
    stub_request(:get, "http://localhost/pulp/api/v3/status/").to_return(:body => capabilities.to_json)

    assert_equal ['foo'], PulpProxy::PulpcoreClient.capabilities
  end
end
