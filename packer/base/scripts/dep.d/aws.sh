echo -e "AWSCLI_VERSION = $(clr_cyan ${AWSCLI_VERSION})"
echo -e "YQ_VERSION = $(clr_cyan ${YQ_VERSION})"
echo -e "TERMTOSVG_VERSION = $(clr_cyan ${TERMTOSVG_VERSION})"

os_id=$(cat /etc/os-release | grep -E "^\s*ID\s*=\s*\".+\"" | sed -E "s/\s*ID\s*=\s*\"(.+)\"/\1/g")

if [ "${os_id}" == "ubuntu" ]; then
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
  apt-get install -y python language-pack-en
fi

if [ "${os_id}" == "amzn" ]; then
  sudo yum update -y
  sudo yum install -y python
fi