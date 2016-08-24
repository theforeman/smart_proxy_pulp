require 'sinatra'
require 'smart_proxy_pulp_plugin/pulp_node_plugin'
require 'smart_proxy_pulp_plugin/pulp_plugin'

module PulpProxy
  class Settings 
    def self.settings 
      # work around until pulp node settings are no longer needed by foreman proxy, as pulp nodes have been removed
      ::PulpProxy::Plugin.settings.pulp_url ? ::PulpProxy::Plugin.settings : ::PulpNodeProxy::Plugin.settings
    end
  end
end
