# sncr
a synchronization shell script

*sncr* is a wrapper script around rsync that uses rsync to retrieve content from a remote server.
    
 You set up an rsync daemon on a server on the same network, configure sncr to listen to a particular 
directory on that server, and any and all changes you later make to the content inside that server directory 
will be updated in the local directory.
     
 Sncr can be installed on multiple clients that listen to the same server.
     
 Keep in mind, this tool will keep a specified local directory up to date with a remote directory, and not 
vice-versa.

 Practical use cases include:
 
          Updating configurations on multiple machines at once.
          Broadcasting information to a network of clients.
          Back-ups of the server data across one or more machines.
          
     
 
Setting up the rsync daemon:
-
 This setup needs to be done on the server machine that will be broadcasting the data,
 this is what sncr will communicate with.
 Here's the [guide](https://www.atlantic.net/vps-hosting/how-to-setup-rsync-daemon-linux-server/#gsc.tab=0) that we used     
    

Installing sncr:
-
     1. Open up a terminal 
     2. Run the following commands:
        git clone https://github.com/semiismaili/sncr.git
        cd sncr
        ./sncr.sh -install
Usage:
-
    sncr (Will run the sync with the provided configuration, 
          if no config is provided it will prompt you for the inital configuration.)
    
    sncr -config (Will bring the configuration prompt where you can change parameters)
    
        Changeable parameters:
        server address (ex. 192.168.X.X)
        server username (the host machine username)
        how often the sync happens (in seconds, 0 for no automatic syncing)
        local directorium (where the files will be synced into, 
        requires absoulute path, default is $HOME/sncr_files)
        
    sncr -log (outputs the content of the last logfile)
    sncr -log -n <number> (outputs only the last <number> lines of the last logfile)
    
    sncr -last (outputs when the last successfull sync happened)
    ./sncr.sh -install (moves the sncr script to /usr/bin and deletes the sncr folder cloned from git)
    sncr -update (updates /usr/bin/sncr to the latest version from git)
    sncr -help (outputs this usage screen)
