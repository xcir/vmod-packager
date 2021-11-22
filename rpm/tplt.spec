%global debug_package %{nil}
%UNPACKAGED_TRACK%

Summary:	%PFX%%VMOD%
Name:		%PFX%%VMOD%
Version:	%VRT%.%VER%
Release:	1%{?dist}
License:	See original VMOD source license file.

Source:	    vmod.tar.gz

Requires: varnish >= %VARNISH_VER%, varnish < %VARNISH_VER_NXT%%REQUIRE%

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
%TEST%

%files
%{_libdir}/varnish/vmods/*
%FILES_DATADIR%
%FILES_MAN%

%changelog
* Tue Feb 23 2021 %PFX%%VMOD% <example@localhost> - %VRT%.%VER%
- Packaged by vmod-packager