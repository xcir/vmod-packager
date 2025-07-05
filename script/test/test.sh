#!/bin/bash

set -e

VRD=$(realpath "$(dirname $0)/../../")

cd ${VRD}

# clean
sudo rm -rf src/test-varnish-modules60* src/test-varnish-modules70* src/test-libvmod-digest72*
sudo rm -rf pkgs/*/test-varnish-modules60 pkgs/*/test-varnish-modules70 pkgs/*/test-varnish-modules72
sudo rm -rf pkgs/*/test-libvmod-digest60 pkgs/*/test-libvmod-digest72
sudo rm -rf pkgs/*/test-vmod-reqwest
sudo rm -rf varnish/test-varnish-cache

mkdir -p src/test-varnish-modules60
mkdir -p src/test-varnish-modules70
mkdir -p src/test-varnish-modules72
mkdir -p src/test-libvmod-digest72
mkdir -p src/test-libvdp-pesi71
mkdir -p src/test-vmod-reqwest

mkdir -p varnish/test-varnish-cache
curl -sL https://varnish-cache.org/_downloads/varnish-7.2.0.tgz | tar zx -C varnish/test-varnish-cache --strip-components 1

cd ${VRD}/src
curl -sL https://github.com/varnish/varnish-modules/archive/refs/heads/6.0-lts.tar.gz   | tar zx -C test-varnish-modules60 --strip-components 1
curl -sL https://github.com/varnish/varnish-modules/archive/refs/heads/7.0.tar.gz       | tar zx -C test-varnish-modules70 --strip-components 1
curl -sL https://github.com/varnish/varnish-modules/releases/download/0.21.0/varnish-modules-0.21.0.tar.gz | tar zx -C test-varnish-modules72 --strip-components 1

curl -sL https://github.com/gquintard/vmod_reqwest/archive/refs/heads/main.tar.gz       | tar zx -C test-vmod-reqwest --strip-components 1
curl -sL https://github.com/varnish/libvmod-digest/archive/1793bea9e9b7c7dce4d8df82397d22ab9fa296f0.tar.gz | tar zx -C test-libvmod-digest72 --strip-components 1
curl -sL https://gitlab.com/uplex/varnish/libvdp-pesi/-/archive/1097f6f48a8ea89fed89227965d94f630fb93c1f/libvdp-pesi-1097f6f48a8ea89fed89227965d94f630fb93c1f.tar.gz | tar zx -C test-libvdp-pesi71 --strip-components 1

# need patch pesi
#(
#    cd test-libvdp-pesi71
#    patch < ../../script/test/pesi.patch
#)
# and digest (https://github.com/varnish/libvmod-digest/pull/45)
(
    cd test-libvmod-digest72
    patch -p0 < ../../script/test/digest.patch
)

# copy custom script
cp ${VRD}/sample-src/libvmod-digest_init.sh ${VRD}/src/test-libvmod-digest72_init.sh
cp ${VRD}/sample-src/libvmod-digest_env.sh  ${VRD}/src/test-libvmod-digest72_env.sh
cp ${VRD}/sample-src/libvdp-pesi_config.sh  ${VRD}/src/test-libvdp-pesi71_config.sh
cp ${VRD}/sample-src/vmod-reqwest_build.sh  ${VRD}/src/test-vmod-reqwest_build.sh
cp ${VRD}/sample-src/vmod-reqwest_env.sh    ${VRD}/src/test-vmod-reqwest_env.sh


cd ${VRD}

#ubuntu
./vmod-packager.sh -t -d jammy -v 7.2.0 test-varnish-modules72; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 1

./vmod-packager.sh -t -d focal -v 6.0.8 test-varnish-modules60; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 1
./vmod-packager.sh -t -d focal -v 7.2.0 test-varnish-modules72; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 1

./vmod-packager.sh -t -d bionic -v 6.0.8 test-varnish-modules60; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 1
./vmod-packager.sh -t -d bionic -v 7.2.0 test-varnish-modules72; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 1

