# mcm-deployEnvironment
deploy and setup all the MCM/SDOS components to get a working system


### The other parts of the MCM project are
* [-- Deploy Environment (set up everything) --](https://github.com/timwaizenegger/mcm-deployEnvironment)
* [Bluebox web-UI](https://github.com/timwaizenegger/mcm-bluebox)
* [SDOS (Secure Delete Object Store) Cryptographic Deletion](https://github.com/timwaizenegger/mcm-sdos)
* [Metadata Extractor](https://github.com/timwaizenegger/mcm-metadataExtractor)
* [Retention Manager](https://github.com/timwaizenegger/mcm-retentionManager)



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



## Kafka broker
we use a kafka broker for communication between the components.
Any existing broker can be used, the connection just has to be configured in the
components' config files. For dev we use a local kafka in docker:

    git clone https://github.com/timwaizenegger/docker-kafka.git
    cd docker-kafka/
    docker build . 
    docker run -p 2181:2181 -p 9092:9092 --env ADVERTISED_HOST="192.168.209.208" --env ADVERTISED_PORT=9092 <ID>
    
     




# Automated deployment

1. install an ubuntu VM; 14.04 and 16.04 were tested
2. clone this repo: `git clone https://github.com/timwaizenegger/mcm-deployEnvironment.git`
3. run the script: `bash mcm-deployEnvironment/deployMCM.sh`
4. start a screen session `screen` and start the 3 services (details below in the "manual" section)



# Manual deploy procedure / dev setup
install an ubuntu VM; 14.04 and 16.04 were tested
clone this repo and copy config files


    git clone https://github.com/timwaizenegger/mcm-deployEnvironment.git
    cp mcm-deployEnvironment/linux-conf/.* .

install packages

    sudo apt update
    sudo apt dist-upgrade
    sudo apt install npm nodejs-legacy screen python3-pip git daemontools
    pip3 install virtualenv
    npm install yarn
    
We use GNU-screen for running the different services on a dev-VM. You can run them any other way you like as well. Some info on how screen is used here:

screen is a window-manager for the shell; it manages multiple shell-windows and keeps running after you disconnect from ssh/tty.

* we provide a screenrc config file; it shows a window-list with some predefined names. These shells are the same; they just have labels.
* on the first start, run `screen` to start a session; all predefined windows will open.
* leave screen via `Ctrl + a, d` (press Ctrl & a at the same time, then press d). Now you can disconnect ssh
* re-enter your session later via `screen -r`. Make sure you only have one session running; otherwise you might have multiple instances of services running without knowing.
* switch between the windows in screen via `Ctrl + a, <space>` go to a specific windows (e.g. 0) via `Ctrl + a, 0`
* create a new window: `Ctrl + a, c`
* close a window: just `exit` the shell in that window
 
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
    cd mcm/Bluebox/angular
    yarn install
    cd ../../../
    
modify the config file; set the swift URLs. 
 if you connect through SDOS and it runs locally with defaults, just set "localhost:3000"
 if you want to use nodeRed for the analytics component; set the URL here. 
 A default setup as explained later will have port 1880. You need to provide the URL that the machine has from the outside; i.e. what the user will see


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

    supervise mcm-deployEnvironment/nodered-runner
    
we have an example flows-file for nodered that shows some possible analyses in this repo. To use, simply replace the default flows-file in ".node-red/" with the example.