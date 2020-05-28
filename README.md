# sncr
a synchronization shell script

*sncr* is a wrapper script around rsync that uses rsync to retrieve content from a remote server

Installation:
-
     1. Open up a terminal 
     2. Run the following commands:
        git clone https://gitlab.com/semiismaili/sncr.git
        cd sncr
        ./sncr -install
Usage:
-
    sncr (Will run the sync with the provided configuration, if no config is provided it will prompt you for the inital configuration.)
    
    sncr -config (Will bring the configuration prompt where you can change parameters)
    
        Changeable parameters:
        server address (ex. 192.168.X.X)
        server username (the host machine username)
        how often the sync happens (in minutes, 0 for no automaatic syncing)
        local directorium (where the files will be synced into, requires absoulute path, default is $HOME/sncr_files)
        
    sncr -log (outputs the content of the last logfile)
    sncr -log -n <number> (outpots only the last <number> lines of the last logfile)
    
    sncr -last (outputs when the last successfull sync happened)
    ./sncr.sh -install (installs sncr by moving the sncr script to /usr/bin and deletes the sncr folder cloned from git)
    sncr -update (updates /usr/bin/sncr to the latest version from git)
    sncr -help (outputs this usage screen)