GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# (permissions, user, group, destination)
# source is assumed to be "./destination"
install_thingy() {
  if [ -e $4 ]; then
    printf "${YELLOW}WARN: file '$4' already exists. Overwrite? (y/n)${NC}%s "
    read -r YN
  else
    YN="Y"
  fi
  if [ "$YN" = "y" ]||[ "$YN" = "Y" ]; then
    install -D -m $1 -o $2 -g $3 "./$4" $4
    printf "${GREEN}OK: $4${NC}%s "
  fi
}

install_thingy 600 root root "/etc/NetworkManager/system-connections/Crabby_WiFi.nmconnection"
install_thingy 644 root root "/etc/systemd/network/80-can.network"
install_thingy 755 root root "/etc/systemd/system/systemd-networkd-wait-online.service.d/override.conf"

printf "${GREEN}set wifi region? (y/n)${NC}%s "
read -r YN
if [ "$YN" = "y" ]||[ "$YN" = "Y" ]; then
  RET=1
  while [ $RET != 0 ]; do
    printf "${GREEN}what region? (2 char name)${NC}%s "
    read -n2 -r REG
    printf "\n"
    sudo iw reg set "${REG}"
    RET=$?
  done
  sudo iw reg get | grep country
fi

