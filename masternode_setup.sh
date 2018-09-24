#!/bin/bash
TMP_FOLDER=$(mktemp -d)
CONFIGFOLDER=$HOME/.3dcoin
CONFIG_FILE='3dcoin.conf'
COIN_DAEMON='3dcoind'
COIN_CLI='3dcoin-cli'
COIN_PATH='/usr/local/bin/'
COIN_NAME='3dcoin'
COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
COIN_PORT=6695
RPC_PORT=6694
REL=$(lsb_release -c | awk '{print $2}')
case $REL in
  xenial*) 
   COIN_TGZ=
   ;;
  bionic*)
   COIN_TGZ=
   ;;
  *)
   echo "Distro with Codename $REL is not supported by this script"
   exit 4
   ;;
esac
echo avanti 

BLUE="\033[0;34m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m" 
PURPLE="\033[0;35m"
RED='\033[0;31m'
GREEN="\033[0;32m"
NC='\033[0m'
MAG='\e[1;35m'

## ToDO: function to install mandatory tools, like unzip and curl
## ToDo: warnign about missing bind parameter if a MN is already installed

function check_user() {
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}$0 must be run as root.${NC}"
   exit 1
fi
}

function it_exists() {
if [[ -d $CONFIGFOLDER$IP_SELECT ]]; then
  echo
  echo -e "${GREEN}It seems a $COIN_NAME instance is already installed in $CONFIGFOLDER$IP_SELECT"
  echo -e "Save masternodeprivkey if you want to use it again${NC}${RED}"
  echo -e $(cat $CONFIGFOLDER$IP_SELECT/$CONFIG_FILE|grep masternodeprivkey |cut -d "=" -f2)
  echo -e "${NC}${GREEN}Type${NC} ${YELLOW}y${NC} ${GREEN}to scratch it (be carefull, if you are staking on this VPS, also your wallet will be erased)"
  echo -e "Type${NC} ${YELLOW}n${NC} ${GREEN}to exit${NC}"
read -e ANSWER
case $ANSWER in
     y)      
          systemctl stop $COIN_NAME$IP_SELECT.service >/dev/null 2>&1
          systemctl disable $COIN_NAME$IP_SELECT.service >/dev/null 2>&1
          kill -9 $(pidof $COIN_DAEMON) >/dev/null 2>&1
          rm -rf $CONFIGFOLDER$IP_SELECT
          ;;
     n)      
          exit 0
          ;;
     *)
          clear
          it_exists
          ;; 
esac
clear
fi
}

function source-or-bin() {
echo -e "You must choice:"
echo -e "I trust scamar, so i will install a precompiled daemon ${RED}y${NC}"
echo -e "I i dont trust scamar, i will build the daemon ${RED}n${NC}"
echo -e "Type your choice (red char), then press ENTER"
read -e trust
case $trust in
  y*)
   download_node
   ;;
  n*)
   compile_node
   ;;
  *)
   echo "Trust, or not. Your choice ${RED}n${NC} is not clear"
   source-or-bin 
   ;;
esac
}

function compile_node() {
  sudo git clone https://github.com/BlockchainTechLLC/3dcoin.git
  yes | sudo apt-get update 
  export LC_ALL=en_US.UTF-8
  yes | sudo apt-get install build-essential libtool autotools-dev autoconf automake autogen pkg-config libgtk-3-dev libssl-dev libevent-dev bsdmainutils
  yes | sudo apt-get install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev
  yes | sudo apt-get install software-properties-common 
  yes | sudo add-apt-repository ppa:bitcoin/bitcoin 
  yes | sudo apt-get update 
  yes | sudo apt-get install libdb4.8-dev libdb4.8++-dev 
  yes | sudo apt-get install libminiupnpc-dev 
  yes | sudo apt-get install libzmq3-dev
  sleep 2
  cd 3dcoin
  ./autogen.sh
  ./configure --disable-tests --disable-gui-tests --without-gui
  make install-strip
  if [ -e /usr/local/bin/3dcoin ]
   then echo "Binaries compiled successfully"
   else echo "Something went wrong...."
   exit 4
  fi
} 