#debian
./vmod-packager.sh -t -d buster -v 6.0.8 test-varnish-modules60; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 2
./vmod-packager.sh -t -d buster -v 7.2.0 test-varnish-modules72; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 2

./vmod-packager.sh -t -d bullseye -v 6.0.8 test-varnish-modules60; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 2
./vmod-packager.sh -t -d bullseye -v 7.2.0 test-varnish-modules72; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 2

#centos
./vmod-packager.sh -t -d centos8 -v 6.0.8 test-varnish-modules60; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 2
./vmod-packager.sh -t -d centos8 -v 7.2.0 test-varnish-modules72; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 2

#centos-stream
#./vmod-packager.sh -t -d centos_stream8 -v 7.2.0 test-varnish-modules72; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 2
./vmod-packager.sh -t -d centos_stream9 -v 7.2.0 test-varnish-modules72; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 2
./vmod-packager.sh -t -d centos_stream10 -v 7.2.0 test-varnish-modules72; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 2

# arch
./vmod-packager.sh -t -d arch -v 7.2.0 test-varnish-modules72; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 1

#https://github.com/varnishcache/varnish-cache/commit/454733b82a3279a1603516b4f0a07f8bad4bcd55
./vmod-packager.sh -t -d jammy -c 454733b82a3279a1603516b4f0a07f8bad4bcd55 -p trunk- test-varnish-modules70;    test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 1
./vmod-packager.sh -t -d centos8 -c 454733b82a3279a1603516b4f0a07f8bad4bcd55 -p trunk- test-varnish-modules70;  test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 2
./vmod-packager.sh -t -d arch -c 454733b82a3279a1603516b4f0a07f8bad4bcd55 -p trunk- test-varnish-modules70;     test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 1

# libvmod-digest
./vmod-packager.sh -t -d jammy -v 7.2.0 src/test-libvmod-digest72;      test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 1
./vmod-packager.sh -t -d centos8 -v 7.2.0 src/test-libvmod-digest72;    test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 2
./vmod-packager.sh -t -d arch -v 7.2.0 src/test-libvmod-digest72;       test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 1

# libvdp-pesi with varnish
./vmod-packager.sh -t -d jammy -k -v 7.1.0 src/test-libvdp-pesi71;          test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 3
./vmod-packager.sh -t -d buster -k -v 7.1.0 src/test-libvdp-pesi71;         test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 4
./vmod-packager.sh -t -d centos8 -k -v 7.1.0 src/test-libvdp-pesi71;        test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 5
./vmod-packager.sh -t -d arch -k -v 7.1.0 src/test-libvdp-pesi71;           test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 2
./vmod-packager.sh -t -d centos_stream9 -k -v 7.1.0 src/test-libvdp-pesi71; test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 5

# varnish-modules with varnish local src
./vmod-packager.sh -t -d jammy -k -r test-varnish-cache src/test-varnish-modules72;      test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 3
./vmod-packager.sh -t -d centos8 -k -r test-varnish-cache src/test-varnish-modules72;    test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 5
./vmod-packager.sh -t -d arch -k -r test-varnish-cache src/test-varnish-modules72/;      test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 2

# multi vmod with varnish
./vmod-packager.sh -t -k -d jammy src/test-varnish-modules72 src/test-libvmod-digest72;   test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 4

echo "need copy from config/sample-docker_extrun_env.sh to config/docker_extrun_env.sh"

# reqwst/full custom build
./vmod-packager.sh -t -d jammy   -v 7.1.0 src/test-vmod-reqwest;   test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 1
./vmod-packager.sh -t -d centos8 -v 7.1.0 src/test-vmod-reqwest;   test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 2
./vmod-packager.sh -t -d arch    -v 7.1.0 src/test-vmod-reqwest;   test $(egrep "\\.(deb|rpm|zst)" tmp/vmp_*.log|wc -l) -eq 1

echo "pass basic test"
