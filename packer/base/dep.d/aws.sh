local DEFAULT_APP="app"
local DEFAULT_DESCRIPTION=""
local DEFAULT_DEBUG="false"
local DEFAULT_AWS_SESSION_TOKEN=""
local DEFAULT_BUILD_VERSION="1.0.0"
local DEFAULT_BUILD_HOST="$(whoami)@$(hostname)"
local DEFAULT_COPY_REGIONS=""
local DEFAULT_VPC_ID=""
local DEFAULT_SUBNET_ID=""
local DEFAULT_VPC_HTTP_PROXY=""
local DEFAULT_VPC_HTTPS_PROXY=""
local DEFAULT_VPC_NO_PROXY=""
local DEFAULT_AWSCLI_VERSION=""
local DEFAULT_YQ_VERSION=$(curl --silent "https://api.github.com/repos/mikefarah/yq/releases/latest" | jq -r ".tag_name" | sed -E 's/^v([0-9\.]+).*$/\1/g')
local DEFAULT_TERMTOSVG_VERSION=$(curl --silent "https://api.github.com/repos/nbedos/termtosvg/releases/latest" | jq -r ".tag_name" | sed -E 's/^v([0-9\.]+).*$/\1/g')

local ENVS=("AWS_ACCESS_KEY_ID" "AWS_SECRET_ACCESS_KEY" "AWS_DEFAULT_REGION")
local OPTIONAL_ENV=("APP" "DESCRIPTION" "DEBUG" "AWS_SESSION_TOKEN" "BUILD_VERSION" "BUILD_HOST" "COPY_REGIONS" "VPC_ID" "SUBNET_ID" "VPC_HTTP_PROXY" "VPC_HTTPS_PROXY" "VPC_NO_PROXY" "AWSCLI_VERSION" "YQ_VERSION" "TERMTOSVG_VERSION")