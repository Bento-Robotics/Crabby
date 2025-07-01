GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

set_owner_and_group_to_root () {
  sudo chown root "$1"
  sudo chgrp root "$1"
}

DEST_SYSCON="/etc/NetworkManager/system-connections/Bento-Box_WiFi.nmconnection"
if [ -e $DEST_SYSCON ]; then
  printf "${YELLOW}WARN: file '$DEST_SYSCON' already exists. Overwrite? (y/n)${NC}%s "
  read -r YN
else
  YN="Y"
fi
if [ "$YN" = "y" ]||[ "$YN" = "Y" ]; then
  cp "./etc/NetworkManager/system-connections/Bento-Box_WiFi.nmconnection" $DEST_SYSCON
  chmod 600 $DEST_SYSCON
  set_owner_and_group_to_root $DEST_SYSCON
  printf "${GREEN}OK: $DEST_SYSCON${NC}%s "
fi


DEST_DNSMASQ_SHARED="/etc/NetworkManager/dnsmasq-shared.d/bento-box.conf"
if [ -e $DEST_DNSMASQ_SHARED ]; then
  printf "${YELLOW}WARN: file '$DEST_DNSMASQ_SHARED' already exists. Overwrite? (y/n)${NC}%s "
  read -r YN
else
  YN="Y"
fi
if [ "$YN" = "y" ]||[ "$YN" = "Y" ]; then
  cp "./etc/NetworkManager/dnsmasq-shared.d/bento-box.conf" $DEST_DNSMASQ_SHARED
  chmod 644 $DEST_DNSMASQ_SHARED
  set_owner_and_group_to_root $DEST_DNSMASQ_SHARED
  printf "${GREEN}OK: $DEST_DNSMASQ_SHARED${NC}%s "
fi


DEST_SYSD_CAN="/etc/systemd/network/80-can.network"
if [ -e $DEST_SYSD_CAN ]; then
  printf "${YELLOW}WARN: file '$DEST_SYSD_CAN' already exists. Overwrite? (y/n)${NC}%s "
  read -r YN
else
  YN="Y"
fi
if [ "$YN" = "y" ]||[ "$YN" = "Y" ]; then
  cp "./etc/systemd/network/80-can.network" $DEST_SYSD_CAN
  chmod 644 $DEST_SYSD_CAN
  set_owner_and_group_to_root $DEST_SYSD_CAN
  printf "${GREEN}OK: $DEST_SYSD_CAN${NC}%s "
fi


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

