#  Foreman Pulp Plugin

Foreman project plugin for Pulp allowing Katello hosts to interact with Pulp application services for content management
While this plugin is part of the Foreman project it can only be used with Katello as Foreman is not content aware without the Katello plugin.

## Getting Started

The Foreman project provides documentation on this specific plugin installation from multiple methods, distribution specific RPM, distribution specific DEB and direct manual build from source. 
The plugin can also be installed as part of the foreman-installer puppet class with the "--[no-]enable-foreman-proxy-plugin-pulp" option.
Documentation can be found here for how to install a stand alone smart proxy https://theForeman.org/manuals/latest/index.html#4.3.1SmartProxyInstallation

### Prerequisites

A working Katello instance (note not Foreman - must be Katello)
A smart proxy or capsule with the Pulp plugin installed and enabled
A Pulp installation as part of the Katello install, or a remote Pulp service to connect to


### Installing

Assuming prerequisites are met, the Pulp plugin must be enabled in the Foreman-proxy directory with the pulp.yaml and pulpnode.yaml
the following parameters are required to be set

```yaml

---
# Pulp integration
:enabled: true
:pulp_url: https://url-to-pulp-service
# Path to Pulp, Pulp content and mongodb directories
:pulp_dir: directory for Pulp on the Pulp node
:pulp_content_dir: where the Pulp content is held
:puppet_content_dir: where the puppet modules are held
:mongodb_dir: the mongodb datadir for Pulp

```

for example

```yaml

---
# Pulp integration
:enabled: true
:pulp_url: https://pulp.somedomain.com (note Katello installs are normally https://katelloname.somedomain.com/pulp)
# Path to Pulp, Pulp content and mongodb directories
:pulp_dir: /var/lib/pulp
:pulp_content_dir: /var/lib/pulp/content
:puppet_content_dir: /etc/puppetlabs/code/environments
:mongodb_dir: /var/lib/mongodb

```

## Running the tests

Todo - some test examples


## Authors

* **The Foreman Project** - *Initial Draft* - https://www.theforeman.org/


## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Foreman IRC user areyus who prompted the need for this README
