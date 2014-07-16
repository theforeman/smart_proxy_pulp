%global gem_name smart_proxy_pulp_plugin

%{?scl:%scl_package rubygem-%{gem_name}}
%{!?scl:%global pkg_name %{name}}

Summary: Basic Pulp support for Foreman Smart-Proxy
Name: %{?scl_prefix}rubygem-%{gem_name}
Version: 0.3
Release: 2%{?dist}
Group: Applications/System
License: GPLv3
URL: https://github.com/witlessbird/smart-proxy-pulp-plugin
Source0: http://rubygems.org/downloads/%{gem_name}-%{version}.gem

Requires: %{?scl_prefix}ruby(rubygems)

%if "%{?scl}" == "ruby193" || (0%{?rhel} == 6 && "%{?scl}" == "")
Requires:      %{?scl_prefix}ruby(abi)
BuildRequires: %{?scl_prefix}ruby(abi)
BuildRequires: %{?scl_prefix}rubygems-devel
%else
Requires:      %{?scl_prefix}ruby(release)
BuildRequires: %{?scl_prefix}ruby(release)
BuildRequires: %{?scl_prefix}rubygems-devel
%endif

BuildRequires: %{?scl_prefix}ruby(rubygems)
BuildArch: noarch

Provides: %{?scl_prefix}rubygem(%{gem_name}) = %{version}

%description
Basic Pulp support for Foreman Smart-Proxy.

%package doc
BuildArch:  noarch
Requires:   %{gem_name} = %{version}-%{release}
Summary:    Documentation for rubygem-%{gem_name}

%description doc
This package contains documentation for rubygem-%{gem_name}.

%prep

%setup -q -c -T
mkdir -p .%{gem_dir}
%{?scl:scl enable %{scl} "}
gem install --local --install-dir .%{gem_dir} \
            --force %{SOURCE0}
%{?scl:"}

%build

%install
mkdir -p %{buildroot}%{gem_dir}
cp -pa .%{gem_dir}/* \
        %{buildroot}%{gem_dir}/


%files
%dir %{gem_instdir}
%{gem_instdir}/lib
%{gem_instdir}/bundler.d
%{gem_instdir}/settings.d
%{gem_instdir}/Gemfile
%doc %{gem_instdir}/LICENSE

%exclude %{gem_dir}/cache/%{gem_name}-%{version}.gem
%{gem_dir}/specifications/%{gem_name}-%{version}.gemspec

%files doc
%doc %{gem_dir}/doc/%{gem_name}-%{version}
%doc %{gem_instdir}/LICENSE


%changelog
