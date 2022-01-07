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

cd ${VRD}/src
curl -sL https://github.com/varnish/varnish-modules/archive/refs/heads/6.0-lts.tar.gz   | tar zx -C test-varnish-modules60 --strip-components 1
curl -sL https://github.com/varnish/varnish-modules/archive/refs/heads/7.0.tar.gz       | tar zx -C test-varnish-modules70 --strip-components 1
curl -sL https://github.com/varnish/libvmod-digest/archive/1793bea9e9b7c7dce4d8df82397d22ab9fa296f0.tar.gz | tar zx -C test-libvmod-digest70 --strip-components 1
curl -sL https://gitlab.com/uplex/varnish/libvdp-pesi/-/archive/7.0/libvdp-pesi-7.0.tar.gz | tar zx -C test-libvdp-pesi70 --strip-components 1

# copy custom script
cp ${VRD}/sample-src/libvmod-digest_init.sh ${VRD}/src/test-libvmod-digest70_init.sh
cp ${VRD}/sample-src/libvmod-digest_env.sh  ${VRD}/src/test-libvmod-digest70_env.sh
cp ${VRD}/sample-src/libvdp-pesi_config.sh  ${VRD}/src/test-libvdp-pesi70_config.sh
cp ${VRD}/sample-src/libvdp-pesi_init.sh    ${VRD}/src/test-libvdp-pesi70_init.sh


cd ${VRD}
export VMP_DBG_CACHE=1

#ubuntu
./vmod-packager.sh -t -d focal -v 6.0.8 test-varnish-modules60 && ls ${VRD}/pkgs/debs/test-varnish-modules60/test-varnish-modules60_71.0.1~focal-1_amd64.deb
./vmod-packager.sh -t -d focal -v 7.0.0 test-varnish-modules70 && ls ${VRD}/pkgs/debs/test-varnish-modules70/test-varnish-modules70_140.0.1~focal-1_amd64.deb

./vmod-packager.sh -t -d bionic -v 6.0.8 test-varnish-modules60 && ls ${VRD}/pkgs/debs/test-varnish-modules60/test-varnish-modules60_71.0.1~bionic-1_amd64.deb
./vmod-packager.sh -t -d bionic -v 7.0.0 test-varnish-modules70 && ls ${VRD}/pkgs/debs/test-varnish-modules70/test-varnish-modules70_140.0.1~bionic-1_amd64.deb

#debian
./vmod-packager.sh -t -d buster -v 6.0.8 test-varnish-modules60 && ls ${VRD}/pkgs/debs/test-varnish-modules60/test-varnish-modules60_71.0.1~buster-1_amd64.deb
./vmod-packager.sh -t -d buster -v 7.0.0 test-varnish-modules70 && ls ${VRD}/pkgs/debs/test-varnish-modules70/test-varnish-modules70_140.0.1~buster-1_amd64.deb

./vmod-packager.sh -t -d bullseye -v 6.0.8 test-varnish-modules60 && ls ${VRD}/pkgs/debs/test-varnish-modules60/test-varnish-modules60_71.0.1~bullseye-1_amd64.deb
./vmod-packager.sh -t -d bullseye -v 7.0.0 test-varnish-modules70 && ls ${VRD}/pkgs/debs/test-varnish-modules70/test-varnish-modules70_140.0.1~bullseye-1_amd64.deb

#centos
./vmod-packager.sh -t -d centos8 -v 6.0.8 test-varnish-modules60 && ls ${VRD}/pkgs/rpms/test-varnish-modules60/test-varnish-modules60-71.0.1-1.el8.x86_64.rpm
./vmod-packager.sh -t -d centos8 -v 7.0.0 test-varnish-modules70 && ls ${VRD}/pkgs/rpms/test-varnish-modules70/test-varnish-modules70-140.0.1-1.el8.x86_64.rpm

#https://github.com/varnishcache/varnish-cache/commit/454733b82a3279a1603516b4f0a07f8bad4bcd55
./vmod-packager.sh -t -d focal -c 454733b82a3279a1603516b4f0a07f8bad4bcd55 -p trunk- test-varnish-modules70 && ls ${VRD}/pkgs/debs/test-varnish-modules70/trunk-test-varnish-modules70_140.0.1~focal-1_amd64.deb
./vmod-packager.sh -t -d centos8 -c 454733b82a3279a1603516b4f0a07f8bad4bcd55 -p trunk- test-varnish-modules70 && ls ${VRD}/pkgs/rpms/test-varnish-modules70/trunk-test-varnish-modules70-140.0.1-1.el8.x86_64.rpm 


# libvmod-digest
./vmod-packager.sh -t -d focal -v 7.0.0 src/test-libvmod-digest70 && ls ${VRD}/pkgs/debs/test-libvmod-digest70/test-libvmod-digest70_140.0.1~focal-1_amd64.deb
./vmod-packager.sh -t -d centos8 -v 7.0.0 src/test-libvmod-digest70 && ls ${VRD}/pkgs/rpms/test-libvmod-digest70/test-libvmod-digest70-140.0.1-1.el8.x86_64.rpm

# libvdp-pesi
./vmod-packager.sh -t -d focal -k -v 7.0.0 src/test-libvdp-pesi70 && ls ${VRD}/pkgs/debs/test-libvdp-pesi70/test-libvdp-pesi70_140.0.1~focal-1_amd64.deb && ls ${VRD}/pkgs/debs/varnish/varnish_7.0.0-1vmp~focal_amd64.deb
./vmod-packager.sh -t -d buster -k -v 7.0.0 src/test-libvdp-pesi70 && ls ${VRD}/pkgs/debs/test-libvdp-pesi70/test-libvdp-pesi70_140.0.1~buster-1_amd64.deb && ls ${VRD}/pkgs/debs/varnish/varnish_7.0.0-1vmp~buster_amd64.deb
./vmod-packager.sh -t -d centos8 -k -v 7.0.0 src/test-libvdp-pesi70 && ls ${VRD}/pkgs/rpms/test-libvdp-pesi70/test-libvdp-pesi70-140.0.1-1.el8.x86_64.rpm && ls ${VRD}/pkgs/rpms/varnish/varnish-7.0.0-1vmp.el8.x86_64.rpm

# varnish-modules
./vmod-packager.sh -t -d focal -k -r varnish-cache src/test-varnish-modules70 && ls ${VRD}/pkgs/debs/test-libvdp-pesi70/test-libvdp-pesi70_140.0.1~focal-1_amd64.deb && ls ${VRD}/pkgs/debs/varnish/varnish_`date +%Y%m%d`.*-1vmp+fromsrc~focal_amd64.deb
./vmod-packager.sh -t -d centos8 -k -r varnish-cache src/test-varnish-modules70 && ls ${VRD}/pkgs/rpms/test-libvdp-pesi70/test-libvdp-pesi70-140.0.1-1.el8.x86_64.rpm && ls ${VRD}/pkgs/rpms/varnish/varnish-`date +%Y%m%d`.*-1vmp+fromsrc.el8.x86_64.rpm

echo "pass basic test"
