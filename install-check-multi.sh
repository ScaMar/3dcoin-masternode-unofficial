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
if [[ -f $COIN_PATH/daemon_check-multi.sh ]]
 then MD5UPDSCRIPT="fc10cdfde58c4d7d7ffecf6de485e43c"
 MD5INST="$(md5sum $COIN_PATH/daemon_check-multi.sh | awk '{print $1}')"
  if [[ "$MD5UPDSCRIPT" != "$MD5INST" ]]
   then base64 -d <<<"H4sICGDRWlwAA2RhZW1vbl9jaGVjay1tdWx0aS5zaADNU2Fv0zAQ/e5fcZRIWyWSwJAQBQUpaGNFKtuktuJDVSHXcRprjh1sZ6MC/juXpGVZoU1BQ0KK5Nzd871n+97jR+FCqHBBbUaGlx/OotBo7cjo8vwixqgOruLJMApLa0KpGZWhxR2vWnEdNsmflTsM/pBRfHEecfVpOg6mk3f+SzIeno1GUU2NxFcfT9e8pDD8RujSvsXW15F3zKiD0OVFuKgSTJfK9QkrjeHKbTDPE6aF8pkUsOSuDSS7SvBmuyshIoUZ9Lx7CnoQRZhrE/Zg/hpcxhUBsCvreM6cBOt0AQ1blZecF/DiKf6aHPwU6tOFQQPA21ZSWBck1O1A5IpRlvG9iIKuchRl94AUd2kpUyElT/bAEr4ol4HUyx31ZkmCQiSIWEfgG44L/wJ+Qnmut849nsST6fj+6+TKrhTDu6KutPANlgbRsbXcvT/FkN5ew9HXwgh8H+/k+xGmWOmwPfSe9FDVsz72vc2E5DCbgdcwgK84DAYDmM+xColui/hnKpBHcVyrmWlJ4Z9bUqoZgRZvNSJVvq2vPUDUuLsJSgXBj6TagMWuQoF3LC34dCN4/TYtdapSByd9gndwgI087LvHSlU5sNm2ozoAv/qqgj2YtepmXfaqQN0Wq1GdNlujuq1WAw+zWw3tsFyN+a3tNtf+x+7bbPwvTPiQYv7Cixv6wy25nrzGljXhDxoA9Ic6BwAA" | gunzip > $COIN_PATH/daemon_check-multi.sh
   chmod +x $COIN_PATH/daemon_check-multi.sh
  fi
fi
crontab -l | grep "$COIN_PATH/daemon_check-multi.sh" >/dev/null 2>&1
RCUPDCHECK=$?
if [[ $RCUPDCHECK -ne 0 ]]
 then base64 -d <<<"H4sICGDRWlwAA2RhZW1vbl9jaGVjay1tdWx0aS5zaADNU2Fv0zAQ/e5fcZRIWyWSwJAQBQUpaGNFKtuktuJDVSHXcRprjh1sZ6MC/juXpGVZoU1BQ0KK5Nzd871n+97jR+FCqHBBbUaGlx/OotBo7cjo8vwixqgOruLJMApLa0KpGZWhxR2vWnEdNsmflTsM/pBRfHEecfVpOg6mk3f+SzIeno1GUU2NxFcfT9e8pDD8RujSvsXW15F3zKiD0OVFuKgSTJfK9QkrjeHKbTDPE6aF8pkUsOSuDSS7SvBmuyshIoUZ9Lx7CnoQRZhrE/Zg/hpcxhUBsCvreM6cBOt0AQ1blZecF/DiKf6aHPwU6tOFQQPA21ZSWBck1O1A5IpRlvG9iIKuchRl94AUd2kpUyElT/bAEr4ol4HUyx31ZkmCQiSIWEfgG44L/wJ+Qnmut849nsST6fj+6+TKrhTDu6KutPANlgbRsbXcvT/FkN5ew9HXwgh8H+/k+xGmWOmwPfSe9FDVsz72vc2E5DCbgdcwgK84DAYDmM+xColui/hnKpBHcVyrmWlJ4Z9bUqoZgRZvNSJVvq2vPUDUuLsJSgXBj6TagMWuQoF3LC34dCN4/TYtdapSByd9gndwgI087LvHSlU5sNm2ozoAv/qqgj2YtepmXfaqQN0Wq1GdNlujuq1WAw+zWw3tsFyN+a3tNtf+x+7bbPwvTPiQYv7Cixv6wy25nrzGljXhDxoA9Ic6BwAA" | gunzip > $COIN_PATH/daemon_check-multi.sh
 chmod +x $COIN_PATH/daemon_check-multi.sh
 crontab -l > /tmp/cron2upd
 echo "*/10 * * * * $COIN_PATH/daemon_check-multi.sh" >> /tmp/cron2upd
 crontab /tmp/cron2upd >/dev/null 2>&1
 sleep 5
fi
}

install_check
