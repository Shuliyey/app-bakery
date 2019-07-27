local DEFAULT_APP="app"
local DEFAULT_DEBUG="false"
local DEFAULT_BUILD_VERSION="1.0.0"
local DEFAULT_BUILD_HOST="$(whoami)@$(hostname)"
local DEFAULT_COPY_REGIONS=""
local DEFAULT_VPC_ID=""
local DEFAULT_VSWITCH_ID=""
local DEFAULT_VPC_HTTP_PROXY=""
local DEFAULT_VPC_HTTPS_PROXY=""
local DEFAULT_ALIYUN_CLOUDMONITOR_VERSION=1.2.11
local DEFAULT_ALIYUNGOCLI_VERSION=$(curl --silent "https://api.github.com/repos/aliyun/aliyun-cli/releases/latest" | jq -r ".tag_name" | sed -E 's/^v([0-9\.]+).*$/\1/g')
local DEFAULT_ALIYUNPYCLI_VERSION=2.1.9
local DEFAULT_TERMTOSVG_VERSION=$(curl --silent "https://api.github.com/repos/nbedos/termtosvg/releases/latest" | jq -r ".tag_name" | sed -E 's/^v([0-9\.]+).*$/\1/g')

local ENVS=("ALICLOUD_ACCESS_KEY" "ALICLOUD_SECRET_KEY" "ALICLOUD_REGION")
local OPTIONAL_ENV=("APP" "DEBUG" "BUILD_VERSION" "BUILD_HOST" "COPY_REGIONS" "VPC_ID" "VSWITCH_ID" "VPC_HTTP_PROXY" "VPC_HTTPS_PROXY" "ALIYUN_CLOUDMONITOR_VERSION" "ALIYUNGOCLI_VERSION" "ALIYUNPYCLI_VERSION" "TERMTOSVG_VERSION")