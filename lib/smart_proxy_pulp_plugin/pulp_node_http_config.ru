require 'smart_proxy_pulp_plugin/pulp_api'

map "/pulpnode" do
  run PulpProxy::Api
end