function download_node() {
  echo -e "${GREEN}Installing dependencies for $COIN_NAME"
case $REL in
  xenial*)
   apt -y install unzip libsodium18 >/dev/null 2>&1
   ;;
  bionic*)
   echo -e "${PURPLE}Adding bitcoin PPA repository"
   apt-add-repository -y ppa:bitcoin/bitcoin >/dev/null 2>&1
   apt update >/dev/null 2>&1
   apt -y install unzip libdb4.8 libdb4.8++ libzmq5 libboost-system1.65.1 libboost-filesystem1.65.1 libboost-program-options1.65.1 libboost-thread1.65.1 libboost-chrono1.65.1 libssl1.1  libminiupnpc10 libevent-pthreads-2.1-6 libevent-2.1-6 libc6 libstdc++6 libgcc1 libsodium23 libnorm1 libpgm-5.2-0 >/dev/null 2>&1
   ;;
esac
  echo -e "${GREEN}Downloading and Installing VPS $COIN_NAME Daemon${NC}"
  cd $TMP_FOLDER >/dev/null 2>&1
  wget -q $COIN_TGZ
  if [[ $? -ne 0 ]]; then
   echo -e 'Error downloading node.'
   exit 1
  fi
  if [[ -f $COIN_PATH$COIN_DAEMON ]]; then
  unzip -j $COIN_ZIP *$COIN_DAEMON >/dev/null 2>&1
  MD5SUMOLD=$(md5sum $COIN_PATH$COIN_DAEMON | awk '{print $1}')
  MD5SUMNEW=$(md5sum $COIN_DAEMON | awk '{print $1}')
  pidof $COIN_DAEMON
  RC=$?
  if [[ "$MD5SUMOLD" != "$MD5SUMNEW" && "$RC" -eq 0 ]]; then
     echo -e 'Those daemon(s) are about to die'
     echo -e $(ps axo cmd:100 | grep $COIN_DAEMON | grep -v grep)
     echo -e 'If systemd service or a custom check is not implemented, take care of their restart'
     for service in $(systemctl | grep $COIN_NAME | awk '{ print $1 }'); do systemctl stop $service >/dev/null 2>&1; done
     sleep 3
     killall $COIN_DAEMON
     RESTARTSYSD=Y
   fi
  fi
  unzip -o -j $COIN_ZIP *$COIN_DAEMON *$COIN_CLI -d $COIN_PATH >/dev/null 2>&1
  chmod +x $COIN_PATH$COIN_DAEMON $COIN_PATH$COIN_CLI
  if [[ "RESTARTSYSD" == "Y" ]]
  then for service in $(systemctl | grep $COIN_NAME | awk '{ print $1 }'); do systemctl start $service >/dev/null 2>&1; done
  fi
  sleep 3
  cd ~ >/dev/null 2>&1
  rm -rf $TMP_FOLDER >/dev/null 2>&1
  clear
}

function custom_exe() {
  echo '#!/bin/bash' > $COIN_PATH$COIN_CLI$IP_SELECT.sh
  echo "$COIN_PATH$COIN_CLI -conf=$CONFIGFOLDER$IP_SELECT/$CONFIG_FILE -datadir=$CONFIGFOLDER$IP_SELECT \$@" >> $COIN_PATH$COIN_CLI$IP_SELECT.sh
  chmod 755 $COIN_PATH$COIN_CLI$IP_SELECT.sh
  echo '#!/bin/bash' > $COIN_PATH$COIN_DAEMON$IP_SELECT.sh
  echo "$COIN_PATH$COIN_DAEMON -conf=$CONFIGFOLDER$IP_SELECT/$CONFIG_FILE -datadir=$CONFIGFOLDER$IP_SELECT \$@" >> $COIN_PATH$COIN_DAEMON$IP_SELECT.sh
  chmod 755 $COIN_PATH$COIN_DAEMON$IP_SELECT.sh
  clear
}

function configure_systemd() {
  cat << EOF > /etc/systemd/system/$COIN_NAME$IP_SELECT.service
[Unit]
Description=$COIN_NAME$IP_SELECT service
After=network.target
[Service]
User=root
Group=root
Type=forking
ExecStart=$COIN_PATH$COIN_DAEMON -daemon -conf=$CONFIGFOLDER$IP_SELECT/$CONFIG_FILE -datadir=$CONFIGFOLDER$IP_SELECT
ExecStop=-$COIN_PATH$COIN_CLI -conf=$CONFIGFOLDER$IP_SELECT/$CONFIG_FILE -datadir=$CONFIGFOLDER$IP_SELECT stop
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
systemctl enable $COIN_NAME$IP_SELECT.service >/dev/null 2>&1
systemctl start $COIN_NAME$IP_SELECT.service
sleep 8
netstat -napt | grep LISTEN | grep $NODEIP | grep $COIN_DAEMON >/dev/null 2>&1
 if [[ $? -ne 0 ]]; then
   ERRSTATUS=TRUE
 fi
}

