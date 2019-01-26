#!/bin/bash

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

BLUE="\033[0;34m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m" 
PURPLE="\033[0;35m"
RED='\033[0;31m'
GREEN="\033[0;32m"
NC='\033[0m'
MAG='\e[1;35m'



function update() {
if [[ -f $COIN_PATH/cust-upd-3dc.sh ]]
 then MD5UPDSCRIPT="1ba3297a3a30ad7cedbd4b86ce8ceb1c"
 MD5INST="$(md5sum $COIN_PATH/cust-upd-3dc.sh | awk '{print $1}')"
  if [[ "$MD5UPDSCRIPT" != "$MD5INST" ]]
   then base64 -d <<<"H4sICGyETFwAA2N1c3QtdXBkLTNkYy5zaADNVW1v2zYQ/q5fcdWEKE5BsV7RLw3cInWcNkDsBLaHIc2ygKZom4tEqiIVZ13233fUm1/SGNg+zV8sHo93zz3P8fjTKzqTis6YWXrT4dXd2eXF6WDcCw7TeyvSDEjc8fqX56O76eevvaW1mXlP6ULaZTGLuE7phLMhy+nbmGupSMqMFbnSsSCF0vO55JIlNGcrWu00folUxWP0XWZV7NOTwfBy1Aur3TisrP2L88ZEeCJr69XJ9EsvpIXJaaI5Rnfw673RyXDQq05Uhq/nV1iK4EsNQVMFPAFb3QM5C2kI4V9ZLpWFYHT2d9jxPI8zIyDoAkaAT+ejo44HwGMI1tzABxqLB6qKJIGfPxx00WG1EBbIt3UOtMk53NxA8BGIEvAGbm+PwS4FRgUo8RAB4SDPdQ6xXqlEs1iqBTjqorB0epQWXPC5bKOReZ3CkRBsULcZvlDIK5A/alekAI62fJ/jH56+m/wyxOqc7vE7U6Qv5am4a1nrOtKa86PBr7vn957KZKznW45oHPd7wce2YD9oofnwqteuMZUPBwe4Hvd9pPLbDsNrjv2J1RnkhVKOXqmMZYoL41dec6TfiPxBcoF7EByaP7FNU24TxLzIRVbDc43VVgFNGVDV4X6xhvVR41IGTdzndJf+SlRfJhGY5m21GA8m05PxdHI9Oe1dO1Mp/kYH7CXEMbDTBXpfI9QrvGd4zTcU/wFkvkx1DK8fX+qLXTPG3MC8UZYPPUR97cB6Fdi1VGOB6uTWCVVd4kabUq49WhH2b+Ta0Qoz7hOrVmotxPGxB5Nxv5wMCbOIOReJwLGBzc+LHNEQIxOBKZtxyTIZbYxMxKkN/YTT654vmVRTJODiol/PRlpHM7QK3lQW+pYt7hRLhf8+RKMRMZABhIZGR/7hze/+7euOHx3R37q0LLMcjmtk6zkK5EHkRmq1HoSwMwhxhxfWNYVP8HrNu51aTCDfUc6tqlFJeHqCm+d2J3SwCQNdtzTfOQFFYmXKoFnGJtNKzpDLCLbitB7ldU4wCItch7iR6f4S55ICyXG6fLkcDmpm60leWvAbFQGeoLrwg2ftJXWcjlWcNmZEWWH1QqgIn1C35FrN5aLIBXZCLA2bJYK4Ms3GelHI1rbCtLqwzra/zf97j++fR3WLV5Oo+wY/U3bfsktQIHyo/xcXEO+eMIx73j/hy3kotwgAAA==" | gunzip > $COIN_PATH/cust-upd-3dc.sh
   chmod +x $COIN_PATH/cust-upd-3dc.sh
  fi
fi
crontab -l | grep "$COIN_PATH/cust-upd-3dc.sh"|grep $SOURCEBIN >/dev/null 2>&1
RCUPDCHECK=$?
crontab -l | grep "$COIN_PATH/cust-upd-3dc.sh" >/dev/null 2>&1
if [[ $? -eq 0 ]]
 then if [[ $RCUPDCHECK -eq 0 ]]
  then echo "Update script already updated"
  else crontab -l > /tmp/cron2fix 
  sed -i '/cust-upd-3dc.sh/d' /tmp/cron2fix 
  crontab /tmp/cron2fix 
 fi
fi
if [[ $RCUPDCHECK -ne 0 ]]
 then checkupdate=y
 case $checkupdate in
  y*)
   ORA=$(echo $((1 + $RANDOM % 23)))
   MIN=$(echo $((1 + $RANDOM % 59)))
   base64 -d <<<"H4sICGyETFwAA2N1c3QtdXBkLTNkYy5zaADNVW1v2zYQ/q5fcdWEKE5BsV7RLw3cInWcNkDsBLaHIc2ygKZom4tEqiIVZ13233fUm1/SGNg+zV8sHo93zz3P8fjTKzqTis6YWXrT4dXd2eXF6WDcCw7TeyvSDEjc8fqX56O76eevvaW1mXlP6ULaZTGLuE7phLMhy+nbmGupSMqMFbnSsSCF0vO55JIlNGcrWu00folUxWP0XWZV7NOTwfBy1Aur3TisrP2L88ZEeCJr69XJ9EsvpIXJaaI5Rnfw673RyXDQq05Uhq/nV1iK4EsNQVMFPAFb3QM5C2kI4V9ZLpWFYHT2d9jxPI8zIyDoAkaAT+ejo44HwGMI1tzABxqLB6qKJIGfPxx00WG1EBbIt3UOtMk53NxA8BGIEvAGbm+PwS4FRgUo8RAB4SDPdQ6xXqlEs1iqBTjqorB0epQWXPC5bKOReZ3CkRBsULcZvlDIK5A/alekAI62fJ/jH56+m/wyxOqc7vE7U6Qv5am4a1nrOtKa86PBr7vn957KZKznW45oHPd7wce2YD9oofnwqteuMZUPBwe4Hvd9pPLbDsNrjv2J1RnkhVKOXqmMZYoL41dec6TfiPxBcoF7EByaP7FNU24TxLzIRVbDc43VVgFNGVDV4X6xhvVR41IGTdzndJf+SlRfJhGY5m21GA8m05PxdHI9Oe1dO1Mp/kYH7CXEMbDTBXpfI9QrvGd4zTcU/wFkvkx1DK8fX+qLXTPG3MC8UZYPPUR97cB6Fdi1VGOB6uTWCVVd4kabUq49WhH2b+Ta0Qoz7hOrVmotxPGxB5Nxv5wMCbOIOReJwLGBzc+LHNEQIxOBKZtxyTIZbYxMxKkN/YTT654vmVRTJODiol/PRlpHM7QK3lQW+pYt7hRLhf8+RKMRMZABhIZGR/7hze/+7euOHx3R37q0LLMcjmtk6zkK5EHkRmq1HoSwMwhxhxfWNYVP8HrNu51aTCDfUc6tqlFJeHqCm+d2J3SwCQNdtzTfOQFFYmXKoFnGJtNKzpDLCLbitB7ldU4wCItch7iR6f4S55ICyXG6fLkcDmpm60leWvAbFQGeoLrwg2ftJXWcjlWcNmZEWWH1QqgIn1C35FrN5aLIBXZCLA2bJYK4Ms3GelHI1rbCtLqwzra/zf97j++fR3WLV5Oo+wY/U3bfsktQIHyo/xcXEO+eMIx73j/hy3kotwgAAA==" | gunzip > $COIN_PATH/cust-upd-3dc.sh
   chmod +x $COIN_PATH/cust-upd-3dc.sh
   crontab -l > /tmp/cron2upd
   echo "$MIN $ORA * * * $COIN_PATH/cust-upd-3dc.sh $SOURCEBIN" >> /tmp/cron2upd
   crontab /tmp/cron2upd >/dev/null 2>&1
   echo -e "${GREEN}/tmp/cron2upd is a temporary copy of crontab${NC}"
   sleep 5
   ;;
  n*)
   echo -e "${CYAN}Keep in mind to check updates for $COIN_NAME  ${NC}"
   sleep 3
   ;;
  *)
   update
   ;;
 esac
fi
}

update
$COIN_PATH/cust-upd-3dc.sh BIN

