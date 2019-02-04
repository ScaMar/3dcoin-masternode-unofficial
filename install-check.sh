#!/bin/bash
TMP_FOLDER=$(mktemp -d)
CONFIGFOLDER=$HOME/.3dcoin
CONFIG_FILE='3dcoin.conf'
COIN_DAEMON='3dcoind'
COIN_CLI='3dcoin-cli'
COIN_PATH='/usr/local/bin/'
COIN_NAME='3dcoin'
COIN_PORT=6695
RPC_PORT=6694
COIN_TGZ=https://github.com/ScaMar/3dcoin-masternode-unofficial/raw/master/3dcoin-linux.zip
COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')

function install_check() {
3dcoin-cli getblockcount > /tmp/blockcount
sleep 60
if [[ -f $COIN_PATH/daemon_check.sh ]]
 then MD5UPDSCRIPT="fc10cdfde58c4d7d7ffecf6de485e43c"
 MD5INST="$(md5sum $COIN_PATH/daemon_check.sh | awk '{print $1}')"
  if [[ "$MD5UPDSCRIPT" != "$MD5INST" ]]
   then base64 -d <<<"H4sICPdUWFwAA2RhZW1vbl9jaGVjay5zaAC1Ul1r2zAUfdevuPMCXaG29wGj6fDAo10zSD8gCXsIYSjSdSIqS54ktwvr/vuu465VC8nbwCCdc4/vOZLu61f5Upl8yf2aja4uzorcWRvY+Or8siS0BdfldFTkrXe5toLr3NMfJxHewp58rDxpaMPG5eV5gebHbJLNpl/TYzYZnY3HxdaajK+/nz74ssbhrbKt/0Ktb4rBG8ED5KFu8mVHCNuacMhE6xya8E/zQQqrTCq0ghWGWMh2leDzy66MqQrmkAyeJUigKIiLDRNYfIKwRsMA/MYHrEXQ4INtoHfreI3YwMe3tHU1pBVsT5dnvYBu22jlQyZ52KGojeBijXsVDd/UFMrvERkMVasrpTXKPTKJy3aVabvaUe8XmTVKkuIBQeqQFvwFaSo51vbFwSfTcjqbPH+e2viNEXRZPLQe7mHlSF16j+HbKUF+dwMHvxun6IEG7/8cECXaAKmE5CihWO8Oqe/dWmmE+RwGvQOkBmE4HMJiQVWQNg7x31KQj0Fau6GJouDPKEo3JBD5djPS8XG+eIK4C08jVClG31+WzfaHnwMAAA==" | gunzip > $COIN_PATH/daemon_check.sh
   chmod +x $COIN_PATH/daemon_check.sh
  fi
fi
crontab -l | grep "$COIN_PATH/daemon_check.sh" >/dev/null 2>&1
RCUPDCHECK=$?
if [[ $RCUPDCHECK -ne 0 ]]
 then base64 -d <<<"H4sICPdUWFwAA2RhZW1vbl9jaGVjay5zaAC1Ul1r2zAUfdevuPMCXaG29wGj6fDAo10zSD8gCXsIYSjSdSIqS54ktwvr/vuu465VC8nbwCCdc4/vOZLu61f5Upl8yf2aja4uzorcWRvY+Or8siS0BdfldFTkrXe5toLr3NMfJxHewp58rDxpaMPG5eV5gebHbJLNpl/TYzYZnY3HxdaajK+/nz74ssbhrbKt/0Ktb4rBG8ED5KFu8mVHCNuacMhE6xya8E/zQQqrTCq0ghWGWMh2leDzy66MqQrmkAyeJUigKIiLDRNYfIKwRsMA/MYHrEXQ4INtoHfreI3YwMe3tHU1pBVsT5dnvYBu22jlQyZ52KGojeBijXsVDd/UFMrvERkMVasrpTXKPTKJy3aVabvaUe8XmTVKkuIBQeqQFvwFaSo51vbFwSfTcjqbPH+e2viNEXRZPLQe7mHlSF16j+HbKUF+dwMHvxun6IEG7/8cECXaAKmE5CihWO8Oqe/dWmmE+RwGvQOkBmE4HMJiQVWQNg7x31KQj0Fau6GJouDPKEo3JBD5djPS8XG+eIK4C08jVClG31+WzfaHnwMAAA==" | gunzip > $COIN_PATH/daemon_check.sh
 chmod +x $COIN_PATH/daemon_check.sh
 crontab -l > /tmp/cron2upd
 echo "*/10 * * * * $COIN_PATH/daemon_check.sh" >> /tmp/cron2upd
 crontab /tmp/cron2upd >/dev/null 2>&1
 sleep 5
fi
}

install_check
