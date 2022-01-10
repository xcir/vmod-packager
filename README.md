# vmod-packager

This tool can be used to easily package VMODs that are not provided as packages.
The created package is intended to be used in your own environment.

## VMOD package builder

| | |
|--|:--|
| Author:                   | Shohei Tanaka(@xcir) |
| Date:                     | 2021/12/03 |
| Version:                  | 0.2 |
| Support Varnish Version:  | 6.0 ~|
| Manual section:           | 7 |

# Require

- docker
- curl
- jq

# Quick tutorial

```bash
xcir@build01:~/git/vmod-packager$ cd src
xcir@build01:~/git/vmod-packager/src$ git clone https://github.com/varnish/varnish-modules.git
xcir@build01:~/git/vmod-packager/src$ cd ..

# [Distribution]=Ubuntu focal [Varnish Version]=7.0.0 [VMOD Version]=0.19
xcir@build01:~/git/vmod-packager$ ./vmod-packager.sh -d focal -v 7.0.0 -e 0.19 varnish-modules
...
##################################################
        docker image: vmod-packager/focal:7.0.0-1
                Dist: focal
     Varnish Version: 7.0.0
         Varnish VRT: 140
           VMOD name: varnish-modules
        VMOD Version: 140.0.19
              Status: SUCCESS

xcir@build01:~/git/vmod-packager$ ls pkgs/debs/varnish-modules/
varnish-modules_140.0.19~focal-1_amd64.build      varnish-modules_140.0.19~focal-1_amd64.changes  varnish-modules-dbgsym_140.0.19~focal-1_amd64.ddeb
varnish-modules_140.0.19~focal-1_amd64.buildinfo  varnish-modules_140.0.19~focal-1_amd64.deb

# [Distribution]=CentOS8 [Varnish Version]=7.0.0 [VMOD Version]=0.19
xcir@build01:~/git/vmod-packager$ ./vmod-packager.sh -d centos8 -v 7.0.0 -e 0.19 varnish-modules
...
##################################################
        docker image: vmod-packager/centos8:7.0.0-1
                Dist: centos8
     Varnish Version: 7.0.0
         Varnish VRT: 140
           VMOD name: varnish-modules
        VMOD Version: 140.0.19
              Status: SUCCESS

xcir@build01:~/git/vmod-packager$ ls pkgs/rpms/varnish-modules/
varnish-modules-140.0.19-1.el8.src.rpm  varnish-modules-140.0.19-1.el8.x86_64.rpm

# [Distribution]=Ubuntu focal [Varnish Version]=trunk [VMOD Version]=0.19 [VMOD name prefix]=trunk-
xcir@build01:~/git/vmod-packager$ ./vmod-packager.sh -v trunk -e 0.19 -p trunk- varnish-modules
...
##################################################
        docker image: vmod-packager/centos8:trunk-d497ec0998f3670af1942cb60a9f4316fc2f3cba
                Dist: centos8
     Varnish Version: trunk
 Varnish commit hash: d497ec0998f3670af1942cb60a9f4316fc2f3cba
         Varnish VRT: 140
           VMOD name: varnish-modules
        VMOD Version: 140.0.19
              Status: SUCCESS

xcir@build01:~/git/vmod-packager$ ls pkgs/debs/varnish-modules/
trunk-varnish-modules_140.0.19~focal-1_amd64.build      trunk-varnish-modules_140.0.19~focal-1_amd64.changes  trunk-varnish-modules-dbgsym_140.0.19~focal-1_amd64.ddeb
trunk-varnish-modules_140.0.19~focal-1_amd64.buildinfo  trunk-varnish-modules_140.0.19~focal-1_amd64.deb

# Using patched varnish by myself to VMOD build(-r). And build the varnish package(-k).
xcir@build01:~/git/vmod-packager$ ./vmod-packager.sh -r varnish/varnish-cache/ -k varnish-modules
...
##################################################
        docker image: vmod-packager/focal:trunk-
                Dist: focal
     Varnish Version: trunk
        Varnish hash: 6409bcd629b5088c96f7c6ab55db9a7a979540af
         Varnish VRT: 140
           VMOD name: varnish-modules
        VMOD Version: 140.0.1
              Status: SUCCESS

xcir@build01:~/git/vmod-packager$ ls pkgs/debs/varnish
varnish_20211202.6409bcd-1vmp+fromsrc~focal_amd64.build      varnish_20211202.6409bcd-1vmp+fromsrc~focal_amd64.changes  varnish-dev_20211202.6409bcd-1vmp+fromsrc~focal_amd64.deb
varnish_20211202.6409bcd-1vmp+fromsrc~focal_amd64.buildinfo  varnish_20211202.6409bcd-1vmp+fromsrc~focal_amd64.deb

```


