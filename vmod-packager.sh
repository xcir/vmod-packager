#!/bin/bash
set -e

##
usage_exit() {
  cat << EOF 1>&2
Usage: $0 [-v Varnish version] [-r vaRnish source] [-e vmod vErsion] [-d Distribution] [-p vmod name Prefix] [-c Commit hash] [-f] [-s] [-t] [-k] [-h] VmodName
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
Example: $0 -v 7.0.0 -e 1.0 -d focal libvmod-xcounter
EOF
  exit 1
}

##
docker_build() {

  docker build --rm \
    -t ${VMP_DOCKER_BASE_IMG} \
    -f docker/init/${VMP_DIST} \
    .

  docker build --rm \
    -t ${VMP_DOCKER_IMG} \
    --build-arg VMP_DOCKER_BASE_IMG=${VMP_DOCKER_BASE_IMG} \
    --build-arg VARNISH_VER=${VMP_VARNISH_VER} \
    --build-arg VARNISH_URL=${VMP_VARNISH_URL} \
    --build-arg VARNISH_NOBUILD=${VMP_VARNISH_FROMSRC} \
    -f docker/Dockerfile \
    .
}

##
vmod_build() {

  docker run --rm \
    -e VMP_VARNISH_VER=${VMP_VARNISH_VER} \
    -e VMP_VARNISH_VER_NXT=${VMP_VARNISH_VER_NXT} \
    -e VMP_ROOT_DIR=/tmp/varnish \
    -e VMP_VMOD_ORG_SRC_DIR=/tmp/varnish/org/vmod \
    -e VMP_VARNISH_ORG_DIR=/tmp/varnish/org/varnish \
    -e VMP_WORK_DIR=/tmp/varnish/work \
    -e VMP_VMOD_NAME=${VMP_VMOD} \
    -e VMP_VMOD_VER=${VMP_VMOD_VER} \
    -e VMP_VMOD_PFX=${VMP_VMOD_PFX} \
    -e VMP_FIXED_MODE=${VMP_FIXED_MODE} \
    -e VMP_SKIP_TEST=${VMP_SKIP_TEST} \
    -e VMP_HASH=${VMP_HASH} \
    -e VMP_VARNISH_PKG_MODE=${VMP_VARNISH_PKG_MODE_A} \
    -e VMP_VARNISH_SRC=${VMP_VARNISH_SRC} \
    -v ${SCRIPT_DIR}/script:/tmp/varnish/script:ro \
    -v ${SCRIPT_DIR}/arch:/tmp/varnish/arch:ro \
    -v ${SCRIPT_DIR}/debian:/tmp/varnish/debian:ro \
    -v ${SCRIPT_DIR}/rpm:/tmp/varnish/rpm:ro \
    -v ${SCRIPT_DIR}/pkgs:/tmp/varnish/pkgs \
    -v ${SCRIPT_DIR}/tmp:/tmp/varnish/tmp \
    -v ${SCRIPT_DIR}/src:/tmp/varnish/org/vmod:ro \
    -v ${SCRIPT_DIR}/varnish:/tmp/varnish/org/varnish:ro \
    --name ${VMP_VARNISH_VER}-${VMP_VMOD}-${VMP_VMOD_VER} -it ${VMP_DOCKER_IMG} ${VMP_DOCKER_EXEC}

  if [ $? -ne 0 ]; then
      DRSTATUS=FAIL
  else
      DRSTATUS=SUCCESS
  fi

  #Get VRT used for the build.
  if [ "${VMP_EXEC_MODE}" = "build" ]; then
    VMP_VARNISH_VRT=`cat ${SCRIPT_DIR}/tmp/vrt`
  fi

  #output result
                                                                    echo "##################################################"
                                                                    printf "%20s: %s\n" "docker image" "${VMP_DOCKER_IMG}"
                                                                    printf "%20s: %s\n" "Dist" "${VMP_DIST}"
                                                                    printf "%20s: %s\n" "Varnish Version" "${VMP_VARNISH_VER}"
  if [ "${VMP_VARNISH_VER}" = "trunk" ]; then                       printf "%20s: %s\n" "Varnish hash" "${VMP_HASH}"; fi
  if [ "${VMP_EXEC_MODE}" = "build" ]; then                         printf "%20s: %s\n" "Varnish VRT" "${VMP_VARNISH_VRT}"; fi
  if [ -n "${VMP_VMOD}" ]; then                                     printf "%20s: %s\n" "VMOD name" "${VMP_VMOD_PFX}${VMP_VMOD}"; fi
  if [ "${VMP_EXEC_MODE}" = "build" -a -n "${VMP_VMOD}" ]; then     printf "%20s: %s\n" "VMOD Version" "${VMP_VARNISH_VRT}.${VMP_VMOD_VER}"; fi
  if [ ${VMP_VARNISH_PKG_MODE} -eq 1 ]; then                        printf "%20s\n" "Varnish pkg build"; fi
  if [ ${VMP_FIXED_MODE} -eq 1 ]; then                              printf "%20s\n" "Fixed mode"; fi
  if [ ${VMP_SKIP_TEST} -eq 1 ]; then                               printf "%20s\n" "Skip test"; fi
  if [ "${VMP_EXEC_MODE}" = "build" ]; then                         printf "%20s: %s\n" "Status" "${DRSTATUS}"; fi
                                                                    echo "##################################################"
  if [ -e "${SCRIPT_DIR}/tmp/vmp_vmod.log" ];then
                                                                    printf "%s\n" "VMOD output:"
                                                                    cat ${SCRIPT_DIR}/tmp/vmp_vmod.log
  fi
  if [ -e "${SCRIPT_DIR}/tmp/vmp_varnish.log" ];then
                                                                    printf "%s\n" "Varnish output:"
                                                                    cat ${SCRIPT_DIR}/tmp/vmp_varnish.log
  fi
  echo

  if [ "${DRSTATUS}" = "FAIL" ]; then exit 1; fi
}

