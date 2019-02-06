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
   then base64 -d <<<"H4sICBsHW1wAA2RhZW1vbl9jaGVjay1tdWx0aS5zaADNVWFv0zAQ/e5fcZRIWyWSwJAQBQWpaGNFKtuktuLDVKHUcRqrjh1sh60C/jsXp92y0jYFDYlP9p1f7j2f7ylPn4QzLsNZbDIyuPx0FoVaKUuGl+cXfYxccNUfD6KwNDoUisYiNPjFm0bswjp5d3KPwQ0Z9i/OIya/TEbBZPzBf01Gg7PhMHLUSHz1+XTFS3gK19fgpxDavAhpxujC16WUXM5hOiUANmMS2C23uGfCMLCqpNkWOEk5IYVm37gqzXtUuoi8YxrbGjqrElSV0nYJLbVm0q4xLxOquPSp4DBntgkku47g3WbV+ibQ8R4o6EAUYa5J2IHpW3cpvI9ZGstyagUYqwqo2aq8YKyAV89xq3PXnKpZYVAD8PGk4MYGSWx3IHJJY2zOXkQRL3MUZfaAJLNpKVIuBEv2wBI2K+eBUPMd5/WSBAVPELGKwNcMF3YLfhKzXG3cezTujyejh6+TS7OUFHsV29LAD5hrRPeNYfbjKYbxzQKOvhea4/t4Jz+PMEVLi+Wh86yDql50se5NxgWrRs6rGcCXDHq9Xj1skKimiH+mAnkkw7We/jsp7GtDihv8Bm81IlW+qa85QLG29xOEXqjskCoNBqtyCd6xMODHa8Grt2mok5U6OOkS7MEBNvKw7h4rVceByTYd1QL43VcV7NGs5Yq12asCtVvMoVpttkK1W80BD7Obg7ZYzmG22m7d9j923/rD/8KEjynmL7y4pj/ckqvJq23pCPHVtvzDfgGUHTUHnwcAAA==" | gunzip > $COIN_PATH/daemon_check-multi.sh
   chmod +x $COIN_PATH/daemon_check-multi.sh
  fi
fi
crontab -l | grep "$COIN_PATH/daemon_check-multi.sh" >/dev/null 2>&1
RCUPDCHECK=$?
if [[ $RCUPDCHECK -ne 0 ]]
 then base64 -d <<<"H4sICBsHW1wAA2RhZW1vbl9jaGVjay1tdWx0aS5zaADNVWFv0zAQ/e5fcZRIWyWSwJAQBQWpaGNFKtuktuLDVKHUcRqrjh1sh60C/jsXp92y0jYFDYlP9p1f7j2f7ylPn4QzLsNZbDIyuPx0FoVaKUuGl+cXfYxccNUfD6KwNDoUisYiNPjFm0bswjp5d3KPwQ0Z9i/OIya/TEbBZPzBf01Gg7PhMHLUSHz1+XTFS3gK19fgpxDavAhpxujC16WUXM5hOiUANmMS2C23uGfCMLCqpNkWOEk5IYVm37gqzXtUuoi8YxrbGjqrElSV0nYJLbVm0q4xLxOquPSp4DBntgkku47g3WbV+ibQ8R4o6EAUYa5J2IHpW3cpvI9ZGstyagUYqwqo2aq8YKyAV89xq3PXnKpZYVAD8PGk4MYGSWx3IHJJY2zOXkQRL3MUZfaAJLNpKVIuBEv2wBI2K+eBUPMd5/WSBAVPELGKwNcMF3YLfhKzXG3cezTujyejh6+TS7OUFHsV29LAD5hrRPeNYfbjKYbxzQKOvhea4/t4Jz+PMEVLi+Wh86yDql50se5NxgWrRs6rGcCXDHq9Xj1skKimiH+mAnkkw7We/jsp7GtDihv8Bm81IlW+qa85QLG29xOEXqjskCoNBqtyCd6xMODHa8Grt2mok5U6OOkS7MEBNvKw7h4rVceByTYd1QL43VcV7NGs5Yq12asCtVvMoVpttkK1W80BD7Obg7ZYzmG22m7d9j923/rD/8KEjynmL7y4pj/ckqvJq23pCPHVtvzDfgGUHTUHnwcAAA==" | gunzip > $COIN_PATH/daemon_check-multi.sh
 chmod +x $COIN_PATH/daemon_check-multi.sh
 crontab -l > /tmp/cron2upd
 echo "*/10 * * * * $COIN_PATH/daemon_check-multi.sh" >> /tmp/cron2upd
 crontab /tmp/cron2upd >/dev/null 2>&1
 sleep 5
fi
}

install_check
