require 'smart_proxy_pulp_plugin/pulpcore_api'

map "/pulpcore" do
  run PulpProxy::PulpcoreApi
end
