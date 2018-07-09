#!/bin/bash

CONFIG_FILE='rabbit.conf'
CONFIGFOLDER='/root/.Rabbitcore'
CONFIGFOLDER2='/root/.Rabbitcore2'
CONFIGFOLDER3='/root/.Rabbitcore3'
COIN_DAEMON='/root/rab-ip-install/Rabbitd'
COIN_CLI='/root/rab-ip-install/Rabbit-cli'
COIN_DAEMON2='Rabbitd'
COIN_CLI2='Rabbit-cli'
COIN_PATH='/usr/local/bin/'
COIN_TGZ='https://github.com/RabbitcoreDEV/RabbitCore/releases/download/V1.0.2.2/RabbitCore-v1.0.2.2-linux64.tar.gz'
COIN_ZIP='/root/rab-ip-install/RabbitCore-v1.0.2.2-linux64.tar.gz'
COIN_NAME='rabbit'
COIN_NAME2='rabbit2'
COIN_NAME3='rabbit3'
COIN_PORT=1128
RPC_PORT=1126
RPC_PORT2=1125
RPC_PORT3=1127

NODEIP=$(curl -s4 api.ipify.org)
NODEIP2=$(curl -s4 api.ipify.org)
NODEIP3=$(curl -s4 api.ipify.org)


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'


function download_node() {
  echo -e "Preparing to download ${GREEN}$COIN_NAME${NC}."
  wget -q $COIN_TGZ
  compile_error
  tar xvzf $COIN_ZIP
  chmod +x $COIN_DAEMON $COIN_CLI
  chown root: $COIN_DAEMON $COIN_CLI
  cp $COIN_DAEMON $COIN_PATH
  cp $COIN_CLI $COIN_PATH
  clear
}


function configure_systemd() {
  cat << EOF > /etc/systemd/system/$COIN_NAME.service
[Unit]
Description=$COIN_NAME service
After=network.target

[Service]
User=root
Group=root

Type=forking
#PIDFile=$CONFIGFOLDER/$COIN_NAME.pid

ExecStart=$COIN_PATH$COIN_DAEMON2 -daemon -conf=$CONFIGFOLDER/$CONFIG_FILE -datadir=$CONFIGFOLDER
ExecStop=-$COIN_PATH$COIN_CLI2 -conf=$CONFIGFOLDER/$CONFIG_FILE -datadir=$CONFIGFOLDER stop

Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=5

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 3
  systemctl start $COIN_NAME.service
  systemctl enable $COIN_NAME.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $COIN_DAEMON)" ]]; then
    echo -e "${RED}$COIN_NAME is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $COIN_NAME.service"
    echo -e "systemctl status $COIN_NAME.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
}

function configure_systemd2() {
  cat << EOF > /etc/systemd/system/$COIN_NAME2.service
[Unit]
Description=$COIN_NAME2 service
After=network.target

[Service]
User=root
Group=root

Type=forking
#PIDFile=$CONFIGFOLDER2/$COIN_NAME2.pid

ExecStart=$COIN_PATH$COIN_DAEMON2 -daemon -conf=$CONFIGFOLDER2/$CONFIG_FILE -datadir=$CONFIGFOLDER2
ExecStop=-$COIN_PATH$COIN_CLI2 -conf=$CONFIGFOLDER2/$CONFIG_FILE -datadir=$CONFIGFOLDER2 stop

Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=5

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 3
  systemctl start $COIN_NAME2.service
  systemctl enable $COIN_NAME2.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $COIN_DAEMON)" ]]; then
    echo -e "${RED}$COIN_NAME2 is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $COIN_NAME2.service"
    echo -e "systemctl status $COIN_NAME2.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
}

function configure_systemd3() {
  cat << EOF > /etc/systemd/system/$COIN_NAME3.service
[Unit]
Description=$COIN_NAME3 service
After=network.target

[Service]
User=root
Group=root

Type=forking
#PIDFile=$CONFIGFOLDER3/$COIN_NAME3.pid

ExecStart=$COIN_PATH$COIN_DAEMON2 -daemon -conf=$CONFIGFOLDER3/$CONFIG_FILE -datadir=$CONFIGFOLDER3
ExecStop=-$COIN_PATH$COIN_CLI2 -conf=$CONFIGFOLDER3/$CONFIG_FILE -datadir=$CONFIGFOLDER3 stop

Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=5

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 3
  systemctl start $COIN_NAME3.service
  systemctl enable $COIN_NAME3.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $COIN_DAEMON)" ]]; then
    echo -e "${RED}$COIN_NAME3 is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $COIN_NAME.service"
    echo -e "systemctl status $COIN_NAME3.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
}


function create_config2() {
  mkdir $CONFIGFOLDER2 >/dev/null 2>&1
  RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $CONFIGFOLDER2/$CONFIG_FILE
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcport=$RPC_PORT2
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
port=$COIN_PORT
EOF
}

