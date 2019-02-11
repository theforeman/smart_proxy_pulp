require 'smart_proxy_pulp_plugin/pulp3_api'

map "/pulp3" do
  run PulpProxy::Pulp3Api
end
