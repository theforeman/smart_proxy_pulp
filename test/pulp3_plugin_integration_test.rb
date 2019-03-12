require 'test_helper'
require 'json'
require 'root/root_v2_api'
require 'smart_proxy_pulp_plugin/pulp3_plugin'
require 'smart_proxy_pulp_plugin/pulp3_client'

class Pulp3FeaturesTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Proxy::PluginInitializer.new(Proxy::Plugins.instance).initialize_plugins
    Proxy::RootV2Api.new
  end

  def test_features
    Proxy::DefaultModuleLoader.any_instance.expects(:load_configuration_file).with('pulp.yml').returns(enabled: true, pulp_url: 'http://pulp.example.com/foo')
    Proxy::DefaultModuleLoader.any_instance.expects(:load_configuration_file).with('pulpnode.yml').returns(enabled: true, pulp_url: 'http://pulpnode.example.com/foo')
    Proxy::DefaultModuleLoader.any_instance.expects(:load_configuration_file).with('pulp3.yml').returns(enabled: true, pulp_url: 'http://pulp3.example.com/foo')
    PulpProxy::Pulp3Client.stubs(:capabilities).returns(['foo'])

    get '/features'
    response = JSON.parse(last_response.body)
    pulp3 = response['pulp3']

    assert_equal 'running', pulp3['state']

    expected_settings = {'pulp_url' => 'http://pulp3.example.com/foo', 'mirror' => false}
    assert_equal(expected_settings, pulp3['settings'])
    assert_equal(['foo'], pulp3['capabilities'])
  end
end
