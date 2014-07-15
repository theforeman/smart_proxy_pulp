%global homedir %{_datadir}/%{name}

%if "%{?scl}" == "ruby193"
    %global scl_prefix %{scl}-
    %global scl_ruby /usr/bin/ruby193-ruby
%else
    %global scl_ruby /usr/bin/ruby
%endif

Name:           foreman-proxy-pulp-plugin
Version:        0.1
Release:        0.develop%{dist}
Summary:        Pulp support for Foreman-Proxy

Group:          Applications/System
License:        GPLv3+
URL:            http://theforeman.org/projects/smart-proxy
Source0:        http://downloads.theforeman.org/%{name}/%{name}-%{version}.tar.bz2
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildArch:      noarch

%if "%{?scl}" == "ruby193" || (0%{?rhel} == 6 && "%{?scl}" == "")
Requires: %{?scl_prefix}ruby(abi)
%else
Requires: %{?scl_prefix}ruby(release)
%endif

Requires:       %{?scl_prefix}rubygems
Requires:       %{?scl_prefix}rubygem(rake) >= 0.8.3
Requires:       %{?scl_prefix}rubygem(sinatra)
Requires:       foreman-proxy

%description
Pulp support for Foreman-Proxy

%prep
%setup -q

%build

#replace shebangs for SCL
%if %{?scl:1}%{!?scl:0}
  for f in bin/smart-proxy extra/query.rb extra/changelog extra/migrate_settings.rb; do
    sed -ri '1sX(/usr/bin/ruby|/usr/bin/env ruby)X%{scl_ruby}X' $f
  done
  sed -ri '1,$sX/usr/bin/rubyX%{scl_ruby}X' extra/spec/foreman-proxy.init
%endif

%install
rm -rf %{buildroot}
install -d -m0755 %{buildroot}%{_datadir}/%{name}
install -d -m0755 %{buildroot}%{_sysconfdir}/foreman-proxy
install -d -m0755 %{buildroot}%{_sysconfdir}/foreman-proxy/settings.d

cp -p -r lib bundler.d %{buildroot}%{_datadir}/%{name}
rm -rf %{buildroot}%{_datadir}/%{name}/*.rb

# remove all test units from productive release
find %{buildroot}%{_datadir}/%{name} -type d -name "test" |xargs rm -rf

# Move config files to %{_sysconfdir}
install -Dp -m0644 settings.d/pulp.yml.example %{buildroot}%{_sysconfdir}/foreman-proxy/settings.d/pulp.yml

%clean
rm -rf %{buildroot}

%files
%doc LICENSE
%{_datadir}/%{name}
%config(noreplace) %{_sysconfdir}/foreman-proxy/settings.d

%changelog

