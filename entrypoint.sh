#!/bin/bash

if [ "${_DAPPNODE_GLOBAL_CONSENSUS_CLIENT_MAINNET}" == "" ]; then
  echo "Couldn't find consensus client; Exiting"
  exit 0
fi

# CONSENSUS_CLIENT=$(echo "${_DAPPNODE_GLOBAL_CONSENSUS_CLIENT_MAINNET%%.*}")

case $_DAPPNODE_GLOBAL_CONSENSUS_CLIENT_MAINNET in
"teku.dnp.dappnode.eth")
  OUT_VOLUME="tekudnpdappnodeeth_teku-data"
  CONSENSUS_CLIENT=teku
  ;;
"nimbus.dnp.dappnode.eth")
  # OUT_VOLUME="nimbusdnpdappnodeeth_nimbus-data"
  CONSENSUS_CLIENT=nimbus
  ;;
"prysm.dnp.dappnode.eth")
  OUT_VOLUME="prysmdnpdappnodeeth_validator-data"
  CONSENSUS_CLIENT=prysm
  ;;
"lighthouse.dnp.dappnode.eth")
  OUT_VOLUME="lighthousednpdappnodeeth_beacon-data"
  CONSENSUS_CLIENT=lighthouse
  ;;
*)
  echo "Unknown client: $CONSENSUS_CLIENT"
  exit 0
  ;;
esac

# OUT_VOLUME=${CONSENSUS_CLIENT}dnpdappnodeeth_beacon-data

# ligthouse not working atm because we need to set the graffiti file on the vc, but its container has nothing mounted

# teku should work, but check if graffiti file on beacon container overwrites graffiti set on validator container
#   beacon-chain: EXTRA_OPTS: --validators-graffiti-file=/opt/teku/data/graffiti.txt

# prysm
#   validator: EXTRA_OPTS: --graffiti-file=/root/graffiti.txt

# nimbus
echo "Starting pixel drawer for client: $CONSENSUS_CLIENT"
/drawer -consensus_client=$CONSENSUS_CLIENT -output_file=/volumes/${OUT_VOLUME}/graffiti.txt -input_url=$INPUT_URL -nimbus_url=http://DAppNodePackage-beacon-validator.nimbus.dnp.dappnode.eth:4500 -metrics_address=":9107"
