#!/bin/bash

if [ "${_DAPPNODE_GLOBAL_CONSENSUS_CLIENT_GNOSIS}" == "" ]; then
  echo "Couldn't find consensus client; Exiting"
  exit 0
fi

# CONSENSUS_CLIENT=$(echo "${_DAPPNODE_GLOBAL_CONSENSUS_CLIENT_GNOSIS%%.*}")

case $_DAPPNODE_GLOBAL_CONSENSUS_CLIENT_GNOSIS in
"teku-gnosis.dnp.dappnode.eth")
  OUT_VOLUME="teku-gnosisdnpdappnodeeth_teku-gnosis-data"
  CONSENSUS_CLIENT=teku
  ;;
"nimbus")
  OUT_VOLUME=""
  CONSENSUS_CLIENT=nimbus
  ;;
"gnosis-beacon-chain-prysm.dnp.dappnode.eth")
  OUT_VOLUME="gnosis-beacon-chain-prysmdnpdappnodeeth_validator-data"
  CONSENSUS_CLIENT=prysm
  ;;
"lighthouse-gnosis.dnp.dappnode.eth")
  OUT_VOLUME="lighthouse-gnosisdnpdappnodeeth_beacon-data"
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
#   beacon-chain EXTRA_OPTS: --validators-graffiti-file=/opt/teku/data/graffiti.txt

# prysm should work, but can't get it running - the gnosis package doesn't include a jwtsecret at all?
# validator: EXTRA_OPTS: --graffiti-file=/root/graffiti.txt

# nimbus not existing atm
echo "Starting pixel drawer for client: $CONSENSUS_CLIENT"
/drawer -network=gnosis -consensus_client=$CONSENSUS_CLIENT -output_file=/volumes/${OUT_VOLUME}/graffiti.txt -input_url=$INPUT_URL
