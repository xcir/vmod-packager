%global debug_package %{nil}

Summary:	%PFX%%VMOD%
Name:		%PFX%%VMOD%
Version:	%VER%
Release:	1%{?dist}
License:	See original VMOD source license file.

Source:	    vmod.tar.gz

Requires: varnish >= %VARNISH_VER%, varnish < %VARNISH_VER_NXT%%REQ%

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

%check
make check

%files
%{_libdir}/varnish/vmods/*
%{_mandir}/*
%{_datadir}/*

%changelog
* Tue Feb 23 2021 %PFX%%VMOD% <example@localhost> - %VER%
- Packaged by vmod-packager