function create_config3() {
  mkdir $CONFIGFOLDER3 >/dev/null 2>&1
  RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $CONFIGFOLDER3/$CONFIG_FILE
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcport=$RPC_PORT3
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
port=$COIN_PORT
EOF
}

function create_config() {
  mkdir $CONFIGFOLDER >/dev/null 2>&1
  RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $CONFIGFOLDER/$CONFIG_FILE
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcport=$RPC_PORT
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
port=$COIN_PORT
EOF
}

function create_key2() {
  echo -e "Enter your ${RED}$COIN_NAME2 Masternode Private Key${NC}. Leave it blank to generate a new ${RED}Masternode Private Key${NC} for you:"
  read -e COINKEY2
  if [[ -z "$COINKEY2" ]]; then
  $COIN_PATH$COIN_DAEMON2 -daemon
  sleep 30
  if [ -z "$(ps axo cmd:100 | grep $COIN_DAEMON2)" ]; then
   echo -e "${RED}$COIN_NAME2 server couldn not start. Check /var/log/syslog for errors.{$NC}"
   exit 1
  fi
  COINKEY=$($COIN_PATH$COIN_CLI2 masternode genkey)
  if [ "$?" -gt "0" ];
    then
    echo -e "${RED}Wallet not fully loaded. Let us wait and try again to generate the Private Key${NC}"
    sleep 30
    COINKEY=$($COIN_PATH$COIN_CLI2 masternode genkey)
  fi
  $COIN_PATH$COIN_CLI2 stop
fi
clear
}

function create_key3() {
  echo -e "Enter your ${RED}$COIN_NAME3 Masternode Private Key${NC}. Leave it blank to generate a new ${RED}Masternode Private Key${NC} for you:"
  read -e COINKEY3
  if [[ -z "$COINKEY3" ]]; then
  $COIN_PATH$COIN_DAEMON2 -daemon
  sleep 30
  if [ -z "$(ps axo cmd:100 | grep $COIN_DAEMON2)" ]; then
   echo -e "${RED}$COIN_NAME3 server couldn not start. Check /var/log/syslog for errors.{$NC}"
   exit 1
  fi
  COINKEY=$($COIN_PATH$COIN_CLI2 masternode genkey)
  if [ "$?" -gt "0" ];
    then
    echo -e "${RED}Wallet not fully loaded. Let us wait and try again to generate the Private Key${NC}"
    sleep 30
    COINKEY=$($COIN_PATH$COIN_CLI2 masternode genkey)
  fi
  $COIN_PATH$COIN_CLI2 stop
fi
clear
}

function create_key() {
  echo -e "Enter your ${RED}$COIN_NAME Masternode Private Key${NC}. Leave it blank to generate a new ${RED}Masternode Private Key${NC} for you:"
  read -e COINKEY
  if [[ -z "$COINKEY" ]]; then
  $COIN_PATH$COIN_DAEMON2 -daemon
  sleep 30
  if [ -z "$(ps axo cmd:100 | grep $COIN_DAEMON2)" ]; then
   echo -e "${RED}$COIN_NAME server couldn not start. Check /var/log/syslog for errors.{$NC}"
   exit 1
  fi
  COINKEY=$($COIN_PATH$COIN_CLI2 masternode genkey)
  if [ "$?" -gt "0" ];
    then
    echo -e "${RED}Wallet not fully loaded. Let us wait and try again to generate the Private Key${NC}"
    sleep 30
    COINKEY=$($COIN_PATH$COIN_CLI2 masternode genkey)
  fi
  $COIN_PATH$COIN_CLI2 stop
fi
clear
}

function update_config() {
  sed -i 's/daemon=1/daemon=1/' $CONFIGFOLDER/$CONFIG_FILE
  cat << EOF >> $CONFIGFOLDER/$CONFIG_FILE
logintimestamps=1
maxconnections=256
bind=$IP
masternode=1
externalip=$IP:$COIN_PORT
masternodeprivkey=$COINKEY
EOF
}

function update_config2() {
  sed -i 's/daemon=1/daemon=1/' $CONFIGFOLDER2/$CONFIG_FILE
  cat << EOF >> $CONFIGFOLDER2/$CONFIG_FILE
logintimestamps=1
maxconnections=256
bind=$IP2
masternode=1
externalip=$IP2:$COIN_PORT
masternodeprivkey=$COINKEY2
EOF
}

function update_config3() {
  sed -i 's/daemon=1/daemon=1/' $CONFIGFOLDER3/$CONFIG_FILE
  cat << EOF >> $CONFIGFOLDER3/$CONFIG_FILE
logintimestamps=1
maxconnections=256
bind=$IP3
masternode=1
externalip=$IP3:$COIN_PORT
masternodeprivkey=$COINKEY3
EOF
}