function check_swap() {
SWAPSIZE=$(cat /proc/meminfo | grep SwapTotal | awk '{print $2}')
FREESPACE=$(df / | tail -1 | awk '{print $4}')
if [ $SWAPSIZE -lt 400000 ]
  then if [ $FREESPACE -gt 6000000 ]
    then dd if=/dev/zero of=/bigfile.swap bs=250MB count=16 
    chmod 600 /bigfile.swap
    mkswap /bigfile.swap
    swapon /bigfile.swap
    echo '/bigfile.swap none swap sw 0 0' >> /etc/fstab
    else echo 'Swap seems smaller than recommended. It cannot be increased because of lack of space'
    fi
fi  
}

function create_config() {
  mkdir $CONFIGFOLDER$IP_SELECT >/dev/null 2>&1
  RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  if [[ -z "$IP_SELECT" ]]; then
   RPC_PORT=$RPC_PORT
   else let RPC_PORT=$RPC_PORT-$IP_SELECT
  fi
  cat << EOF > $CONFIGFOLDER$IP_SELECT/$CONFIG_FILE
#Uncomment RPC credentials if you don't want to use local cookie for auth
#rpcuser=$RPCUSER
#rpcpassword=$RPCPASSWORD
rpcport=$RPC_PORT
server=1
daemon=1
port=$COIN_PORT
EOF
}

function create_key() {
  echo -e "${YELLOW}Enter your ${RED}$COIN_NAME Masternode GEN Key${NC}"
  echo -e "${YELLOW}Press enter to let the script generate one${NC}"
  read -e COINKEY
  if [[ -z "$COINKEY" ]]; then
  $COIN_PATH$COIN_DAEMON$IP_SELECT.sh -daemon >/dev/null 2>&1
  sleep 30
  if [ -z "$(ps axo cmd:100 | grep $COIN_DAEMON)" ]; then
   echo -e "${RED}$COIN_NAME server couldn not start. Check /var/log/syslog for errors.{$NC}"
   exit 1
  fi
  COINKEY=$($COIN_PATH$COIN_CLI$IP_SELECT.sh masternode genkey)
  if [ "$?" -gt "0" ];
    then
    echo -e "${RED}Wallet not fully loaded. Let us wait and try again to generate the GEN Key${NC}"
    sleep 30
    COINKEY=$($COIN_PATH$COIN_CLI$IP_SELECT.sh masternode genkey)
  fi
  $COIN_PATH$COIN_CLI$IP_SELECT.sh stop >/dev/null 2>&1
fi
clear
}

function update_config() {
  sed -i 's/daemon=1/daemon=0/' $CONFIGFOLDER$IP_SELECT/$CONFIG_FILE
  if [[ "$NODEIP" =~ [A-Za-z] ]]; then
    NODEIP=[$NODEIP]
    RPCBIND=[::1]
   else RPCBIND=127.0.0.1
  fi
  cat << EOF >> $CONFIGFOLDER$IP_SELECT/$CONFIG_FILE
maxconnections=64
bind=$NODEIP
rpcbind=$RPCBIND
rpcallow=$RPCBIND
masternode=1
externalip=$NODEIP:$COIN_PORT
masternodeprivkey=$COINKEY
EOF
}


