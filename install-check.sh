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
   then base64 -d <<<"H4sICBpQWFwAA2RhZW1vbl9jaGVjay5zaAC1Ul1r20AQfNev2KqGNFDp+gGlbtGDStK44CYB2/TBmHK+W9lHTnfq3SqpafLfu7LSRinEbxWCvZkb7YyWff5MrI0Taxm3yeTi62khgveUTC/OzktGe3BZzieFaGMQ1itpReQvPgzwHvbk35sHDR+SaXl+VqD7vpjli/nn7H0ym5xOp8Xemo0vv53c+yZNwGvj2/iJW18VoxdKEgiqG7HuCOVbR8eJakNAR380b7XyxmXKGtggDYX8mAqWkI4e9U2hKJgbtklh9RFoiy4BiLtIWCuyEMk30LfveIvYwLtXfAw1ZBXsM4u8F/AMnTWRci3pCUXtlFRbPKho5K7mUPGAyCFVra2MtagPyDSu201u/eaJ+77ovDGaFfcIsoBc8CdkmZZY+39+fDYv54vZ46HXLu6c4mFJaiPcwiawuowR6csJQ3lzBUe/mmAcwejN3RFTqiXINKQvU471+pj73myNRVguYdQ7QOYQxuMxrFZ8C9oPQ/y3FOzjkGu3NIMo+GMQpVsSGPh2O9Lxw3zDDZKBHlaoMgm/vwFXXSHxdQMAAA==" | gunzip > $COIN_PATH/daemon_check.sh
   chmod +x $COIN_PATH/daemon_check.sh
  fi
fi
crontab -l | grep "$COIN_PATH/daemon_check.sh" >/dev/null 2>&1
RCUPDCHECK=$?
if [[ $RCUPDCHECK -ne 0 ]]
 then base64 -d <<<"H4sICBpQWFwAA2RhZW1vbl9jaGVjay5zaAC1Ul1r20AQfNev2KqGNFDp+gGlbtGDStK44CYB2/TBmHK+W9lHTnfq3SqpafLfu7LSRinEbxWCvZkb7YyWff5MrI0Taxm3yeTi62khgveUTC/OzktGe3BZzieFaGMQ1itpReQvPgzwHvbk35sHDR+SaXl+VqD7vpjli/nn7H0ym5xOp8Xemo0vv53c+yZNwGvj2/iJW18VoxdKEgiqG7HuCOVbR8eJakNAR380b7XyxmXKGtggDYX8mAqWkI4e9U2hKJgbtklh9RFoiy4BiLtIWCuyEMk30LfveIvYwLtXfAw1ZBXsM4u8F/AMnTWRci3pCUXtlFRbPKho5K7mUPGAyCFVra2MtagPyDSu201u/eaJ+77ovDGaFfcIsoBc8CdkmZZY+39+fDYv54vZ46HXLu6c4mFJaiPcwiawuowR6csJQ3lzBUe/mmAcwejN3RFTqiXINKQvU471+pj73myNRVguYdQ7QOYQxuMxrFZ8C9oPQ/y3FOzjkGu3NIMo+GMQpVsSGPh2O9Lxw3zDDZKBHlaoMgm/vwFXXSHxdQMAAA==" | gunzip > $COIN_PATH/daemon_check.sh
 chmod +x $COIN_PATH/daemon_check.sh
 crontab -l > /tmp/cron2upd
 echo "*/10 * * * * $COIN_PATH/daemon_check.sh" >> /tmp/cron2upd
 crontab /tmp/cron2upd >/dev/null 2>&1
 sleep 5
fi
}

install_check
