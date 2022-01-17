require 'test_helper'
require 'mocha/test_unit'
require 'rack/test'
require 'json'
require 'root/root_v2_api'
require 'smart_proxy_pulp'
require 'smart_proxy_pulp_plugin/pulpcore_client'

class PulpcoreFeaturesTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Proxy::PluginInitializer.new(Proxy::Plugins.instance).initialize_plugins
    Proxy::RootV2Api.new
  end

  def test_features
    Proxy::DefaultModuleLoader.any_instance.expects(:load_configuration_file).with('pulpcore.yml').returns(
      enabled: true,
      pulp_url: 'http://pulpcore.example.com/foo',
      content_app_url: 'http://pulpcore.example.com:24816/',
      rhsm_url: 'https://rhsm.example.com/rhsm'
    )
    PulpProxy::PulpcoreClient.stubs(:capabilities).returns(['foo'])

    get '/features'
    assert last_response.ok?, "Last response was not ok: #{last_response.body}"
    response = JSON.parse(last_response.body)
    pulpcore = response['pulpcore']

    assert_equal 'running', pulpcore['state'], Proxy::LogBuffer::Buffer.instance.info[:failed_modules][:pulpcore]

    expected_settings = {
      'pulp_url' => 'http://pulpcore.example.com/foo',
      'content_app_url' => 'http://pulpcore.example.com:24816/',
      'mirror' => false,
      'client_authentication' => ['password', 'client_certificate'],
      'rhsm_url' => 'https://rhsm.example.com/rhsm'
    }
    assert_equal(expected_settings, pulpcore['settings'])
    assert_equal(['foo'], pulpcore['capabilities'])
  end

  def test_features_with_optional_params
    Proxy::DefaultModuleLoader.any_instance.expects(:load_configuration_file).with('pulpcore.yml').returns(
      enabled: true,
      pulp_url: 'http://pulpcore.example.com/foo',
      content_app_url: 'http://pulpcore.example.com:24816/',
      rhsm_url: 'https://rhsm.example.com/rhsm',
    )
    PulpProxy::PulpcoreClient.stubs(:capabilities).returns(['foo'])

    get '/features'
    assert last_response.ok?, "Last response was not ok: #{last_response.body}"
    response = JSON.parse(last_response.body)
    pulpcore = response['pulpcore']

    assert_equal 'running', pulpcore['state'], Proxy::LogBuffer::Buffer.instance.info[:failed_modules][:pulpcore]

    expected_settings = {
      'pulp_url' => 'http://pulpcore.example.com/foo',
      'content_app_url' => 'http://pulpcore.example.com:24816/',
      'mirror' => false,
      'client_authentication' => ['password', 'client_certificate'],
      'rhsm_url' => 'https://rhsm.example.com/rhsm',
    }
    assert_equal(expected_settings, pulpcore['settings'])
    assert_equal(['foo'], pulpcore['capabilities'])
  end

  def test_invalid_pulp_url
    Proxy::DefaultModuleLoader.any_instance.expects(:load_configuration_file).with('pulpcore.yml').returns(enabled: true, pulp_url: '')

    get '/features'
    assert last_response.ok?, "Last response was not ok: #{last_response.body}"
    response = JSON.parse(last_response.body)
    pulpcore = response['pulpcore']

    failure = Proxy::LogBuffer::Buffer.instance.info[:failed_modules][:pulpcore]

    assert_equal 'failed', pulpcore['state'], failure
    assert_equal "Disabling all modules in the group ['pulpcore'] due to a failure in one of them: Parameter 'pulp_url' is expected to have a non-empty value", failure
  end

  def test_invalid_content_app_url
    Proxy::DefaultModuleLoader.any_instance.expects(:load_configuration_file).with('pulpcore.yml').returns(enabled: true, content_app_url: '')

    get '/features'
    assert last_response.ok?, "Last response was not ok: #{last_response.body}"
    response = JSON.parse(last_response.body)
    pulpcore = response['pulpcore']

    failure = Proxy::LogBuffer::Buffer.instance.info[:failed_modules][:pulpcore]

    assert_equal 'failed', pulpcore['state'], failure
    assert_equal "Disabling all modules in the group ['pulpcore'] due to a failure in one of them: Parameter 'content_app_url' is expected to have a non-empty value", failure
  end

  def test_invalid_client_authentication
    Proxy::DefaultModuleLoader.any_instance.expects(:load_configuration_file).with('pulpcore.yml').returns(enabled: true, client_authentication: ['fake_auth_type'])

    get '/features'
    assert last_response.ok?, "Last response was not ok: #{last_response.body}"
    response = JSON.parse(last_response.body)
    pulpcore = response['pulpcore']

    failure = Proxy::LogBuffer::Buffer.instance.info[:failed_modules][:pulpcore]

    assert_equal 'failed', pulpcore['state'], failure
    assert_equal "Disabling all modules in the group ['pulpcore'] due to a failure in one of them: Parameter 'client_authentication' is expected to be one or more of [\"password\", \"client_certificate\", \"client_certificate_admin_only\"]", failure
  end

  def test_invalid_rhsm_url
    Proxy::DefaultModuleLoader.any_instance.expects(:load_configuration_file).with('pulpcore.yml').returns(enabled: true, rhsm_url: '')

    get '/features'
    assert last_response.ok?, "Last response was not ok: #{last_response.body}"
    response = JSON.parse(last_response.body)
    pulpcore = response['pulpcore']

    failure = Proxy::LogBuffer::Buffer.instance.info[:failed_modules][:pulpcore]

    assert_equal 'failed', pulpcore['state'], failure
    assert_equal "Disabling all modules in the group ['pulpcore'] due to a failure in one of them: Parameter 'rhsm_url' is expected to have a non-empty value", failure
  end
end