function get_ip() {
  unset NODE_IPS
  declare -a NODE_IPS
  for ips in $(ip a | grep inet | awk '{print $2}' | cut -f1 -d "/")
  do
    NODE_IPS+=($(curl --interface $ips --connect-timeout 4 -sk https://v4.ident.me/))
  done

  if [ ${#NODE_IPS[@]} -gt 1 ]
    then
      echo -e "${GREEN}More than one IP have been found."
      echo -e "Please press ${YELLOW}ENTER${NC} ${GREEN}to use ${NC}${YELLOW}${NODE_IPS[0]}${NC}" 
      echo -e "${GREEN}Type${NC} ${YELLOW}1${NC}${GREEN} for the second one${NC} ${YELLOW}${NODE_IPS[1]}${NC} ${GREEN}and so on..."
      echo -e "If a $COIN_NAME masternode/node is already running on this host, we recommend to press ENTER"
      echo -e "At the end of installation process, the script will ask you if you want to install another masternode${NC}"
      INDEX=
      for ip in "${NODE_IPS[@]}"
      do
        echo ${INDEX} $ip
        let INDEX=${INDEX}+1
      done
      read -e choose_ip
      echo ${NODE_IPS[@]} | grep ${NODE_IPS[$choose_ip]} >/dev/null 2>&1
      if [[ $? -ne 0 ]];
        then echo "Choosen value not in list"
        get_ip
      fi
      IP_SELECT=$choose_ip
      NODEIP=${NODE_IPS[$choose_ip]}
  else
    NODEIP=${NODE_IPS[0]}
    IP_SELECT=
  fi
  clear
}

another_run() {
echo -e "If you want to install another masternode, please type ${RED}y${NC}"
echo -e "Any other key will close such script"
read -e another
if [[ "$another" != "y" ]]
  then echo -e "Good bye!"
  else setup_node
fi
}

function important_information() {
 echo
 echo -e "${BLUE}================================================================================================================================${NC}"
 echo -e "${PURPLE}multiple vps setup${NC}"
 echo -e "${BLUE}================================================================================================================================${NC}"
 echo -e "${GREEN}$COIN_NAME Masternode is up and running listening on port${NC}${PURPLE}$COIN_PORT${NC}."
 echo -e "${GREEN}Configuration file is:${NC}${RED}$CONFIGFOLDER$IP_SELECT/$CONFIG_FILE${NC}"
 echo -e "${GREEN}VPS_IP:${NC}${GREEN}$NODEIP:$COIN_PORT${NC}"
 echo -e "${GREEN}MASTERNODE GENKEY is:${NC}${PURPLE}$COINKEY${NC}"
 echo -e "${BLUE}================================================================================================================================"
 echo -e "${CYAN}Temp${NC}"
 echo -e "${BLUE}================================================================================================================================${NC}"
 echo -e "${CYAN}Ensure Node is fully SYNCED with BLOCKCHAIN (with cli or with custom cli command).${NC}"
 echo -e "${BLUE}================================================================================================================================${NC}"
 echo -e "${PURPLE}Server start (with cli or with custom cli command).${NC}"
 echo -e "${GREEN}3dcoind -datadir=$CONFIGFOLDER$IP_SELECT -daemon${NC}"
 echo -e "${GREEN}$COIN_DAEMON$IP_SELECT.sh -daemon${NC}"
 echo -e "${PURPLE}Server start (with systemctl).${NC}"
 echo -e "${GREEN}systemctl start $COIN_NAME$IP_SELECT.service${NC}"
 echo -e "${PURPLE}Server stop.${NC}"
 echo -e "${GREEN}3dcoin-cli -datadir=$CONFIGFOLDER$IP_SELECT stop${NC}"
 echo -e "${GREEN}$COIN_CLI$IP_SELECT.sh stop${NC}"
 echo -e "${PURPLE}Server stop (with systemctl).${NC}"
 echo -e "${GREEN}systemctl stop $COIN_NAME$IP_SELECT.service${NC}"
 echo -e "${PURPLE}Usage Commands.${NC}"
 echo -e "${GREEN}3dcoin-cli -datadir=$CONFIGFOLDER$IP_SELECT masternode status${NC}"
 echo -e "${GREEN}$COIN_CLI$IP_SELECT.sh masternode status${NC}"
 echo -e "${GREEN}3dcoin-cli -datadir=$CONFIGFOLDER$IP_SELECT getinfo${NC}"
 echo -e "${GREEN}$COIN_CLI$IP_SELECT.sh getinfo${NC}"
 echo -e "${GREEN}3dcoin-cli -datadir=$CONFIGFOLDER$IP_SELECT mnsync status${NC}"
 echo -e "${GREEN}$COIN_CLI$IP_SELECT.sh mnsync status${NC}"
 echo -e "${BLUE}================================================================================================================================${NC}"
 if [[ "$ERRSTATUS" == "TRUE" ]]; then
    echo -e "${RED}$COIN_NAME$IP_SELECT seems not running, please investigate. Check its status by running the following commands as root:${NC}"
    echo -e "systemctl status $COIN_NAME$IP_SELECT.service"
    echo -e "${RED}You can restart it by firing following command (as root):${NC}"
    echo -e "${GREEN}systemctl start $COIN_NAME$IP_SELECT.service${NC}"
    echo -e "${RED}Check errors by runnig following commands:${NC}"
    echo -e "${GREEN}less /var/log/syslog${NC}"
    echo -e "${GREEN}journalctl -xe${NC}"
 fi
 unset NODE_IPS 
}

function setup_node() {
  unset NODE_IPS
  check_user
  check_swap
  source-or-bin
  get_ip
  it_exists
  create_config
  custom_exe
  create_key
  update_config
  configure_systemd
  important_information
  another_run
}


##### Main #####
setup_node
