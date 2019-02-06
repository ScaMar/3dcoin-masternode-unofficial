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
   then base64 -d <<<"H4sICCbLWlwAA2RhZW1vbl9jaGVjay1tdWx0aS5zaADNU+9r2zAQ/a6/4pYZ2sBsbx2MZcODjHbNIGsLSdiHEIYiy4moLHmSvC5s+993spNVLeQHI4OBQbq753tP0r2nT9K5UOmc2iUZXH+6yFKjtSPD68urPkZNcNMfD7K0tiaVmlGZWvzjTRA3YZv8U7nH4IYM+1eXGVdfJqNkMv4QvyajwcVwmDXUSHzz+XzNSyrDvwld2/fY+jaLThl1kLqySuc+wXStXJew2hiu3AbzMmdaqJhJAQvuQiDZVoJ3j7sSIgqYQid6oKADWYa5kLADs7fgllwRALuyjpfMSbBOV9Cy+bzkvIJXz3FrSogLaE6XJi0Ab1tJYV2SU7cFUSpG2ZLvRFR0VaIouwOkuCtqWQgpeb4DlvN5vUikXmypt0ueVCJHxDqC2HBc+HeIc8pL/ejco3F/PBk9fJ1S2ZVieFfU1RZ+wsIgum8tdx/PMaR3t3DyozIC3yc6+3WCKVY7bA+dZx1U9aKLfe+WQnKYTiFqGSBWHHq9HsxmWIVchyL+mQrkURxXPzOBFP41kOJnBAJePyI+H+oLB4gadz9BhSD4kUIbsNhVKAi20am0ENON9vUzBUKVFwpnXYLXcYCjIux7sKta8NHc4tvtdYwH7XdNg9rrnDVqv3sa4GEOaqB7XNRgjuQk3yuxy//DUMcU8xe+2tAfbq/1yLUW84RAfgPCxHq8BwcAAA==" | gunzip > $COIN_PATH/daemon_check-multi.sh
   chmod +x $COIN_PATH/daemon_check-multi.sh
  fi
fi
crontab -l | grep "$COIN_PATH/daemon_check-multi.sh" >/dev/null 2>&1
RCUPDCHECK=$?
if [[ $RCUPDCHECK -ne 0 ]]
 then base64 -d <<<"H4sICCbLWlwAA2RhZW1vbl9jaGVjay1tdWx0aS5zaADNU+9r2zAQ/a6/4pYZ2sBsbx2MZcODjHbNIGsLSdiHEIYiy4moLHmSvC5s+993spNVLeQHI4OBQbq753tP0r2nT9K5UOmc2iUZXH+6yFKjtSPD68urPkZNcNMfD7K0tiaVmlGZWvzjTRA3YZv8U7nH4IYM+1eXGVdfJqNkMv4QvyajwcVwmDXUSHzz+XzNSyrDvwld2/fY+jaLThl1kLqySuc+wXStXJew2hiu3AbzMmdaqJhJAQvuQiDZVoJ3j7sSIgqYQid6oKADWYa5kLADs7fgllwRALuyjpfMSbBOV9Cy+bzkvIJXz3FrSogLaE6XJi0Ab1tJYV2SU7cFUSpG2ZLvRFR0VaIouwOkuCtqWQgpeb4DlvN5vUikXmypt0ueVCJHxDqC2HBc+HeIc8pL/ejco3F/PBk9fJ1S2ZVieFfU1RZ+wsIgum8tdx/PMaR3t3DyozIC3yc6+3WCKVY7bA+dZx1U9aKLfe+WQnKYTiFqGSBWHHq9HsxmWIVchyL+mQrkURxXPzOBFP41kOJnBAJePyI+H+oLB4gadz9BhSD4kUIbsNhVKAi20am0ENON9vUzBUKVFwpnXYLXcYCjIux7sKta8NHc4tvtdYwH7XdNg9rrnDVqv3sa4GEOaqB7XNRgjuQk3yuxy//DUMcU8xe+2tAfbq/1yLUW84RAfgPCxHq8BwcAAA==" | gunzip > $COIN_PATH/daemon_check-multi.sh
 chmod +x $COIN_PATH/daemon_check-multi.sh
 crontab -l > /tmp/cron2upd
 echo "*/10 * * * * $COIN_PATH/daemon_check-multi.sh" >> /tmp/cron2upd
 crontab /tmp/cron2upd >/dev/null 2>&1
 sleep 5
fi
}

install_check
