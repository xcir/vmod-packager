#!/bin/bash

set -e

VRD=$(realpath "$(dirname $0)/../../")

cd ${VRD}

# clean
sudo rm -rf src/test-varnish-modules60* src/test-varnish-modules70* src/test-libvmod-digest70*
sudo rm -rf pkgs/debs/test-varnish-modules60 pkgs/debs/test-varnish-modules70
sudo rm -rf pkgs/rpms/test-varnish-modules60 pkgs/rpms/test-varnish-modules70
sudo rm -rf pkgs/debs/test-libvmod-digest70 pkgs/rpms/test-libvmod-digest70
mkdir -p src/test-varnish-modules60
mkdir -p src/test-varnish-modules70
mkdir -p src/test-libvmod-digest70
mkdir -p src/test-libvdp-pesi70
mkdir -p varnish/varnish-cache
curl -sL https://varnish-cache.org/_downloads/varnish-7.0.1.tgz | tar zx -C varnish/varnish-cache --strip-components 1

cd ${VRD}/src
curl -sL https://github.com/varnish/varnish-modules/archive/refs/heads/6.0-lts.tar.gz   | tar zx -C test-varnish-modules60 --strip-components 1
curl -sL https://github.com/varnish/varnish-modules/archive/refs/heads/7.0.tar.gz       | tar zx -C test-varnish-modules70 --strip-components 1
curl -sL https://github.com/varnish/libvmod-digest/archive/1793bea9e9b7c7dce4d8df82397d22ab9fa296f0.tar.gz | tar zx -C test-libvmod-digest70 --strip-components 1
curl -sL https://gitlab.com/uplex/varnish/libvdp-pesi/-/archive/7.0/libvdp-pesi-7.0.tar.gz | tar zx -C test-libvdp-pesi70 --strip-components 1

# need patch pesi
(
    cd test-libvdp-pesi70
    patch < ../../script/test/pesi.patch
)
# and digest (https://github.com/varnish/libvmod-digest/pull/45)
(
    cd test-libvmod-digest70
    patch -p0 < ../../script/test/digest.patch
)

# copy custom script
cp ${VRD}/sample-src/libvmod-digest_init.sh ${VRD}/src/test-libvmod-digest70_init.sh
cp ${VRD}/sample-src/libvmod-digest_env.sh  ${VRD}/src/test-libvmod-digest70_env.sh
cp ${VRD}/sample-src/libvdp-pesi_config.sh  ${VRD}/src/test-libvdp-pesi70_config.sh
cp ${VRD}/sample-src/libvdp-pesi_init.sh    ${VRD}/src/test-libvdp-pesi70_init.sh


cd ${VRD}
export VMP_DBG_CACHE=1

#ubuntu
./vmod-packager.sh -t -d focal -v 6.0.8 test-varnish-modules60; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 1
./vmod-packager.sh -t -d focal -v 7.0.0 test-varnish-modules70; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 1

./vmod-packager.sh -t -d bionic -v 6.0.8 test-varnish-modules60; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 1
./vmod-packager.sh -t -d bionic -v 7.0.0 test-varnish-modules70; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 1

#debian
./vmod-packager.sh -t -d buster -v 6.0.8 test-varnish-modules60; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 2
./vmod-packager.sh -t -d buster -v 7.0.0 test-varnish-modules70; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 2

./vmod-packager.sh -t -d bullseye -v 6.0.8 test-varnish-modules60; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 2
./vmod-packager.sh -t -d bullseye -v 7.0.0 test-varnish-modules70; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 2

#centos
./vmod-packager.sh -t -d centos8 -v 6.0.8 test-varnish-modules60; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 2
./vmod-packager.sh -t -d centos8 -v 7.0.0 test-varnish-modules70; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 2

#centos-stream
./vmod-packager.sh -t -d centos-stream8 -v 7.0.0 test-varnish-modules70; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 2
#https://bugzilla.redhat.com/show_bug.cgi?id=2034311
#./vmod-packager.sh -t -d centos-stream9 -v 7.0.0 test-varnish-modules70; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 2

# arch
./vmod-packager.sh -t -d arch -v 7.0.0 test-varnish-modules70; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 1

#https://github.com/varnishcache/varnish-cache/commit/454733b82a3279a1603516b4f0a07f8bad4bcd55
./vmod-packager.sh -t -d focal -c 454733b82a3279a1603516b4f0a07f8bad4bcd55 -p trunk- test-varnish-modules70;    test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 1
./vmod-packager.sh -t -d centos8 -c 454733b82a3279a1603516b4f0a07f8bad4bcd55 -p trunk- test-varnish-modules70;  test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 2
./vmod-packager.sh -t -d arch -c 454733b82a3279a1603516b4f0a07f8bad4bcd55 -p trunk- test-varnish-modules70;     test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 1

# libvmod-digest
./vmod-packager.sh -t -d focal -v 7.0.0 src/test-libvmod-digest70;      test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 1
./vmod-packager.sh -t -d centos8 -v 7.0.0 src/test-libvmod-digest70;    test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 2
./vmod-packager.sh -t -d arch -v 7.0.0 src/test-libvmod-digest70;       test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 1

# libvdp-pesi with varnish
./vmod-packager.sh -t -d focal -k -v 7.0.0 src/test-libvdp-pesi70;      test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 3
./vmod-packager.sh -t -d buster -k -v 7.0.0 src/test-libvdp-pesi70;     test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 4
./vmod-packager.sh -t -d centos8 -k -v 7.0.0 src/test-libvdp-pesi70;    test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 5
./vmod-packager.sh -t -d arch -k -v 7.0.0 src/test-libvdp-pesi70;       test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 2

# varnish-modules with varnish local src
./vmod-packager.sh -t -d focal -k -r varnish-cache src/test-varnish-modules70;      test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 3
./vmod-packager.sh -t -d centos8 -k -r varnish-cache src/test-varnish-modules70;    test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 5
./vmod-packager.sh -t -d arch -k -r varnish-cache src/test-varnish-modules70/;      test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 2

# multi vmod with varnish
./vmod-packager.sh -t -k -d focal src/test-varnish-modules70 src/test-libvdp-pesi70;   test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*log|wc -l) -eq 4

echo "pass basic test"
