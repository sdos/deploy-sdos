# mcm-deployEnvironment
deploy and setup all the MCM/SDOS components to get a working system


### The other parts of the MCM project are
* [-- Deploy Environment (set up everything) --](https://github.com/timwaizenegger/mcm-deployEnvironment)
* [Bluebox web-UI](https://github.com/timwaizenegger/mcm-bluebox)
* [SDOS (Secure Delete Object Store) Cryptographic Deletion](https://github.com/timwaizenegger/mcm-sdos)
* [Metadata Extractor](https://github.com/timwaizenegger/mcm-metadataExtractor)
* [Retention Manager](https://github.com/timwaizenegger/mcm-retentionManager)


## Manual deploy procedure / dev setup
install an ubuntu VM; 14.04 and 16.04 were tested
clone this repo

    git clone https://github.com/timwaizenegger/mcm-deployEnvironment.git
copy the config files:
    cp 

    sudo apt update
    sudo apt dist-upgrade
    sudo apt install npm screen python3-pip git
    pip3 install virtualenv
    
start a screen instance and open windows for: SDOS, bluebox, node-red
SDOS-screen:

    cd
    git clone https://github.com/timwaizenegger/mcm-sdos.git
    cd mcm-sdos/
    