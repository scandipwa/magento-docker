#!/usr/bin/env sh
set -eu

# Installing required packages
apk add --update ncurses openssl coreutils

# Color library
bash_color_library() {
  # see if it supports colors...
  ncolors=$(tput colors)
  # shellcheck disable=SC2034
  if test -n "$ncolors" && test $ncolors -ge 8; then

    bold="$(tput bold)"
    underline="$(tput smul)"
    standout="$(tput smso)"
    normal="$(tput sgr0)"
    black="$(tput setaf 0)"
    red="$(tput setaf 1)"
    green="$(tput setaf 2)"
    yellow="$(tput setaf 3)"
    blue="$(tput setaf 4)"
    magenta="$(tput setaf 5)"
    cyan="$(tput setaf 6)"
    white="$(tput setaf 7)"
  fi
}

bash_color_library
bash_colors=$(bash_color_library)
export bash_colors

# # Generating ROOT CA key and cert
mkdir -p /cert
cd /cert || exit

export UID
export GID
# Dicovery of paths for CA and Cert configurations
export CA_CONF_LOCATION
export CERT_CONF_LOCATION
CA_CONF_LOCATION=/cert_config/ca.conf
CERT_CONF_LOCATION=/cert_config/certificate.conf

# Skip Root CA and key generation is exists
if [ -f scandipwa-ca.key ] && [ -f scandipwa-ca.pem ]; then
  echo "${blue}Root CA and it's key already in place, skipping generation${normal}"
else
  echo "${blue}Creating ${bold}Root key and certificate${normal}"
  # Set ca config
  export OPENSSL_CONF=$CA_CONF_LOCATION

  # Creating index and serial files
  echo '01' > /cert/serial && touch /cert/index.txt && touch index.txt.attr
  # Generate CA and key
  echo "${yellow}Generating Root CA and key${normal}"
  openssl req -x509 -newkey rsa:2048 -out scandipwa-ca.pem -outform PEM -days 1825
  echo "${green}Created ${bold}Root key and certificate${normal}"
fi

# If Root CA and key does not exists, abort
if [ ! -f scandipwa-ca.key ] && [ ! -f scandipwa-ca.pem ]; then
  echo "${red}${bold}Root key and certificate are not present, aborting${normal}"
  exit
else
  # Refresh files after cleanup
  if [ -f server_crt.pem ] || [ -f server_key.pem ]; then
    echo "${yellow}Removing old server certificate and key${normal}"
    rm -f server_crt.pem server_key.pem scandipwa-fullchain.pem index.txt index.txt.attr
  fi
  touch index.txt && touch index.txt.attr
  # Set certificate config
  export OPENSSL_CONF=$CERT_CONF_LOCATION
  echo "${yellow}Generating private key for server certificate and CSR${normal}"
  openssl req -newkey rsa:2048 -keyout tempkey.pem -keyform PEM -out tempreq.pem -outform PEM -reqexts 'v3_req'
  # Make server key without passphrase
  echo "${yellow}Generating server key without passphrase, enter same passphrase as above${normal}"
  openssl rsa < tempkey.pem > server_key.pem
  # Singing certificate with CA
  echo "${yellow}Singing server certificate with CA${normal}"
  export OPENSSL_CONF=$CA_CONF_LOCATION
  yes | openssl ca -in tempreq.pem -out server_crt.pem
  cat server_crt.pem scandipwa-ca.pem > scandipwa-fullchain.pem
  chown -R $UID:$GID /cert
  echo "#########################################################################################################################"
  echo "#"                                                                                                                     "#"
  echo "# ${green}Certificate generation is complete${normal}"                                                                 "#"
  echo "# Now you need to import ${bold}scandipwa-ca.pem${normal} into your system/browser to make issued certificate valid"   "#"
  echo "#"                                                                                                                     "#"
  echo "# ${magenta}${bold}Do not commit or share your ${bold}scandipwa-ca.key${normal},"                                      "#"
  echo "# this can lead to major security hole in your system"                                                                 "#"
  echo "#"                                                                                                                     "#"
  echo "#########################################################################################################################"
fi