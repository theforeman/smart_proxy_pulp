require 'test_helper'
require 'rack/test'

require 'smart_proxy_pulp_plugin/pulp_plugin'
require 'smart_proxy_pulp_plugin/disk_usage'

class DiskUsageTest < Test::Unit::TestCase
  include ::Proxy::Util
  def test_has_path_should_be_true
    disk_test = ::PulpProxy::DiskUsage.new(:path => {:root => ::Sinatra::Application.settings.root})
    assert_equal(::Sinatra::Application.settings.root, disk_test.path.first)
  end

  def test_hash_of_paths
    paths_array = [::Sinatra::Application.settings.root, '/tmp']
    disk_test = ::PulpProxy::DiskUsage.new(:path => {:root => paths_array.first, :tmp => paths_array.last})
    assert_equal(paths_array.sort, disk_test.path.sort)
  end

  def test_path_can_be_string
    disk_test = ::PulpProxy::DiskUsage.new(:path => ::Sinatra::Application.settings.root)
    assert_equal(::Sinatra::Application.settings.root, disk_test.path.first)
  end

  def test_raise_error_if_path_nil
    assert_raises Proxy::Error::ConfigurationError do
      ::PulpProxy::DiskUsage.new
    end
  end

  def test_hash_with_wrong_path
    paths_array = [::Sinatra::Application.settings.root, '/t/m/p']
    disk_test = ::PulpProxy::DiskUsage.new(:path => {:root => paths_array.first, :tmp => paths_array.last})
    assert_equal([paths_array.first], disk_test.path)
  end

  def test_command_df
    disk_test = ::PulpProxy::DiskUsage.new(:path => ::Sinatra::Application.settings.root)
    assert(disk_test.send(:command).include?(which('df')))
  end

  def test_has_stat_should_be_true
    disk_test = ::PulpProxy::DiskUsage.new(:path => {:root => ::Sinatra::Application.settings.root})
    assert_not_nil(disk_test.stat)
    assert(disk_test.stat.is_a?(Hash))
  end

  def test_should_return_valid_json
    paths_array = [::Sinatra::Application.settings.root, '/tmp']
    disk_test = ::PulpProxy::DiskUsage.new(:path => {:root => paths_array.first, :tmp => paths_array.last})
    data = disk_test.stat
    assert_equal([:filesystem, :"1024-blocks", :used, :available, :capacity, :mounted, :path, :size].to_set, data[:root].keys.to_set)
    json = disk_test.to_json
    assert_nothing_raised JSON::ParserError do
      JSON.parse(json)
    end
  end
end