function enable_firewall() {
  echo -e "Installing and setting up firewall to allow ingress on port ${GREEN}$COIN_PORT${NC}"
  ufw allow $COIN_PORT/tcp comment "$COIN_NAME MN port" >/dev/null
  ufw allow ssh comment "SSH" >/dev/null 2>&1
  ufw limit ssh/tcp >/dev/null 2>&1
  ufw default allow outgoing >/dev/null 2>&1
  echo "y" | ufw enable >/dev/null 2>&1
}


function get_ip() {
  echo -e "Enter the IP for ${RED}$COIN_NAME ${NC}:"
  read -e IP
  echo -e "Enter the IP for ${RED}$COIN_NAME2 ${NC}:"
  read -e IP2
  echo -e "Enter the IP for ${RED}$COIN_NAME3 ${NC}:"
  read -e IP3
clear
}



function checks() {
if [[ $(lsb_release -d) != *16.04* ]]; then
  echo -e "${RED}You are not running Ubuntu 16.04. Installation is cancelled.${NC}"
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}$0 must be run as root.${NC}"
   exit 1
fi

if [ -n "$(pidof $COIN_DAEMON2)" ] || [ -e "$COIN_DAEMOM2" ] ; then
  echo -e "${RED}$COIN_NAME is already installed.${NC}"
  exit 1
fi
}

function prepare_system() {
echo -e "Preparing the system to install ${GREEN}$COIN_NAME${NC} master node."
apt-get update >/dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y -qq upgrade >/dev/null 2>&1
apt install -y software-properties-common >/dev/null 2>&1
echo -e "${GREEN}Adding bitcoin PPA repository"
apt-add-repository -y ppa:bitcoin/bitcoin >/dev/null 2>&1
echo -e "Installing required packages, it may take some time to finish.${NC}"
apt-get update >/dev/null 2>&1
apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" make software-properties-common \
build-essential libtool autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev libboost-program-options-dev \
libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git wget curl libdb4.8-dev bsdmainutils libdb4.8++-dev \
libminiupnpc-dev libgmp3-dev ufw pkg-config libevent-dev  libdb5.3++ unzip libzmq5 >/dev/null 2>&1
if [ "$?" -gt "0" ];
  then
    echo -e "${RED}Not all required packages were installed properly. Try to install them manually by running the following commands:${NC}\n"
    echo "apt-get update"
    echo "apt -y install software-properties-common"
    echo "apt-add-repository -y ppa:bitcoin/bitcoin"
    echo "apt-get update"
    echo "apt install -y make build-essential libtool software-properties-common autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev \
libboost-program-options-dev libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git curl libdb4.8-dev \
bsdmainutils libdb4.8++-dev libminiupnpc-dev libgmp3-dev ufw pkg-config libevent-dev libdb5.3++ unzip libzmq5"
 exit 1
fi
clear
}

function important_information() {
 echo -e "================================================================================================================================"
 echo -e "$COIN_NAME Masternode is up and running listening on port ${RED}$COIN_PORT${NC}."
 echo -e "Configuration file is: ${RED}$CONFIGFOLDER/$CONFIG_FILE${NC}"
 echo -e "Start: ${RED}systemctl start $COIN_NAME.service${NC}"
 echo -e "Stop: ${RED}systemctl stop $COIN_NAME.service${NC}"
 echo -e "VPS_IP:PORT ${RED}$NODEIP:$COIN_PORT${NC}"
 echo -e "MASTERNODE PRIVATEKEY is: ${RED}$COINKEY${NC}"
 echo -e "Please check ${RED}$COIN_NAME${NC} daemon is running with the following command: ${RED}systemctl status $COIN_NAME.service${NC}"
 echo -e "Use ${RED}$COIN_CLI2 masternode status${NC} to check your MN.${NC}"
 echo -e "JOIN CHT SHARED MN SERVICE LOCATED HERE: ${GREEN}https://sites.google.com/view/chtservices${NC}"
 if [[ -n $SENTINEL_REPO  ]]; then
  echo -e "${RED}Sentinel${NC} is installed in ${RED}$CONFIGFOLDER/sentinel${NC}"
  echo -e "Sentinel logs is: ${RED}$CONFIGFOLDER/sentinel.log${NC}"
  echo -e "CHT SHARED MN SERVICE LOCATED HERE: ${GREEN}http://mns.cryptohashtank.net"{NC}
 fi
 echo -e "================================================================================================================================"
}

function setup_node() {
  get_ip
  create_config
  create_config2
  create_config3
  create_key
  create_key2
  create_key3
  update_config
  update_config2
  update_config3
  enable_firewall
  important_information
  configure_systemd
  configure_systemd2
  configure_systemd3
}


##### Main #####
clear

checks
prepare_system
download_node
setup_node
