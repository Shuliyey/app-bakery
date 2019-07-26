local DEFAULT_APP="app"
local DEFAULT_COPY_REGIONS=""
local DEFAULT_VPC_ID=""
local DEFAULT_TERMTOSVG_VERSION=$(curl --silent "https://api.github.com/repos/nbedos/termtosvg/releases/latest" | jq -r ".tag_name" | sed -E 's/^v([0-9\.]+).*$/\1/g')

local ENVS=("AWS_ACCESS_KEY_ID" "AWS_SECRET_ACCESS_KEY" "AWS_DEFAULT_REGION")
local OPTIONAL_ENV=("APP" "COPY_REGIONS" "VPC_ID" "TERMTOSVG_VERSION")