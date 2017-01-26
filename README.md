# mcm-deployEnvironment
deploy and setup all the MCM/SDOS components to get a working system


### The other parts of the MCM project are
* [-- Deploy Environment (set up everything) --](https://github.com/timwaizenegger/mcm-deployEnvironment)
* [Bluebox web-UI](https://github.com/timwaizenegger/mcm-bluebox)
* [SDOS (Secure Delete Object Store) Cryptographic Deletion](https://github.com/timwaizenegger/mcm-sdos)
* [Metadata Extractor](https://github.com/timwaizenegger/mcm-metadataExtractor)
* [Retention Manager](https://github.com/timwaizenegger/mcm-retentionManager)



# Automated deployment

1. install an ubuntu VM; 14.04, 16.04, and 16.10 were tested
2. clone this repo: `git clone https://github.com/timwaizenegger/mcm-deployEnvironment.git`
3. run the script: `bash mcm-deployEnvironment/deployMCM.sh`
4. if you run all MCM services on localhost, you just need to set 2 things: swift endpoint in SDOS config and tenant-id in metadata extractor config.
5. start a screen session `screen` and start the services (details below in the "manual" section)


    
We use GNU-screen for running the different services on a dev-VM. You can run them any other way you like as well. Some info on how screen is used here:

screen is a window-manager for the shell; it manages multiple shell-windows and keeps running after you disconnect from ssh/tty.

* we provide a screenrc config file; it shows a window-list with some predefined names. These shells are the same; they just have labels.
* on the first start, run `screen` to start a session; all predefined windows will open.
* leave screen via `Ctrl + a, d` (press Ctrl & a at the same time, then press d). Now you can disconnect ssh
* re-enter your session later via `screen -r`. Make sure you only have one session running; otherwise you might have multiple instances of services running without knowing.
* switch between the windows in screen via `Ctrl + a, <space>` go to a specific windows (e.g. 0) via `Ctrl + a, 0`
* create a new window: `Ctrl + a, c`
* close a window: just `exit` the shell in that window
 
 
 
start a screen instance, the windows for services will open
### SDOS-screen:

    cd mcm-sdos/
    . setenv.sh    
modify the config file; set the swift auth/storage URL to the address of your swift endpoint

    vim mcm/sdos/configuration.py
    
start the SDOS service

    python runService_Development.py
    
    
### Bluebox-screen
switch to the Bluebox screen

    cd mcm-bluebox/
    . setenv.sh

you can start the Bluebox service in dev or production mode:

* for local development/testing: `python runApp_Development.py`
* for production: `./runApp_Production.sh`



### NodeRed-screen (Analytics)
we use the daemontools "supervise" command to run node-red. Node-red seems very unstable so supervise will keep it running.

    supervise mcm-deployEnvironment/nodered-runner

we have an example flows file; to use it, copy it over your local file after first run:
    
    cp mcm-deployEnvironment/nodered-examples/flows_mcm-bluebox.json /home/ubuntu/.node-red/flows_<HOSTNAME>.json


### Docker-screen (postgres, kafka)
run postgres directly from repo:

    docker run --name mcm_warehouse -e POSTGRES_PASSWORD=testing -p 5432:5432 -d postgres

kafka uses a modified image; it was built before

    docker run -p 2181:2181 -p 9092:9092 --env ADVERTISED_HOST="192.168.209.208" --env ADVERTISED_PORT=9092 mcm-kafka







## Swift backend
MCM is based around the Swift object store; or ar least Swift's REST-API. You may use
any storage backend that uses the Swift-API like a Swift-Service or Ceph. For the dev-environment we use
a local single-node Swift setup:

#### Swift all in one setup:
http://docs.openstack.org/developer/swift/development_saio.html

#### SAIO run:

    startmain
    startrest

#### SAIO update:

    cd $HOME/python-swiftclient
    git pull
    sudo python setup.py develop

    cd $HOME/swift
    git pull
    sudo python setup.py develop