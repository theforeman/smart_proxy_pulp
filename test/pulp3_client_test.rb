require 'test_helper'
require 'webmock/test_unit'
require 'mocha/test_unit'

require 'smart_proxy_pulp_plugin/pulp3_plugin'
require 'smart_proxy_pulp_plugin/pulp3_client'

class Pulp3ClientTest < Test::Unit::TestCase
  def test_get_status_with_trailing_slash
    PulpProxy::Pulp3Plugin.load_test_settings('pulp_url' => 'http://localhost/')
    stub_request(:get, "http://localhost/pulp/api/v3/status/")

    result = PulpProxy::Pulp3Client.get("/pulp/api/v3/status/")
    assert result.is_a?(Net::HTTPSuccess)
  end

  def test_get_status_without_trailing_slash
    PulpProxy::Pulp3Plugin.load_test_settings('pulp_url' => 'http://localhost/')
    stub_request(:get, "http://localhost/pulp/api/v3/status/")

    result = PulpProxy::Pulp3Client.get("/pulp/api/v3/status/")
    assert result.is_a?(Net::HTTPSuccess)
  end

  def test_get_capabilities
    capabilities = {'versions' => [{'component' => 'foo', 'version' => '1.0'}]}
    PulpProxy::Pulp3Plugin.load_test_settings('pulp_url' => 'http://localhost/')
    stub_request(:get, "http://localhost/pulp/api/v3/status/").to_return(:body => capabilities.to_json)

    assert_equal ['foo'], PulpProxy::Pulp3Client.capabilities
  end
end