# Options

```
Usage: ./vmod-packager.sh [-v Varnish version] [-r vaRnish source] [-e vmod vErsion] [-d Distribution] [-p vmod name Prefix] [-c Commit hash] [-f] [-s] [-t] [-k] [-h] VmodName
-v Varnish version (ex:7.0.0 or trunk)
-r build VaRnish from local source
-e vmod vErsion (ex:0.1)
-d Distribution
-p vmod name Prefix
-c Commit hash
-f Fixed varnish version
-s run baSh
-t skip Test
-k varnish pacKage build
-h Help
Example: ./vmod-packager.sh -v 7.0.0 -e 1.0 -d focal libvmod-xcounter
```

| option | explanation | default | example |
|-|:-|:-|:-|
| -v [Varnish version]      | Target varnish version    | 7.0.0 | -v 7.0.0 |
| -r [varnish source]       | The name of the Varnish source in varnish/    | varnish-cache | -r varnish-cache |
| -e [Vmod version]         | Vmod package version      | 0.1 | -e 0.19 |
| -p [Vmod name prefix]     | Vmod name prefix          |  | -p test- |
| -d [Distribution name]    | Target distribution       | focal | -d focal |
| -c [Commit hash]          | Target hash(github)       |  | -c d497ec0998f3670af1942cb60a9f4316fc2f3cba |
| -f                        | Fix the dependent Varnish version | disabled | -f |
| -s                        | Enter the container       | disabled | -s |
| -t                        | Skip test                 | disabled | -t |
| -k                        | Varnish package build     | disabled | -k |

# Support Distribution

See ./docker/ path.

# VMOD custom build

Many VMODs use `autogen.sh` `bootstrap` and `configure`.
In this case, you can build without any special configuration.
If you need additional packages or other steps to build, you can use the following script to customize it.

## src/[vmod name]_env.sh

This is used to configure VMP_REQUIRE_(DEB|RPM|ARCH) to specify additional dependent packages.

ENV are available.

```bash
#!/bin/sh

export VMP_REQUIRE_DEB=libmhash2
export VMP_REQUIRE_RPM=mhash
export VMP_REQUIRE_ARCH=mhash
export VMP_RPM_ONLY_INC_VMOD=1
export VMP_RPM_DISABLE_UNPACKAGED_TRACK=1

```

## src/[vmod name]_init.sh

Set this option if the build requires additional packages or additional steps.

ENV are available.

```bash
#!/bin/sh
if [ "${VMP_PKGTYPE}" = "deb" ]; then
    apt-get -yq install libmhash-dev
elif [ "${VMP_PKGTYPE}" = "rpm" ]; then
    dnf -y install libmhash-devel
elif [ "${VMP_PKGTYPE}" = "arch" ]; then
    pacman --noconfirm -Sy mhash
fi
```

```bash
#!/bin/sh

cp -rp ${VMP_ROOT_DIR}/src/m4 ${VMP_WORK_DIR}/src/m4
```

## src/[vmod name]_config.sh

This is used when you need options for configure.

ENV is `not` available.

```bash
#!/bin/sh
./autogen.sh
./configure VARNISHSRC=/tmp/varnish/src
```

A sample is available at sample-src/

# Varnish package build (-k option)