###################################
###################################

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

#check commands
if ! (which docker > /dev/null && which curl > /dev/null && which jq > /dev/null); then
  echo "$0 requires docker, curl, jq commands" 1>&2
  exit 1
fi

#parse option
while getopts :v:r:e:d:p:c:stfkh OPT
do
    case $OPT in
        v)  VMP_VARNISH_VER=$OPTARG;;
        r)  VMP_VARNISH_SRC=`basename $OPTARG`;;
        e)  VMP_VMOD_VER=$OPTARG;;
        d)  VMP_DIST=`basename $OPTARG`;;
        p)  VMP_VMOD_PFX=$OPTARG;;
        c)  VMP_HASH=$OPTARG;;
        s)  VMP_EXEC_MODE=sh;;
        t)  VMP_SKIP_TEST=1;;
        f)  VMP_FIXED_MODE=1;;
        k)  VMP_VARNISH_PKG_MODE=1;;
        h)  usage_exit;;
        \?) usage_exit;;
    esac
done

if [[ -z "${VMP_VARNISH_VER}" ]];       then VMP_VARNISH_VER=7.0.0; fi
if [[ -z "${VMP_DIST}" ]];              then VMP_DIST=focal; fi
if [[ -z "${VMP_FIXED_MODE}" ]];        then VMP_FIXED_MODE=0; fi
if [[ -z "${VMP_SKIP_TEST}" ]];         then VMP_SKIP_TEST=0; fi
if [[ -z "${VMP_EXEC_MODE}" ]];         then VMP_EXEC_MODE=build; fi
if [[ -z "${VMP_VMOD_VER}" ]];          then VMP_VMOD_VER=0.1; fi

if [ "${VMP_EXEC_MODE}" = "build" ]; then
  VMP_DOCKER_EXEC=/tmp/varnish/script/build.sh
else
  VMP_DOCKER_EXEC=/bin/bash
fi
if [[ -z "${VMP_VARNISH_PKG_MODE}" ]]; then
  VMP_VARNISH_PKG_MODE=0;
elif [ ! -e "./varnish/pkg-varnish-cache" ]; then
    echo "./varnish/pkg-varnish-cache is not found" 1>&2
    echo "Varnish requires pkg-varnish-cache( https://github.com/varnishcache/pkg-varnish-cache ) to build" 1>&2
    usage_exit
