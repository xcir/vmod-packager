#!/bin/bash
usage_exit() {
        echo "Usage: $0 [-v Varnish version] [-e vmod vErsion] [-o Os] [-f] [-s] [-h] VmodName" 1>&2
        echo "-v Varnish version (ex:7.0.0)" 1>&2
        echo "-e vmod vErsion (ex:0.1)" 1>&2
        echo "-o Os" 1>&2
        echo "-f Fixed varnish version" 1>&2
        echo "-s run baSh" 1>&2
        echo "-h Help" 1>&2
        echo "Example: $0 -v 7.0.0 -e 1.0 -o focal libvmod-xcounter" 1>&2
        exit 1
}

while getopts :v:e:o:sfh OPT
do
    case $OPT in
        v)  VMP_VARNISH_VER=$OPTARG;;
        e)  VMP_VMOD_VER=$OPTARG;;
        o)  VMP_OS=$OPTARG;;
        s)  VMP_EXEC_MODE=sh;;
        f)  VMP_FIXED_MODE=1;;
        h)  usage_exit;;
        \?) usage_exit;;
    esac
done
shift $((OPTIND - 1))

VMP_VMOD=`basename $1`
if [[ -z "${VMP_VMOD}" ]]; then
  usage_exit
fi

##########################
#params
##########################
#VARNISH_VER=7.0.0
#OS=focal
#OS=centos8

#VMOD=libvdp-pesi
#VMOD=varnish-modules
#VMOD_VER=70.1
##########################

if [[ -z "${VMP_VARNISH_VER}" ]]; then
  VMP_VARNISH_VER=7.0.0
fi

if [[ -z "${VMP_OS}" ]]; then
  VMP_OS=focal
fi

if [[ -z "${VMP_FIXED_MODE}" ]]; then
  VMP_FIXED_MODE=0
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

if [ "${VMP_VARNISH_VER}" = "trunk" ]; then
  VMP_VARNISH_VRT=999
  VMP_VARNISH_VER_NXT=trunk
else
  #7.6.5
  VMP_VARNISH_REL=${VMP_VARNISH_VER%.*}        #7.6
  VMP_VARNISH_VER_MAJOR=${VMP_VARNISH_VER%%.*} #7
  VMP_VARNISH_VER_MINOR=${VMP_VARNISH_REL#*.}  #6
  VMP_VARNISH_VER_REV=${VMP_VARNISH_VER##*.}   #5

  VMP_VARNISH_VER_MINOR_NXT=$((${VMP_VARNISH_VER_MINOR} + 1))
  VMP_VARNISH_VER_NXT=${VMP_VARNISH_VER_MAJOR}.${VMP_VARNISH_VER_MINOR_NXT}.0
fi
########################################
# VRT Version	Varnish Version
# 14.0        7.0.x
# 13.0        6.6.x
# 12.0        6.5.x
# 11.0        6.4.x
# 10.0        6.3.x
# 9.0	        6.2.x
# 8.0	        6.1.x
# 7.1	        6.0.4~6.0.x
# 7.0	        6.0.0~6.0.3

if [[ -z "${VMP_VARNISH_VRT}" ]]; then
  case "${VMP_VARNISH_REL}" in
    "7.0") VMP_VARNISH_VRT=140;;
    "6.6") VMP_VARNISH_VRT=130;;
    "6.5") VMP_VARNISH_VRT=120;;
    "6.4") VMP_VARNISH_VRT=110;;
    "6.3") VMP_VARNISH_VRT=100;;
    "6.2") VMP_VARNISH_VRT=90;;
    "6.1") VMP_VARNISH_VRT=80;;
    "6.0")
      if [ $VMP_VARNISH_VER_REV -ge 4 ]; then
        #6.0.4~6.0.x = VRT7.1
        VMP_VARNISH_VRT=71
      else
        #6.0.0~6.0.3 = VRT7.0
        VMP_VARNISH_VRT=70
      fi
      ;;
    *) VMP_VARNISH_VRT=999;;
  esac
fi
########################################

VMP_VARNISH_URL=https://varnish-cache.org/_downloads/varnish-${VMP_VARNISH_VER}.tgz
docker build --rm \
  -t vmods-packager/${VMP_OS}/${VMP_VARNISH_VER} \
  --build-arg VARNISH_VER=${VMP_VARNISH_VER} \
  --build-arg VARNISH_URL=${VMP_VARNISH_URL} \
  -f docker/${VMP_OS} \
  .

docker run --rm \
 -e VMP_VARNISH_VER=${VMP_VARNISH_VER} \
 -e VMP_VARNISH_VER_NXT=${VMP_VARNISH_VER_NXT} \
 -e VMP_VARNISH_VRT=${VMP_VARNISH_VRT} \
 -e VMP_VARNISH_DIR=/tmp/varnish \
 -e VMP_WORK_DIR=/tmp/varnish/work \
 -e VMP_VMOD_NAME=${VMP_VMOD} \
 -e VMP_VMOD_VER=${VMP_VMOD_VER} \
 -e VMP_FIXED_MODE=${VMP_FIXED_MODE} \
 -v `pwd`/script:/tmp/varnish/script \
 -v `pwd`/debian:/tmp/varnish/debian \
 -v `pwd`/rpm:/tmp/varnish/rpm \
 -v `pwd`/pkgs:/tmp/varnish/pkgs \
 -v `pwd`/src:/tmp/varnish/vmod/src \
 --name ${VMP_VMOD}-${VMP_VMOD_VER} -it vmods-packager/${VMP_OS}/${VMP_VARNISH_VER} ${VMP_DOCKER_EXEC}
