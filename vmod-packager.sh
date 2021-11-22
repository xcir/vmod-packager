#!/bin/bash
usage_exit() {
        echo "Usage: $0 [-v Varnish version] [-e vmod vErsion] [-d Distribution] [-p vmod name Prefix] [-c Commit hash] [-f] [-s] [-t] [-h] VmodName" 1>&2
        echo "-v Varnish version (ex:7.0.0 or trunk)" 1>&2
        echo "-e vmod vErsion (ex:0.1)" 1>&2
        echo "-d Distribution" 1>&2
        echo "-p vmod name Prefix" 1>&2
        echo "-c Commit hash" 1>&2
        echo "-f Fixed varnish version" 1>&2
        echo "-s run baSh" 1>&2
        echo "-t skip Test" 1>&2
        echo "-h Help" 1>&2
        echo "Example: $0 -v 7.0.0 -e 1.0 -o focal libvmod-xcounter" 1>&2
        exit 1
}

vmod_build() {


  ########################################
  SCRIPT_DIR=$(cd $(dirname $0); pwd)

  VMP_DOCKER_IMG=vmod-packager/${VMP_DIST}:${VMP_VARNISH_VER}-${VMP_HASH}
  docker build --rm \
    -t ${VMP_DOCKER_IMG} \
    --build-arg VARNISH_VER=${VMP_VARNISH_VER} \
    --build-arg VARNISH_URL=${VMP_VARNISH_URL} \
    -f docker/${VMP_DIST} \
    .
  if [ $? -ne 0 ]; then
      echo "Error: docker build"
      exit 1
  fi
  docker run --rm \
  -e VMP_VARNISH_VER=${VMP_VARNISH_VER} \
  -e VMP_VARNISH_VER_NXT=${VMP_VARNISH_VER_NXT} \
  -e VMP_ROOT_DIR=/tmp/varnish \
  -e VMP_WORK_DIR=/tmp/varnish/work \
  -e VMP_VMOD_NAME=${VMP_VMOD} \
  -e VMP_VMOD_VER=${VMP_VMOD_VER} \
  -e VMP_VMOD_PFX=${VMP_VMOD_PFX} \
  -e VMP_FIXED_MODE=${VMP_FIXED_MODE} \
  -e VMP_SKIP_TEST=${VMP_SKIP_TEST} \
  -v ${SCRIPT_DIR}/script:/tmp/varnish/script \
  -v ${SCRIPT_DIR}/debian:/tmp/varnish/debian \
  -v ${SCRIPT_DIR}/rpm:/tmp/varnish/rpm \
  -v ${SCRIPT_DIR}/pkgs:/tmp/varnish/pkgs \
  -v ${SCRIPT_DIR}/src:/tmp/varnish/vmod/src \
  -v ${SCRIPT_DIR}/tmp:/tmp/varnish/tmp \
  --name ${VMP_VMOD}-${VMP_VMOD_VER} -it ${VMP_DOCKER_IMG} ${VMP_DOCKER_EXEC}
  if [ $? -ne 0 ]; then
      DRSTATUS=FAIL
  else
      DRSTATUS=SUCCESS
  fi
  if [ "${VMP_EXEC_MODE}" = "build" ]; then
    VMP_VARNISH_VRT=`cat ${SCRIPT_DIR}/tmp/vrt`
  fi
  

  echo "##################################################"
  printf "%20s: %s\n" "docker image" "${VMP_DOCKER_IMG}"
  printf "%20s: %s\n" "Dist" "${VMP_DIST}"
  printf "%20s: %s\n" "Varnish Version" "${VMP_VARNISH_VER}"
  if [ "${VMP_VARNISH_VER}" = "trunk" ]; then
    printf "%20s: %s\n" "Varnish commit hash" "${VMP_HASH}"
  fi
  if [ "${VMP_EXEC_MODE}" = "build" ]; then
    printf "%20s: %s\n" "Varnish VRT" "${VMP_VARNISH_VRT}"
  fi
  printf "%20s: %s\n" "VMOD name" "${VMP_VMOD_PFX}${VMP_VMOD}"
  if [ "${VMP_EXEC_MODE}" = "build" ]; then
    printf "%20s: %s\n" "VMOD Version" "${VMP_VARNISH_VRT}.${VMP_VMOD_VER}"
  fi
  if [ ${VMP_FIXED_MODE} -eq 1 ]; then
    printf "%20s\n" "Enable fixed mode"
  fi
  if [ ${VMP_SKIP_TEST} -eq 1 ]; then
    printf "%20s\n" "Enable skip test"
  fi
  if [ "${VMP_EXEC_MODE}" = "build" ]; then
    printf "%20s: %s\n" "Status" "${DRSTATUS}"
  fi
  echo
  if [ "${DRSTATUS}" = "FAIL" ]; then
    exit 1
  fi

}

###################################
#check commands
which docker && which curl && which jq
if [ $? -ne 0 ]; then
  echo "$0 requires docker, curl, jq commands" 1>&2
  exit 1
fi


while getopts :v:e:d:p:c:stfh OPT
do
    case $OPT in
        v)  VMP_VARNISH_VER=$OPTARG;;
        e)  VMP_VMOD_VER=$OPTARG;;
        d)  VMP_DIST=$OPTARG;;
        p)  VMP_VMOD_PFX=$OPTARG;;
        c)  VMP_HASH=$OPTARG;;
        s)  VMP_EXEC_MODE=sh;;
        t)  VMP_SKIP_TEST=1;;
        f)  VMP_FIXED_MODE=1;;
        h)  usage_exit;;
        \?) usage_exit;;
    esac
done
shift $((OPTIND - 1))

if [[ -z "$1" ]]; then
  usage_exit
fi

  if [[ -z "${VMP_VARNISH_VER}" ]]; then
    VMP_VARNISH_VER=7.0.0
  fi

  if [[ -z "${VMP_DIST}" ]]; then
    VMP_DIST=focal
  fi

  if [[ -z "${VMP_FIXED_MODE}" ]]; then
    VMP_FIXED_MODE=0
  fi

  if [[ -z "${VMP_SKIP_TEST}" ]]; then
    VMP_SKIP_TEST=0
  fi

  if [[ -z "${VMP_EXEC_MODE}" ]]; then
    VMP_EXEC_MODE=build
  fi

  if [[ -z "${VMP_VMOD_VER}" ]]; then
    VMP_VMOD_VER=0.1
  fi

  if [ "${VMP_EXEC_MODE}" = "build" ]; then
    VMP_DOCKER_EXEC=/tmp/varnish/script/build.sh
  else
    VMP_DOCKER_EXEC=/bin/bash
  fi

  if [[ -n "${VMP_HASH}" ]]; then
    VMP_VARNISH_VER=trunk
    VMP_VARNISH_VER_NXT=trunk
    VMP_VARNISH_URL=https://github.com/varnishcache/varnish-cache/archive/${VMP_HASH}.tar.gz

  elif [ "${VMP_VARNISH_VER}" = "trunk" ]; then
    VMP_VARNISH_VER_NXT=trunk
    VMP_HASH=`curl -s https://api.github.com/repos/varnishcache/varnish-cache/branches/master | jq '.commit.sha' | tr -d '"'`

    VMP_VARNISH_URL=https://github.com/varnishcache/varnish-cache/archive/${VMP_HASH}.tar.gz

  else
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

while [ -n "$1" ]
do
  VMP_VMOD=`basename $1`
  if [ ! -e "./src/${VMP_VMOD}" ]; then
    echo "./src/${VMP_VMOD} is not found" 1>&2
    usage_exit
  fi
  vmod_build

  shift $((1))
done
