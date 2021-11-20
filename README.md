# WIP

# vmod-packager

## VMOD package builder

| | |
|--|:--|
| Author:                   | Shohei Tanaka(@xcir) |
| Date:                     | not yet release |
| Version:                  | not yet release |
| Support Varnish Version:  | 6.0 ~|
| Manual section:           | 7 |

# Require

- docker

# Quick tutorial

```bash
xcir@build01:~/git/vmod-packager$ cd src
xcir@build01:~/git/vmod-packager/src$ git clone https://github.com/varnish/varnish-modules.git
xcir@build01:~/git/vmod-packager/src$ cd ..

# [Distribution]=Ubuntu focal [Varnish Version]=7.0.0 [VMOD Version]=0.19
xcir@build01:~/git/vmod-packager$ ./vmod-packager.sh -d focal -v 7.0.0 -e 0.19 varnish-modules
xcir@build01:~/git/vmod-packager$ ls pkgs/debs/varnish-modules/
varnish-modules_140.0.19~focal-1_amd64.build      varnish-modules_140.0.19~focal-1_amd64.changes  varnish-modules-dbgsym_140.0.19~focal-1_amd64.ddeb
varnish-modules_140.0.19~focal-1_amd64.buildinfo  varnish-modules_140.0.19~focal-1_amd64.deb

# [Distribution]=CentOS8 [Varnish Version]=7.0.0 [VMOD Version]=0.19
xcir@build01:~/git/vmod-packager$ ./vmod-packager.sh -d centos8 -v 7.0.0 -e 0.19 varnish-modules
xcir@build01:~/git/vmod-packager$ ls pkgs/rpms/varnish-modules/
varnish-modules-0.19-1.el8.src.rpm  varnish-modules-0.19-1.el8.x86_64.rpm
```

# Options

```
xcir@build01:~/git/vmod-packager$ ./vmod-packager.sh -h
Usage: ./vmod-packager.sh [-v Varnish version] [-e vmod vErsion] [-d Distribution] [-f] [-s] [-h] VmodName
-v Varnish version (ex:7.0.0)
-e vmod vErsion (ex:0.1)
-d distribution
-f Fixed varnish version
-s run baSh
-h Help
Example: ./vmod-packager.sh -v 7.0.0 -e 1.0 -d focal libvmod-xcounter
```

| option | explanation | default | example |
|-|:-|:-|:-|
| -v [Varnish version]      | Target varnish version    | 7.0.0 | -v 7.0.0 |
| -e [Vmod version]         | Vmod package version      | 0.1 | -e 0.19 |
| -d [Distribution name]    | Target distribution       | focal | -d focal |
| -f                        | Fix the dependent Varnish version | disabled | -f |
| -s                        | Enter the container       | disabled | -s |

# Support Distribution

See ./docker/ path.

# Default VMOD build pattern

Just before make.
```
# see script/default/default_config.sh
./autogen.sh # or ./bootstrap
./configure
```

## src/[vmod name]_init.sh

This is used when a package needs to be added to the build.

ENV are available.

```bash
#!/bin/sh
if [ "${VMP_PKGTYPE}" = "deb" ]; then
    apt-get -yq install libmhash-dev
else
    dnf -y install libmhash-devel
fi
```

## src/[vmod name]_config.sh

This is used when you need options for configure.

```bash
#!/bin/sh
./autogen.sh
./configure VARNISHSRC=/tmp/varnish/src
```

A sample is available at sample-src/

# Environment variables

| name | explanation | example |
|-|:-|:-|
| VMP_PKGTYPE        | deb or rpm | deb |
| VMP_VARNISH_VRT    | VRT version of Varnish(140=14.0) | 140 |
| VMP_VARNISH_VER    | Varnish Version | 7.0.0 |
| VMP_VARNISH_VER_NXT| Version of Varnish with incrementing miner | 7.1.0 |
| VMP_ROOT_DIR       | root dir(fixed) | /tmp/varnish |
| VMP_WORK_DIR       | work dir(fixed) | /tmp/varnish/work |
| VMP_VMOD_NAME      | Vmod name | libvdp-pesi |
| VMP_VMOD_VER       | Vmod version | 0.1 |
| VMP_FIXED_MODE     | Version fixed mode | 0 |

# path in a container
|path|explanation|
|-|:-|
|${VMP_ROOT_DIR}/src    | Varnish source code with built |
|${VMP_ROOT_DIR}/debian | DEB template |
|${VMP_ROOT_DIR}/rpm    | RPM template |
|${VMP_ROOT_DIR}/pkgs/(debs\|rpms) | Output |
|${VMP_ROOT_DIR}/script | Script |
|${VMP_ROOT_DIR}/vmod/src   | vmod source path |
|${VMP_ROOT_DIR}/work \|\${VMP_WORK_DIR}   | vmod build work space |

# About the output VMOD version

[VRT Version].[specified VMOD version]

- Varnish7.0.0(VRT=140) VMODVer=0.19
  - 140.0.19

