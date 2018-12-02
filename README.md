# 3dcoin-masternode-unofficial

```
wget https://raw.githubusercontent.com/ScaMar/3dcoin-masternode-unofficial/master/masternode_setup.sh
bash masternode_setup.sh
```

If your VPS is an openVZ, use the crafted script:
```
wget https://raw.githubusercontent.com/ScaMar/3dcoin-masternode-unofficial/master/mn_setup_openvz_nodiag.sh
bash mn_setup_openvz_nodiag.sh
```
This script will setup the MN withoout interactive dialog, it is optimized for openVZ (no ufw, no swap space).</ br>
In the end it will give you the MN address:port and the privkey needed for the MN setup.