fi
VMP_VARNISH_PKG_MODE_A=${VMP_VARNISH_PKG_MODE}
VMP_VARNISH_FROMSRC=0

#gen varnish version, download-url and more..
if [[ -n "${VMP_VARNISH_SRC}" ]]; then
  #from source-path(./varnish/[src])
  VMP_VARNISH_VER=trunk
  VMP_VARNISH_VER_NXT=trunk
  VMP_VARNISH_FROMSRC=1
  if [ ! -e "./varnish/${VMP_VARNISH_SRC}" ]; then
    echo "./varnish/${VMP_VARNISH_SRC} is not found" 1>&2
    usage_exit
  fi
  VMP_HASH=src

elif [[ -n "${VMP_HASH}" ]]; then
  #from git-commit-hash
  VMP_VARNISH_VER=trunk
  VMP_VARNISH_VER_NXT=trunk
  VMP_VARNISH_URL=https://github.com/varnishcache/varnish-cache/archive/${VMP_HASH}.tar.gz

elif [ "${VMP_VARNISH_VER}" = "trunk" ]; then
  #from trunk
  VMP_VARNISH_VER_NXT=trunk
  VMP_HASH=`curl -s https://api.github.com/repos/varnishcache/varnish-cache/branches/master | jq -r '.commit.sha'`
  VMP_VARNISH_URL=https://github.com/varnishcache/varnish-cache/archive/${VMP_HASH}.tar.gz

else
  #from v-c.o version.tgz
  #7.6.5
  VMP_VARNISH_REL=${VMP_VARNISH_VER%.*}        #7.6
  VMP_VARNISH_VER_MAJOR=${VMP_VARNISH_VER%%.*} #7
  VMP_VARNISH_VER_MINOR=${VMP_VARNISH_REL#*.}  #6
  VMP_VARNISH_VER_REV=${VMP_VARNISH_VER##*.}   #5
  VMP_HASH=1

  VMP_VARNISH_VER_MINOR_NXT=$((${VMP_VARNISH_VER_MINOR} + 1))
  VMP_VARNISH_VER_NXT=${VMP_VARNISH_VER_MAJOR}.${VMP_VARNISH_VER_MINOR_NXT}.0

  VMP_VARNISH_URL=https://varnish-cache.org/_downloads/varnish-${VMP_VARNISH_VER}.tgz

fi

#gen source hash(VMP-HASH)
if [ ${VMP_VARNISH_FROMSRC} -eq 1 ]; then
  cd $SCRIPT_DIR/varnish/${VMP_VARNISH_SRC}
  VMP_HASH=($(find . -type f  -not -iwholename '*.git/*'|xargs sha1sum |sort|sha1sum ))
  VMP_HASH="${VMP_HASH}"
fi

#specify the docker image to use
VMP_DOCKER_BASE_IMG=vmod-packager/base:${VMP_DIST}
VMP_DOCKER_IMG=vmod-packager/${VMP_DIST}:${VMP_VARNISH_VER}-${VMP_HASH}

#clear build log
rm -f ${SCRIPT_DIR}/tmp/vmp_vmod.log
rm -f ${SCRIPT_DIR}/tmp/vmp_varnish.log


#build vmod/varnish pkg
shift $((OPTIND - 1))
cd $SCRIPT_DIR
if [[ -z "$1" ]]; then
  if [ ${VMP_VARNISH_PKG_MODE} -eq 0 ]; then
    usage_exit
  fi
  # only varnish pkg build
  docker_build
  VMP_VMOD=""
  vmod_build
else
  # vmod build
  docker_build
  while [ -n "$1" ]
  do
    VMP_VMOD=`basename $1`
    if [ ! -e "${SCRIPT_DIR}/src/${VMP_VMOD}" ]; then
      echo "./src/${VMP_VMOD} is not found" 1>&2
      usage_exit
    fi
    vmod_build
    VMP_VARNISH_PKG_MODE_A=0
    shift $((1))
  done
fi
