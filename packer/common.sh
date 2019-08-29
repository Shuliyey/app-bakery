#!/usr/bin/env bash
set -e

################### constants ###################

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'

DRED='\033[1;31m'
DGREEN='\033[1;32m'
DYELLOW='\033[1;33m'
DBLUE='\033[1;34m'
DPURPLE='\033[1;35m'
DCYAN='\033[1;36m'

NC='\033[0m'

################### func/vars ###################

infoMsg() {
  echo -e "$1"
}

doneMsg() {
  echo -e "$1 ${GREEN}done${NC}"
}

warnMsg() {
  echo -e "$1 ${YELLOW}warn${NC}"
}

failMsg() {
  echo -e "$1 ${RED}fail${NC}"
}

source_env() {
  local dir_name=$(cd `dirname $0` && pwd)
  local env_file="${1:-${dir_name}/.env}"

  [ -f "${env_file}" ] && eval "$(cat ${env_file} | grep -v -E "^\s*#" | sed -E "s/^ +//g" | grep -v "$(env | sed -E 's/^([^=]+)=.*$/^\1/g')" | sed "s/^/export /g")" || true
}