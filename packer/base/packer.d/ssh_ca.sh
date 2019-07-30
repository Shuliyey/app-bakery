#!/usr/bin/env bash
set -e

################### source required script ###################

dir_name=$(cd `dirname $0` && pwd)

. ${dir_name}/../../common.sh

################### parse parameters ###################

password="$(openssl rand -base64 32)"

for kv in "$@"; do
  case "${kv}" in
    --provider=*)
      provider="${kv#*=}"
      ;;
    --service=*)
      service="${kv#*=}"
      ;;
    --password=*)
      password="${kv#*=}"
      ;;
    *)
      infoMsg "unkown param: ${YELLOW}${kv}${NC}, skipping"
      ;;
  esac
done

################### core ###################

ssh_ca_file="${dir_name}/../ansible/${provider}/roles/${service}/files/ssh/authorized_keys/.ca"
ssh_ca_info_file="${dir_name}/ssh_ca.info"

if [ ! -f "${ssh_ca_file}" ]; then
  msg="generating ca key (${CYAN}${ssh_ca_file}${NC}) ..."
  infoMsg "${msg}"
  mkdir -p "$(dirname "${ssh_ca_file}")"
  expect << EOF
spawn ssh-keygen -t rsa -b 4096 -f "${ssh_ca_file}"
expect "Enter passphrase (empty for no passphrase): *" { send "${password//$/\\$}\n" }
expect "Enter same passphrase again: *" { send "${password//$/\\$}\n" }
expect eof
EOF
  meta_msg="writing meta info to ${CYAN}${ssh_ca_info_file}${NC} ..."
  infoMsg "${meta_msg}"
  cat << EOF > "${ssh_ca_info_file}"
path: "${ssh_ca_file}"
password: "${password}"
EOF
  infoMsg "${PURPLE}$(cat "${ssh_ca_info_file}")${NC}"
  doneMsg "${meta_msg}"
  doneMsg "${msg}"
  exit 0
fi

if [ -f "${ssh_ca_info_file}" ]; then
  infoMsg "found ca key info (${CYAN}${ssh_ca_info_file}${NC}):"
  infoMsg "${PURPLE}$(cat "${ssh_ca_info_file}" | sed "s/^/  /g")${NC}"
  exit 0
fi

infoMsg "found existing ca key (${CYAN}${ssh_ca_file}${NC})"