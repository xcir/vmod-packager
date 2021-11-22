#!/bin/bash

VRD=$(cd $(dirname $0)/../../; pwd)
cd ${VRD}

sudo rm -rf src/test-varnish-modules60 src/test-varnish-modules70
sudo rm -rf pkgs/debs/test-varnish-modules60 pkgs/debs/test-varnish-modules70
sudo rm -rf pkgs/rpms/test-varnish-modules60 pkgs/rpms/test-varnish-modules70
mkdir -p src/test-varnish-modules60
mkdir -p src/test-varnish-modules70

cd ${VRD}/src
curl -sL https://github.com/varnish/varnish-modules/archive/refs/heads/6.0-lts.tar.gz   | tar zx -C test-varnish-modules60 --strip-components 1
curl -sL https://github.com/varnish/varnish-modules/archive/refs/heads/7.0.tar.gz       | tar zx -C test-varnish-modules70 --strip-components 1

cd ${VRD}
export VMP_DBG_CACHE=1
./vmod-packager.sh -t -d bionic -v 6.0.8 test-varnish-modules60 && ls ${VRD}/pkgs/debs/test-varnish-modules60/test-varnish-modules60_71.0.1~bionic-1_amd64.deb
if [ $? -eq 1 ]; then exit 1; fi
./vmod-packager.sh -t -d bionic -v 7.0.0 test-varnish-modules70 && ls ${VRD}/pkgs/debs/test-varnish-modules70/test-varnish-modules70_140.0.1~bionic-1_amd64.deb
if [ $? -eq 1 ]; then exit 1; fi
./vmod-packager.sh -t -d focal -v 6.0.8 test-varnish-modules60 && ls ${VRD}/pkgs/debs/test-varnish-modules60/test-varnish-modules60_71.0.1~focal-1_amd64.deb
if [ $? -eq 1 ]; then exit 1; fi
./vmod-packager.sh -t -d focal -v 7.0.0 test-varnish-modules70 && ls ${VRD}/pkgs/debs/test-varnish-modules70/test-varnish-modules70_140.0.1~focal-1_amd64.deb
if [ $? -eq 1 ]; then exit 1; fi
./vmod-packager.sh -t -d centos8 -v 6.0.8 test-varnish-modules60 && ls ${VRD}/pkgs/rpms/test-varnish-modules60/test-varnish-modules60-71.0.1-1.el8.x86_64.rpm
if [ $? -eq 1 ]; then exit 1; fi
./vmod-packager.sh -t -d centos8 -v 7.0.0 test-varnish-modules70 && ls ${VRD}/pkgs/rpms/test-varnish-modules70/test-varnish-modules70-140.0.1-1.el8.x86_64.rpm
if [ $? -eq 1 ]; then exit 1; fi

echo "pass basic test"
