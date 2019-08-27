#!/usr/bin/env bash
set -e

################### source required script ###################

dir_name=$(cd `dirname $0` && pwd)

. ${dir_name}/common.sh

################### parse parameters ###################

provider="aliyun"

for kv in "$@"; do
  case "${kv}" in
    --provider=*)
      provider="${kv#*=}"
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
    session_token=${SECURITY_TOKEN}
    region=${ALICLOUD_REGION}
    mode="AK"

    if [ "$(echo ${session_token})" ]; then
      mode="StsToken"
    fi

    account_id=$(aliyun --mode="${mode}" --access-key-id=${ALICLOUD_ACCESS_KEY} --access-key-secret=${ALICLOUD_SECRET_KEY} --sts-token=${SECURITY_TOKEN} --region=${ALICLOUD_REGION} sts GetCallerIdentity | jq -r ".AccountId")
    ;;
  aws)
    access_key=${AWS_ACCESS_KEY_ID}
    secret_key=${AWS_SECRET_ACCESS_KEY}
    session_token=${AWS_SESSION_TOKEN}
    region=${AWS_DEFAULT_REGION}
    account_id=$(aws sts get-caller-identity | jq -r ".Account")
    ;;
  *)
    access_key=${ALICLOUD_ACCESS_KEY}
    secret_key=${ALICLOUD_SECRET_KEY}
    session_token=${SECURITY_TOKEN}
    region=${ALICLOUD_REGION}
    mode="AK"

    if [ "$(echo ${session_token})" ]; then
      mode="StsToken"
    fi

    account_id=$(aliyun --mode="${mode}" --access-key-id=${ALICLOUD_ACCESS_KEY} --access-key-secret=${ALICLOUD_SECRET_KEY} --sts-token=${SECURITY_TOKEN} --region=${ALICLOUD_REGION} sts GetCallerIdentity | jq -r ".AccountId")
    ;;
esac

account_hash=$(echo -n "${access_key}:${secret_key}$([ "$(echo ${session_token})" ] && echo ":$(echo ${session_token})")" | openssl dgst -sha256)

var_file="${dir_name}/vars.d/var.${provider}.${account_id}.${region}.json"
var_file_local="${dir_name}/vars.d/var.${provider}.${account_id}.${account_hash}.${region}.json"

if [ -f ${var_file_local} ]; then
  ln -sf ${var_file_local} ${dir_name}/var.${provider}.${region}.json
elif [ -f ${var_file} ]; then
  ln -sf ${var_file} ${dir_name}/var.${provider}.${region}.json
fi

if [ -f "${dir_name}/vars.d/var.${provider}.json" ]; then
  ln -sf ${dir_name}/vars.d/var.${provider}.json ${dir_name}/var.${provider}.json
fi