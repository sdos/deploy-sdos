# mcm-deployEnvironment
deploy and setup all the MCM/SDOS components to get a working system


### The other parts of the MCM project are
* [-- Deploy Environment (set up everything) --](https://github.com/timwaizenegger/mcm-deployEnvironment)
* [Bluebox web-UI](https://github.com/timwaizenegger/mcm-bluebox)
* [SDOS (Secure Delete Object Store) Cryptographic Deletion](https://github.com/timwaizenegger/mcm-sdos)
* [Metadata Extractor](https://github.com/timwaizenegger/mcm-metadataExtractor)
* [Retention Manager](https://github.com/timwaizenegger/mcm-retentionManager)



# Docker compose based all-in-one demo system
* either run `./deployMCM_docker.sh`
* or use `docker-compose`:

install docker/docker compose (if not present)

    git clone https://github.com/timwaizenegger/mcm-deployEnvironment.git
    cd mcm-deployEnvironment
    docker-compose up

    docker-compose exec ceph radosgw-admin subuser create --uid=sdos --subuser=sdos:user --access=full
    docker-compose exec ceph radosgw-admin key create --subuser=sdos:user --key-type=swift --gen-secret

note the swit secret and visit

    http://172.18.0.100:8000

    tenant: sdos
    user: user
    pass: passw0rd




# Automated deployment for Development setup

1. install an ubuntu VM; 14.04, 16.04, and 16.10 were tested
2. clone this repo: `git clone https://github.com/timwaizenegger/mcm-deployEnvironment.git`
3. run the script: `bash mcm-deployEnvironment/deployMCM.sh`
4. if you run all MCM services on localhost, you just need to: 
    - set swift endpoint in SDOS config 
    - set tenant-id in metadata extractor config
    - create initial warehouse db with tenant-id
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

modify the config file; set the swift auth/storage URL to the address of your swift endpoint

    cd mcm-sdos/
    vim mcm/sdos/configuration.py
    
start the SDOS service

    ./run.sh
    
    
### Bluebox-screen

    ./run.sh



### MetadataExtractor-screen

set tenant-id in metadata extractor config

start the service

    ./run.sh


### NodeRed-screen (Analytics)
we use the daemontools "supervise" command to run node-red. Node-red seems very unstable so supervise will keep it running.

    cd mcm-deployEnvironment/nodered-runner
    supervise .

we have an example flows file; to use it, copy it over your local file after first run:
    
    cp /home/ubuntu/mcm-deployEnvironment/nodered-examples/flows_mcm-bluebox.json /home/ubuntu/.node-red/flows_<HOSTNAME>.json


### Docker-screen (postgres, kafka)
docker containers for kafka and postgres were already started. re-start them later with:

    docker start mcm_warehouse
    docker start mcm_kafka

get an interactive postgres shell. Use this to create the initial database for your tenant-id

    docker run -it --rm --link mcm_warehouse:postgres postgres psql -h postgres -U postgres
    create database mcm-metadata_<TENANTID>;






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

