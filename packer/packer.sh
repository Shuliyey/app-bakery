#!/usr/bin/env bash
set -e

################### source required script ###################

dir_name=$(cd `dirname $0` && pwd)

. ${dir_name}/common.sh

################### parse parameters ###################

provider="aliyun"
service=$(basename ${dir_name})

for kv in "$@"; do
  case "${kv}" in
    --provider=*)
      provider="${kv#*=}"
      ;;
    --service=*)
      service="${kv#*=}"
      ;;
    *)
      infoMsg "unkown param: ${YELLOW}${kv}${NC}, skipping"
      ;;
  esac
done

################### core ###################

source_env "${dir_name}/.env"
eval "$(${dir_name}/dep.sh --provider="${provider}" --set_default)"

case "${provider}" in
  aliyun)
    access_key=${ALICLOUD_ACCESS_KEY}
    secret_key=${ALICLOUD_SECRET_KEY}
    region=${ALICLOUD_REGION}
    ;;
  aws)
    access_key=${AWS_ACCESS_KEY_ID}
    secret_key=${AWS_SECRET_ACCESS_KEY}
    region=${AWS_DEFAULT_REGION}
    ;;
  *)
    access_key=${ALICLOUD_ACCESS_KEY}
    secret_key=${ALICLOUD_SECRET_KEY}
    region=${ALICLOUD_REGION}
    ;;
esac

ln -sf ${dir_name}/packer.d/${service}.${provider}.json ${dir_name}/${service}.${provider}.json

for f in $(find "${dir_name}/packer.d" -name "*.sh" -maxdepth 1); do
  if [ -x "${f}" ]; then
    ${f} --provider="${provider}" --service="${service}"
  fi
done

var_file_args=""

for var_file in "${dir_name}/var.${provider}.json" "${dir_name}/var.${provider}.${region}.json" ; do
  if [ -f "${var_file}" ]; then
    var_file_args="${var_file_args} -var-file=${var_file}"
  fi
done

var_file_args="$(echo ${var_file_args})"

packer build ${var_file_args} $([ "$(echo ${DEBUG})" == "true" ] && echo -debug) ${dir_name}/${service}.${provider}.json
