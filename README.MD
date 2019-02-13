#  Foreman Smart Proxy Pulp

Foreman project Smart Proxy plugin for pulp allowing Katello hosts to interact with pulp application services for content management
While this plugin is part of the foreman project it can only be used with Katello as Foreman is not content aware without the Katello plugin.

## Getting Started

The foreman project provides documentation on this specific plugin installation from multiple methods, distribution specific RPM, distribution specific DEB and direct manual build from source. 
The plugin can also be installed as part of the foreman-installer puppet class with the "--[no-]enable-foreman-proxy-plugin-pulp" option.
Documentation can be found here for how to install a stand alone smart proxy https://theforeman.org/manuals/$current_foreman_version/index.html#4.3.1SmartProxyInstallation

### Prerequisites

A working Katello instance (note not foreman - must be Katello)
A smart proxy or capsule with the pulp plugin installed and enabled
A pulp installation as part of the katello install, or a remote pulp service to connect to


### Installing

Assuming prerequisites are met, the pulp plugin must be enabled in the foreman-proxy directory with the pulp.yaml and pulpnode.yaml
the following parameters are required to be set

```
---
# Pulp integration
:enabled: true
:pulp_url: https://url-to-pulp-service
# Path to pulp, pulp content and mongodb directories
:pulp_dir: directory for pulp on the pulp node
:pulp_content_dir: where the pulp content is held
:puppet_content_dir: where the puppet modules are held
:mongodb_dir: the mongodb datadir for pulp

```

for example

```
---
# Pulp integration
:enabled: true
:pulp_url: https://pulp.somedomain.com (note katello installs are normally https://katelloname.somedomain.com/pulp)
# Path to pulp, pulp content and mongodb directories
:pulp_dir: /var/lib/pulp
:pulp_content_dir: /var/lib/pulp/content
:puppet_content_dir: /etc/puppetlabs/code/environments
:mongodb_dir: /var/lib/mongodb

```

## Running the tests
Give some test cases - todo



## Authors

* **Matt Darcy** - *Initial Draft* - [ikonia](https://github.com/ikonia)


## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Foreman IRC user areyus who prompted the need for this README
