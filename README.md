# DAppNodePackage-graffitidrawer

This community project is meant to help DAppNode users draw images on the [beaconcha.in graffitiwall](https://beaconcha.in/graffitiwall). It encapsulates [DecentralizedGraffitiDrawing](https://github.com/stake-house/DecentralizedGraffitiDrawing), a standalone tool which can be used by all node operators. It has been used to draw multiple images on the [mainnet](https://beaconcha.in/graffitiwall) and [gnosis beacon chain](https://beacon.gnosischain.com/graffitiwall) graffitiwalls. Even while still under development, it's loved by quite a number of people. Its github is hosted under the stake-house organization and the tool is baked into the Rocket Pool smartnode software stack.

The main goal of this package is, like all DappNodePackages, to enable the most simple and effortless user experience possible. In order to make this work however, some weird and possibly dodgy looking steps have been necessary. These measures are briefly explained below for transparency reasons, so that even non-technical people who don't want to read all the code can believe in our good intent.

This package is currently configured for mainnet. Support for other networks isn't too much work and can be added if demanded. A released package can be found at `/ipfs/QmNNEUJD8wpLtCMX8JGkGFHg4H7t9sC7BPL9PEPGkheLn6`. An analogous package for gnosis beacon chain is at `/ipfs/QmRGcUcdcK64F2o43gsjmRPgkoZZuWmz2aq7fAhEHC3WoT`.


## Details
After downloading the target image initially the software works by periodically updating the graffiti to a random pixel which hasn't been drawn yet. All four consensus clients support changing the graffiti string during runtime.

Nimbus offers a dedicated REST API endpoint for this purpose. Since all DAppNodePackages share the same network, we can simply access the nimbus docker container via the docker network and update the graffiti that way. Easy.

Prysm, Lighthouse and Teku only enable this by taking a file as input, which is reloaded on each block proposal. So now we need shared file access between docker images. This is an issue, because default DAppNode settings don't allow this (which generally is a good idea, of course).
One way would be to publish a custom Prysm, Lighthouse and Teku Package which include the drawer. That needs to be done per network though, so for mainnet, gnosis and prater that's 9 packages which also need to be updated individually.
Another way is to circumvent the forbidden shared file access in this case. Usually we don't want to do this, but after carefully evaluating that it's done responsibly, this might be an option for some users. It's very simple for the user: We only have one Package for all client/network combinations, which can be updated independently of clients. This is what's been done; Below I'll explain how:
1. Mount the beacon data into our docker. We don't know which client/network the user is running, so we're just mounting the root of all volumes `/var/lib/docker/volumes:/volumes` in `docker-compose.yml` for now. That's arguably overkill and I've plans to change that next, but as a poc it works. Mounting the correct volume is not trivial because there's no optional volumes and we can't evaluate user settings within the docker-compose file. So I thought about a preprocessing step which runs before the actual program is started. It can evaluate user settings/global env variables and rewrite it's own docker-compose to mount only the correct volume on the next start. However there's no point in putting in too much work if noone is willing to try this anyways..
2. DAppNodeSDK refuses to build this with `[...] is a bind-mount, only named non-external volumes are allowed`. So download the SDK and comment out this (and the other) checks for allowed docker volume names. The DAppNodeManager ui will also prevent installing it unless the user enables the bypass checks when installing the package.

Also note: For lighthouse these changes need to be applied on the validator; However its container doesn't mount any volume, so we can't enable the drawer for lighthouse currently. Would need to publish a custom image I guess.


### Disclaimer
We don't take any responsibility for any harm caused.
