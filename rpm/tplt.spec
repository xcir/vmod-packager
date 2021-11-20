%global debug_package %{nil}

Summary:	%VMOD%
Name:		%VMOD%
Version:	%VER%
Release:	1%{?dist}
License:	See original VMOD source license file.

Source:	    vmod.tar.gz

Requires: varnish >= %VARNISH_VER%, varnish < %VARNISH_VER_NXT%

%description
Packed by vmod-packager

%prep
rm -rf %{buildroot}
%setup -q -n src

%build
./__vmod-package_config.sh
%make_build


%install
%make_install


%files
%{_libdir}/varnish/vmods/*
%{_mandir}/*
%{_datadir}/*

%changelog
* Tue Feb 23 2021 %VMOD% <example@localhost> - %VER%
- Packaged by vmod-packager