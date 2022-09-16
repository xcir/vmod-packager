# vmod-packager

This tool can be used to easily package VMODs that are not provided as packages.
The created package is intended to be used in your own environment.

## VMOD package builder

| | |
|--|:--|
| Author:                   | Shohei Tanaka(@xcir) |
| Date:                     | TBD |
| Version:                  | trunk (See TAG for the release.) |
| Support Varnish Version:  | 6.0 ~|
| Manual section:           | 7 |

# Require

- docker
- curl
- jq

# Quick tutorial

```bash
#create env
xcir@build01:~/git/vmod-packager$ cd src
xcir@build01:~/git/vmod-packager/src$ git clone https://github.com/varnish/varnish-modules.git
xcir@build01:~/git/vmod-packager/src$ cd ../varnish
xcir@build01:~/git/vmod-packager/varnish$ git clone https://github.com/varnishcache/pkg-varnish-cache.git
xcir@build01:~/git/vmod-packager/varnish$ cd ..

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
##################################################
VMOD output:
pkgs/debs/varnish-modules/varnish-modules-dbgsym_140.0.19~focal-1_amd64.ddeb
pkgs/debs/varnish-modules/varnish-modules_140.0.19~focal-1_amd64.build
pkgs/debs/varnish-modules/varnish-modules_140.0.19~focal-1_amd64.buildinfo
pkgs/debs/varnish-modules/varnish-modules_140.0.19~focal-1_amd64.changes
pkgs/debs/varnish-modules/varnish-modules_140.0.19~focal-1_amd64.deb

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
##################################################
VMOD output:
pkgs/rpms/varnish-modules/varnish-modules-140.0.19-1.el8.x86_64.rpm
pkgs/rpms/varnish-modules/varnish-modules-140.0.19-1.el8.src.rpm

# [Distribution]=Arch Linux [Varnish Version]=trunk [VMOD Version]=0.19 [VMOD name prefix]=trunk-
xcir@build01:~/git/vmod-packager$ ./vmod-packager.sh -d arch -v trunk -e 0.19 -p trunk- varnish-modules
...
##################################################
        docker image: vmod-packager/arch:trunk-5598410656eaa2149d31af8fd421faea5a6f45f8
                Dist: arch
     Varnish Version: trunk
        Varnish hash: 5598410656eaa2149d31af8fd421faea5a6f45f8
         Varnish VRT: 140
           VMOD name: trunk-varnish-modules
        VMOD Version: 140.0.19
              Status: SUCCESS
##################################################
VMOD output:
pkgs/arch/varnish-modules/trunk-varnish-modules-140.0.19-1-x86_64.pkg.tar.zst

# Using patched varnish by myself to VMOD build(-r). And build the varnish package(-k).
xcir@build01:~/git/vmod-packager$ ./vmod-packager.sh -r varnish/varnish-cache/ -k varnish-modules
...
##################################################
        docker image: vmod-packager/focal:trunk-761160cefb72acc0317ece435e4448970a68fda3
                Dist: focal
     Varnish Version: trunk
        Varnish hash: 761160cefb72acc0317ece435e4448970a68fda3
         Varnish VRT: 140
           VMOD name: varnish-modules
        VMOD Version: 140.0.1
   Varnish pkg build
              Status: SUCCESS
##################################################
VMOD output:
pkgs/debs/varnish-modules/varnish-modules-dbgsym_140.0.1~focal-1_amd64.ddeb
pkgs/debs/varnish-modules/varnish-modules_140.0.1~focal-1_amd64.build
pkgs/debs/varnish-modules/varnish-modules_140.0.1~focal-1_amd64.buildinfo
pkgs/debs/varnish-modules/varnish-modules_140.0.1~focal-1_amd64.changes
pkgs/debs/varnish-modules/varnish-modules_140.0.1~focal-1_amd64.deb
Varnish output:
pkgs/debs/varnish/varnish-dev_20220121.761160c-1vmp+fromsrc~focal_amd64.deb
pkgs/debs/varnish/varnish_20220121.761160c-1vmp+fromsrc~focal_amd64.build
pkgs/debs/varnish/varnish_20220121.761160c-1vmp+fromsrc~focal_amd64.buildinfo
pkgs/debs/varnish/varnish_20220121.761160c-1vmp+fromsrc~focal_amd64.changes
pkgs/debs/varnish/varnish_20220121.761160c-1vmp+fromsrc~focal_amd64.deb


# Build only Varnish packages.
xcir@build01:~/git/vmod-packager$ ./vmod-packager.sh -v 7.0.1 -k
...
##################################################
        docker image: vmod-packager/focal:7.0.1-1
                Dist: focal
     Varnish Version: 7.0.1
         Varnish VRT: 140
   Varnish pkg build
              Status: SUCCESS
##################################################
Varnish output:
pkgs/debs/varnish/varnish-dev_7.0.1-1vmp~focal_amd64.deb
pkgs/debs/varnish/varnish_7.0.1-1vmp~focal_amd64.build
pkgs/debs/varnish/varnish_7.0.1-1vmp~focal_amd64.buildinfo
pkgs/debs/varnish/varnish_7.0.1-1vmp~focal_amd64.changes
pkgs/debs/varnish/varnish_7.0.1-1vmp~focal_amd64.deb

```


