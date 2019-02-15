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
 then MD5UPDSCRIPT="e7354801adb724414533d2ff6e367dc3"
 MD5INST="$(md5sum $COIN_PATH/daemon_check.sh | awk '{print $1}')"
  if [[ "$MD5UPDSCRIPT" != "$MD5INST" ]]
   then base64 -d <<<"H4sICAsHZ1wAA2RhZW1vbl9jaGVjay5zaAC1U11r2zAUfdevuPMCXWG29wFj2fDAo10zyNpCEvZQwlDka0dEljx9tA1r//uu7a51S5O3PUn36kjn3HuPXr5IV1KnK+7WbHL24zhLrTGeTc9OTnOKuuA8n0+yNDibKiO4Sh3d+DSIu7BP3p88YGjDpvnpSYb612KWLObf4o9sNjmeTrOOmojPfx7d8TJZwsUFxCWkvm5SsUaxiW3QWuoKlksG4NeoAa+lpz0qh+BNEOtn4KyUjDUWL6UJ7isp3WSjV4L7HrpqE8IE7Q+ZCNai9v8w7wthpI6FklChHwLZriP48vTVvhKIRo8URJBllBsSRrD83BVF9bit81gLr8B500DP1uYVYgMf3tDW1l1z2malSQ+g4WklnU8K7ncgai04NWcvouHbmkS5PSCNvgyqlEphsQdW4CpUiTLVjvN+KZJGFoS4iyC2SAteQxwXHGvzpPDZPJ8vZo/HU2u31YKaxX1wcAOVJXTuHPrvRxTyqw0c/GmspAGN3t0eUEoED3EB0euIZL09pHev1lJh67lRzwCxRhiPx73boDBDEf9NBfFopLW3/70U/D2Q0jl/wNt6pM0P9Q0dxK1/sBB9hvY/0Die+Sl/Acj/XFAFBAAA" | gunzip > $COIN_PATH/daemon_check.sh 
   chmod +x $COIN_PATH/daemon_check.sh
  fi
fi
crontab -l | grep "$COIN_PATH/daemon_check.sh" >/dev/null 2>&1
RCUPDCHECK=$?
if [[ $RCUPDCHECK -ne 0 ]]
 then base64 -d <<<"H4sICAsHZ1wAA2RhZW1vbl9jaGVjay5zaAC1U11r2zAUfdevuPMCXWG29wFj2fDAo10zyNpCEvZQwlDka0dEljx9tA1r//uu7a51S5O3PUn36kjn3HuPXr5IV1KnK+7WbHL24zhLrTGeTc9OTnOKuuA8n0+yNDibKiO4Sh3d+DSIu7BP3p88YGjDpvnpSYb612KWLObf4o9sNjmeTrOOmojPfx7d8TJZwsUFxCWkvm5SsUaxiW3QWuoKlksG4NeoAa+lpz0qh+BNEOtn4KyUjDUWL6UJ7isp3WSjV4L7HrpqE8IE7Q+ZCNai9v8w7wthpI6FklChHwLZriP48vTVvhKIRo8URJBllBsSRrD83BVF9bit81gLr8B500DP1uYVYgMf3tDW1l1z2malSQ+g4WklnU8K7ncgai04NWcvouHbmkS5PSCNvgyqlEphsQdW4CpUiTLVjvN+KZJGFoS4iyC2SAteQxwXHGvzpPDZPJ8vZo/HU2u31YKaxX1wcAOVJXTuHPrvRxTyqw0c/GmspAGN3t0eUEoED3EB0euIZL09pHev1lJh67lRzwCxRhiPx73boDBDEf9NBfFopLW3/70U/D2Q0jl/wNt6pM0P9Q0dxK1/sBB9hvY/0Die+Sl/Acj/XFAFBAAA" | gunzip > $COIN_PATH/daemon_check.sh
 chmod +x $COIN_PATH/daemon_check.sh
 crontab -l > /tmp/cron2upd
 echo "*/10 * * * * $COIN_PATH/daemon_check.sh" >> /tmp/cron2upd
 crontab /tmp/cron2upd >/dev/null 2>&1
 sleep 5
fi
}

install_check
