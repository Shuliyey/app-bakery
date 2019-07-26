#!/usr/bin/env bash
COLORS=${COLORS:-false}
COLORS_SOURCE=${COLORS_SOURCE:-/tmp/bash_colors.sh}

function usage()
{
  echo "this script installs environment depdency for base"
  echo ""
  echo "./dep.sh"
  echo -e "\t-h --help"
  echo -e "\t--colors (default: false)"
  echo -e "\t--colors-source=\$COLOR_SOURCE (default: $COLORS_SOURCE)"
  echo ""
}

while [ "$1" != "" ]; do
  PARAM=`echo $1 | awk -F= '{print $1}'`
  VALUE=`echo $1 | awk -F= '{print $2}'`
  case $PARAM in
    -h | --help)
      usage
      exit
      ;;
    --colors)
      COLORS=true
      ;;
    --colors-source)
      COLORS_SOURCE=$VALUE
      ;;
    *)
      echo "ERROR: unknown parameter \"$PARAM\""
      usage
      exit 1
      ;;
  esac
  shift
done

if [ "$(echo ${COLORS,,})" == "true" ]; then
  source $COLORS_SOURCE
fi

dir_name=$(cd `dirname $0` && pwd)

for f in $(find "${dir_name}/dep.d" -name "*.sh" -maxdepth 1); do
  eval "$(cat "${f}")"
done