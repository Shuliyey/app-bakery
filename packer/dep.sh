#!/usr/bin/env bash
set -e

################### source required script ###################

dir_name=$(cd `dirname $0` && pwd)

. ${dir_name}/common.sh

################### parse parameters ###################

set_default=false
log_level=info
provider="aliyun"

for kv in "$@"; do
  case "${kv}" in
    --set_default)
      set_default=true
      ;;
    --log_level=*)
      log_level="${kv#*=}"
      ;;
    --provider=*)
      provider="${kv#*=}"
      ;;
    *)
      infoMsg "unkown param: ${YELLOW}${kv}${NC}, skipping"
      ;;
  esac
done

################### funcs/vars ###################

infoMsg() {
  if [ "$(echo ${log_level} | tr A-Z a-z)" == "info" ] && [ "$(echo ${set_default} | tr A-Z a-z)" != "true" ]; then
    echo -e "$1"
  fi
}

errorMsg() {
  if [ "$(echo ${log_level} | tr A-Z a-z)" != "none" ]; then
    echo -e "$1"
  fi
}

get_default() {
  local val=$(eval "echo \$DEFAULT_$(echo "${1}" | tr a-z A-Z)")
  echo $val
}

check_dep() {
  local dir_name=$(cd `dirname $0` && pwd)
  if [ -f "${dir_name}/dep.d/${provider}.dep.sh" ]; then
    eval "$(cat ${dir_name}/dep.d/${provider}.dep.sh)"

    ################# example of ${dir_name}/dep.d/${provider}.dep.sh #################
    # local DEFAULT_COPY_REGIONS=""
    # local DEFAULT_VPC_ID=""
    # local DEFAULT_VSWITCH_ID=""
    # local DEFAULT_VPC_HTTP_PROXY=""
    # local DEFAULT_VPC_HTTPS_PROXY=""
    # local DEFAULT_ALIYUN_CLOUDMONITOR_VERSION=1.2.11
    # local DEFAULT_ALIYUNGOCLI_VERSION=$(curl --silent "https://api.github.com/repos/aliyun/aliyun-cli/releases/latest" | jq -r ".tag_name" | sed -E 's/^v([0-9\.]+).*$/\1/g')
    # local DEFAULT_ALIYUNPYCLI_VERSION=2.1.9
    # local DEFAULT_TERMTOSVG_VERSION=$(curl --silent "https://api.github.com/repos/nbedos/termtosvg/releases/latest" | jq -r ".tag_name" | sed -E 's/^v([0-9\.]+).*$/\1/g')
    # 
    # local ENVS=("ALICLOUD_ACCESS_KEY" "ALICLOUD_SECRET_KEY" "ALICLOUD_REGION")
    # local OPTIONAL_ENV=("COPY_REGIONS" "VPC_ID" "VSWITCH_ID" "VPC_HTTP_PROXY" "VPC_HTTPS_PROXY" "ALIYUN_CLOUDMONITOR_VERSION" "ALIYUNGOCLI_VERSION" "ALIYUNPYCLI_VERSION" "TERMTOSVG_VERSION")
    # local missing=()
    # local found=()
    # local optional=()
    ###################################################################################
  else
    errorMsg "unkown provider: ${RED}${provider}${NC}, ${CYAN}${dir_name}/dep.d/${provider}.dep.sh${NC} ${RED}doesn't exist${NC}, exiting"
    exit 1
  fi

  local missing=()
  local found=()
  local optional=()

  for g in "${ENVS[@]}"; do
    g=($g)
    local found_g=()
    for e in ${g[@]}; do
      if [ ! "$(echo ${!e})" ]; then
        continue
      fi
      found_g+=($e)
    done
    if [ ${#found_g[@]} == 0 ]; then
      g=${g[@]}
      missing+=("${g// /|}")
      continue
    fi
    found_g=${found_g[@]}
    found+=("${found_g// /|}")
  done

  for g in "${OPTIONAL_ENV[@]}"; do
    g=($g)
    local found_g=()
    for e in ${g[@]}; do
      if [ ! "$(echo ${!e})" ]; then
        continue
      fi
      found_g+=($e)
    done
    if [ ${#found_g[@]} == 0 ]; then
      g=${g[@]}
      optional+=("${g// /|}")
      continue
    fi
    found_g=${found_g[@]}
    found+=("${found_g// /|}")
  done

  if [ ${#found[@]} -gt 0 ]; then
    infoMsg "${DGREEN}found${NC}:"
    for g in "${found[@]}"; do
      local g=(${g//|/ })
      if [ ${#g[@]} -gt 1 ]; then
        local d=${g[@]}
        infoMsg "  ${DCYAN}* ${d// /|}${NC}:"
        for e in ${g[@]}; do
          infoMsg "    ${CYAN}- ${e}=${!e}${NC}"
        done
        continue
      fi
      for e in ${g[@]}; do
        infoMsg "  ${CYAN}* ${e}=${!e}${NC}"
      done
    done
  fi

  if [ ${#optional[@]} -gt 0 ]; then
    infoMsg "${DYELLOW}optional${NC}:"
    for g in "${optional[@]}"; do
      local g=(${g//|/ })
      if [ ${#g[@]} -gt 1 ]; then
        local d=${g[@]}
        infoMsg "  ${DPURPLE}* ${d// /|}${NC}:"
        local kv=""
        for e in ${g[@]}; do
          kv="${kv}
${e} $(get_default ${e})"
        done
        kv=$(echo "${kv}" | sed '/^\s*$/d' | sort -k2 -k1)
        local v_uniq=$(echo "${kv}" | awk '{print $2}' | uniq -c | awk '{print  $1 " " $2}')
        local k=($(echo "${kv}" | awk '{print $1}'))
        local count=0
        for c in $(echo "${v_uniq[@]}" | awk '{print $1}'); do
          local a=${k[@]:$count:$c}
          a=${a// /,}
          infoMsg "    ${PURPLE}- ${a} (default: $(get_default ${k[$count]}))${NC}"
          for _a in ${a//,/ }; do
            if [ "$(echo ${set_default} | tr A-Z a-z)" == "true" ]; then
              echo "export ${_a}=\"$(get_default ${_a})\""
            fi
          done
          count=$((count + c))
        done
        continue
      fi
      for e in ${g[@]}; do
        infoMsg "  ${PURPLE}* ${e} (default: $(get_default ${e}))${NC}"
        if [ "$(echo ${set_default} | tr A-Z a-z)" == "true" ]; then
          echo "export ${e}=\"$(get_default ${e})\""
        fi
      done
    done
  fi

  if [ ${#missing[@]} -gt 0 ]; then
    errorMsg "${DRED}missing${NC}:"
    for e in ${missing[@]}; do
      errorMsg "  ${YELLOW}* ${e}${NC}"
    done
    exit 1
  fi
}

################### core ###################

source_env "${dir_name}/.env"
check_dep