You can create a varnish package by placing [pkg-varnish-cache](https://github.com/varnishcache/pkg-varnish-cache) in the `./varnish/pkg-varnish-cache`
And, used in conjunction with the -r option, it is possible to create a Varnish package with modifications.


# Environment variables

| name | explanation | example |
|-|:-|:-|
| VMP_PKGTYPE        | deb or rpm or arch | deb |
| VMP_VARNISH_VRT    | VRT version of Varnish(140=14.0) | 140 |
| VMP_VARNISH_VER    | Varnish Version | 7.0.0 |
| VMP_VARNISH_VER_NXT| Version of Varnish with incrementing miner | 7.1.0 |
| VMP_ROOT_DIR       | root dir(fixed) | /tmp/varnish |
| VMP_VMOD_ORG_SRC_DIR       | vmod original source dir(fixed) | /tmp/varnish/org/vmod |
| VMP_VARNISH_ORG_DIR       | varnish original source dir(fixed) | /tmp/varnish/org/varnish |
| VMP_WORK_DIR       | work dir(fixed) | /tmp/varnish/work |
| VMP_VMOD_PFX       | Vmod name prefix | test- |
| VMP_VMOD_NAME      | Vmod name | libvdp-pesi |
| VMP_VMOD_VER       | Vmod version | 0.1 |
| VMP_FIXED_MODE     | Version fixed mode | 0 |
| VMP_SKIP_TEST      | Skip test mode | 0 |
| VMP_VARNISH_PKG_MODE | Varnish package build | 0 |
| VMP_HASH           | Varnish hash (trunk only) | f65fcaeae09ff3fc7a32412c59cd8f27a9b7f244 |
| VMP_VARNISH_SRC    | Varnish source dir (from source only) | varnish-cache |

The following is what you specify in src/[vmod name]_env.sh

| name | explanation | example |
|-|:-|:-|
| VMP_REQUIRE_DEB    | Add depends packages(DEB) | foo, bar |
| VMP_REQUIRE_RPM    | Add depends packages(RPM) | foo, bar |
| VMP_REQUIRE_ARCH   | Add depends packages(ARCH)| foo, bar |
| VMP_RPM_ONLY_INC_VMOD                 | Limit the files to be included in the package to VMOD | 1 |
| VMP_RPM_DISABLE_UNPACKAGED_TRACK      | Specify `_unpackaged_files_terminate_build 0` for spec | 1 |

# path in a container
|path|explanation|
|-|:-|
|${VMP_ROOT_DIR}/src    | Varnish source code with built |
|${VMP_ROOT_DIR}/debian | DEB template  |
|${VMP_ROOT_DIR}/rpm    | RPM template  |
|${VMP_ROOT_DIR}/arch   | ARCH template |
|${VMP_ROOT_DIR}/pkgs/(debs\|rpms\|arch) | Output |
|${VMP_ROOT_DIR}/script | Script |
|${VMP_ROOT_DIR}/vmod/src   | vmod source path |
|${VMP_ROOT_DIR}/work \|\${VMP_WORK_DIR}   | vmod build work space |
|${VMP_ROOT_DIR}/tmp   | vmod build temp space |

# Output VMOD Name

[specified VMOD name prefix][specified VMOD name]

- VMOD Name=varnish-modules Prefix=test-
  - test-varnish-modules

# Output VMOD version

[VRT Version].[specified VMOD version]

- Varnish7.0.0(VRT=140) VMODVer=0.19
  - 140.0.19

# Convenient usage

```bash
./vmod-packager.sh -e `date +%Y%m%d` `find src/  -mindepth 1 -maxdepth 1 -type d`
```

# Script exec order

The following is for deb, but it is roughly the same for rpm.(script path is a little different.)

```
./vmod-packager.sh
  + [container]
    +${VMP_ROOT_DIR}/script/build.sh
      +${VMP_ROOT_DIR}/vmod/src/${VMP_VMOD_NAME}_env.sh
      +${VMP_ROOT_DIR}/script/deb/deb-build.sh
        +${VMP_ROOT_DIR}/script/deb/deb-prefilter.sh
        +${VMP_ROOT_DIR}/debian/pkg.sh
        +${VMP_ROOT_DIR}/vmod/src/${VMP_VMOD_NAME}_init.sh
        +${VMP_ROOT_DIR}/script/deb/deb-postfilter.sh
          +(in debuild)/work/src/__vmod-package_config.sh
      +${VMP_ROOT_DIR}/script/tool/varnish-build.sh (If you set the option to build Varnish)
        +${VMP_ROOT_DIR}/script/deb/deb-varnish-build.sh
```

`__vmod-package_config.sh` will be copied from `${VMP_VMOD_NAME}_config.sh` or `script/default/default_config.sh`.

If you want to start and build in shell mode(-s), please run `script/build.sh` in container.

