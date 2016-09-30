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
clone this repo and copy config files


    git clone https://github.com/timwaizenegger/mcm-deployEnvironment.git
    cp mcm-deployEnvironment/linux-conf/.* .

install packages

    sudo apt update
    sudo apt dist-upgrade
    sudo apt install npm nodejs-legacy screen python3-pip git daemontools
    pip3 install virtualenv
    
start a screen instance and open windows for: SDOS, bluebox, node-red
### SDOS-screen:

    cd
    git clone https://github.com/timwaizenegger/mcm-sdos.git
    cd mcm-sdos/
    
follow setup instructions from SDOS-docs:

    virtualenv venvSDOS
    . setenv.sh
    pip install -r requirements.txt
    
modify the config file; set the swift auth/storage URL to the address of your swift endpoint

    cp mcm/sdos/configuration.example.py mcm/sdos/configuration.py
    vim mcm/sdos/configuration.py
    
done! start the SDOS service

    python runService_Development.py
    
    
### Bluebox-screen
switch to the Bluebox screen

    cd
    git clone https://github.com/timwaizenegger/mcm-bluebox.git
    cd mcm-bluebox/
    
follow setup instructions from Bluebox-docs:

    virtualenv venvBB
    . setenv.sh
    pip install -r requirements.txt
    
modify the config file; set the swift URLs. 
 if you connect through SDOS and it runs locally with defaults, just set "localhost:3000"
 if you want to use nodeRed for the analytics component; set the URL here. A default local setu as explained later will have the URL: localhost:1880


    cp mcm/Bluebox/appConfig.example.py mcm/Bluebox/appConfig.py
    vim mcm/Bluebox/appConfig.py

done! you can start the Bluebox service in dev or production mode:

* for local development/testing: `python runApp_Development.py`
* for production: `./runApp_Production.sh`


### Nodered-screen
switch to the Nodered screen

    cd
    npm install node-red-node-sqlite node-red-nodes-cf-sqldb-dashdb node-red
    
we use the daemontools "supervise" command to run node-red. Node-red seems very unstable so supervise will keep it running.

    supervise mcm-deployEnvironment/nodered-runner/