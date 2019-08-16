echo -e "AWSCLI_VERSION = $(clr_cyan ${AWSCLI_VERSION})"
echo -e "YQ_VERSION = $(clr_cyan ${YQ_VERSION})"
echo -e "TERMTOSVG_VERSION = $(clr_cyan ${TERMTOSVG_VERSION})"

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
apt-get install -y python language-pack-en