# Options

```
Usage: ./vmod-packager.sh [-v Varnish version] [-r vaRnish source] [-e vmod vErsion] [-d Distribution] [-p vmod name Prefix] [-c Commit hash] [-f] [-s] [-t] [-k] [-u varnish source Url] [-h] VmodName
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
    -u Varnish source URL
    -h Help
Example: ./vmod-packager.sh -v 7.0.0 -e 1.0 -d focal libvmod-xcounter
```

| option | explanation | default | example |
|-|:-|:-|:-|
| -v [Varnish version]      | Target varnish version    | 7.2.0 | -v 7.2.0 |
| -r [varnish source]       | The name of the Varnish source in varnish/    | varnish-cache | -r varnish-cache |
| -e [Vmod version]         | Vmod package version      | 0.1 | -e 0.19 |
| -p [Vmod name prefix]     | Vmod name prefix          |  | -p test- |
| -d [Distribution name]    | Target distribution       | focal | -d focal |
| -c [Commit hash]          | Target hash(github)       |  | -c d497ec0998f3670af1942cb60a9f4316fc2f3cba |
| -f                        | Fix the dependent Varnish version | disabled | -f |
| -s                        | Enter the container       | disabled | -s |
| -t                        | Skip test                 | disabled | -t |
| -k                        | Varnish package build     | disabled | -k |
| -u [varnish source Url]   | Directly specify the URL when the official source URL has been changed (only works when downloading code from the official source)   |  | -u |

# Support Distribution

See ./docker/init/ path.

# VMOD custom build

Many VMODs can be built with `autogen.sh`, `configure`, and `make`, but there are cases where customization is necessary because of required packages or the Varnish source tree.
Therefore, vmod-packager provides two customizations.

## Custom build

Use this for simple customization such as adding packages.

## Full Custom build

If you need a build method other than make (e.g. cargo), you can use "[vmod-name]_build.sh" to package only the generated binaries.

The following custom scripts are available for full custom builds.

In some cases, a full custom build requires a custom build environment as well.
See "Docker custom" below.

## Custom script

| Script | Custom build | Full custom build |
|-|:-|:-|
| src/[vmod name]_env.sh      | Y    | Y |
| src/[vmod name]_init.sh     | Y    | N |
| src/[vmod name]_config.sh   | Y    | N |
| src/[vmod name]_build.sh    | N    | Y |

