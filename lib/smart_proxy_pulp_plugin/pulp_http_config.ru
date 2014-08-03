require 'smart_proxy_pulp_plugin/pulp_api'

map "/pulp" do
  run PulpProxy::Api
end