There are currently 4 types of custom scripts, which are used as needed (you don't have to provide all of them).
If `[vmod name]_build.sh` exists, it is full custom build.

A sample is available at `sample-src/`

The basic location of scripts is `src/`, but they can also be placed in `src/[vmod name]/vmp_config/`.
If both scripts are present, `src/` takes precedence.

### src/[vmod name]_env.sh

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

### src/[vmod name]_init.sh

Set this option if the build requires additional packages or additional steps.

ENV are available.

```bash
#!/bin/sh
if [ "${VMP_PKGTYPE}" = "deb" ]; then
    apt-get update
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

### src/[vmod name]_config.sh

This is used when you need options for configure.

ENV is `not` available.

```bash
#!/bin/sh
./autogen.sh
./configure VARNISHSRC=/tmp/varnish/src
```

### src/[vmod name]_build.sh

```
#!/bin/bash
# https://github.com/gquintard/vmod_reqwest
set -e

SCRIPT_DIR=$(cd $(dirname $0); pwd)

source ~/.cargo/env
if [ "${VMP_PKGTYPE}" = "deb" ]; then
    apt-get update
    apt-get -yq install libssl-dev
elif [ "${VMP_PKGTYPE}" = "rpm" ]; then
    dnf -y install openssl-devel
#elif [ "${VMP_PKGTYPE}" = "arch" ]; then
fi

cd ${VMP_WORK_DIR}/src
cargo build --release
cp ${VMP_WORK_DIR}/src/target/release/*.so ${VMP_WORK_DIR}/vmp_build/usr/lib/varnish/vmods/

```

Please place the generated binary in "${VMP_WORK_DIR}/vmp_build/usr/lib/varnish/vmods/".

# Docker custom (config/docker_extrun_env.sh)

If the VMOD build requires additional packages, you can specify the packages in the custom build, but they will be installed every time.

If you build frequently or need to install a lot of packages, or if you want to create some kind of environment, you may want to create a docker image first because it takes time and is inconvenient.
In this case, you can use `config/docker_extrun_env.sh` to change the docker image.

```bash
#!/bin/sh
RUST_DEB="
    apt-get install --no-install-recommends -yq clang && 
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rust.sh &&
    /bin/sh /tmp/rust.sh -y && rm /tmp/rust.sh
    "

RUST_RPM="
    dnf -y install llvm-toolset && 
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rust.sh &&
    /bin/sh /tmp/rust.sh -y && rm /tmp/rust.sh
    "

RUST_ARCH="
    pacman -Sy --noconfirm clang &&
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rust.sh &&
    /bin/sh /tmp/rust.sh -y && rm /tmp/rust.sh
    "

export VMP_DOCKER_EXTRUN_focal="${RUST_DEB}"
export VMP_DOCKER_EXTRUN_centos8="${RUST_RPM}"
export VMP_DOCKER_EXTRUN_arch="${RUST_ARCH}"
```

Put the command you want to `RUN eval "command"` into `VMP_DOCKER_EXTRUN_[dist]`.


# Varnish package build (-k option)

You can create a varnish package by placing [pkg-varnish-cache](https://github.com/varnishcache/pkg-varnish-cache) in the `./varnish/pkg-varnish-cache`
And, used in conjunction with the -r option, it is possible to create a Varnish package with modifications.

if you don't specify VMOD, only Varnish packages will be created.

```
# [Distribution]=Ubuntu focal [Varnish Version]=7.0.1
xcir@build01:~/git/vmod-packager$ ./vmod-packager.sh -k -d focal -v 7.0.1

# [Distribution]=Ubuntu focal [Varnish commit hash]=454733b82a3279a1603516b4f0a07f8bad4bcd55
xcir@build01:~/git/vmod-packager$ ./vmod-packager.sh -k -d focal -c 454733b82a3279a1603516b4f0a07f8bad4bcd55
```


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
|${VMP_ROOT_DIR}/tplt   | template (deb/rpm/arch) |
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
      +${VMP_ROOT_DIR}/script/deb/deb-prefilter.sh
      +${VMP_ROOT_DIR}/tplt/debian/pkg.sh
      +${VMP_ROOT_DIR}/vmod/src/${VMP_VMOD_NAME}_init.sh
      +${VMP_ROOT_DIR}/script/deb/deb-postfilter.sh
        +(in debuild)/work/src/__vmod-package_config.sh
      +${VMP_ROOT_DIR}/script/tool/varnish-build.sh (If you set the option to build Varnish)
        +${VMP_ROOT_DIR}/script/deb/deb-varnish-build.sh
```

`__vmod-package_config.sh` will be copied from `${VMP_VMOD_NAME}_config.sh` or `script/default/default_config.sh`.

If you want to start and build in shell mode(-s), please run `script/build.sh` in container.

# Clean docker image

If you want to delete the image for some reason, use the following command.

```
docker rmi -f $(docker image ls vmod-packager/* -q)
```
