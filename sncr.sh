#!/bin/bash

##################################### USAGE #####################################
usage="Usage
    sncr (Will run the sync with the provided configuration, if no config is provided it will prompt you for the inital configuration.)
    sncr -config (Will bring the configuration prompt where you can change parameters)
        >Changeable parameters:
        >server address (ex. 192.168.X.X)
        >server username (the host machine username)
        how often the sync happens (in minutes, 0 for no automaatic syncing)
        local directorium (where the files will be synced into, requires absoulute path, default is $HOME/sncr_files)
        
    sncr -log (outputs the content of the last logfile)
    sncr -log -n <number> (outpots only the last <number> lines of the last logfile)
    
    sncr -last (outputs when the last successfull sync happened)
    
    sncr -help (outputs this usage screen)" 
##################################################################################
hiddenfolder=$HOME/.sncr
config () {
    read -p "Server IP or DNS: " serverip
    while [ -z "${serverip}" ]
    do
        echo "You must provide a server IP, please try again!"
        read -p "Server IP or DNS: " serverip
    done
    read -p "Server user: " serverusername
    while [ -z "${serverusername}" ]
    do
        echo "You must provide a server name, please try again!"
        read -p "Server user: " serverusername
    done
    read -p "Sync frequency [in minutes , default (0) means no automatic sync]: " minutes
    read -p "Path to local directory where the content is to be copied (default is $HOME/sncr_files): " local_dir
    mkdir -p $hiddenfolder
    touch $hiddenfolder/sncr.conf
    if [ -z "${local_dir}" ] 
    then
        local_dir=$HOME/sncr_files
    fi
    if [ ! -d "${local_dir}" ] 
    then
        mkdir $local_dir
    fi
    logdir=$hiddenfolder/rsynclogs 
    if [ ! -d "${logdir}" ] #if logdir already created dont create again
    then
        mkdir $logdir
    fi
    if [ -z "${minutes}" ] 
    then
        minutes=0
    fi
    echo "SERVER_IP=$serverip" > $hiddenfolder/sncr.conf
    echo "SERVER_USERNAME=$serverusername" >> $hiddenfolder/sncr.conf
    echo "SYNC_MINUTES=$minutes" >> $hiddenfolder/sncr.conf
    echo "LOCAL_DIR=$local_dir" >> $hiddenfolder/sncr.conf
    echo "New configuration saved!"
}
if [ "$1" = "-config" ]
then
    config
    exit 1
elif [ "$1" = "-log" ]
then
    last_modified_file=`find $hiddenfolder/rsynclogs/ -type f -printf "%T@\0%p\0" | awk '
    {
        if ($0>max) {
            max=$0; 
            getline mostrecent
        } else 
            getline
    } 
    END{print mostrecent}' RS='\0'`
    if [ "$2" = "-n" ]
    then
        regex='^[0-9]+$' #is a number regex
        if [[ "$3" =~ $regex ]]
        then
            tail $last_modified_file -n $3
        else
            echo "sncr: Invalid usage, argument after -n shoud be an number, run -h!"
        fi
    elif [ "$2" = "-last" ]
    then
        cat $hiddenfolder/last_sync_success.log
    else
        cat $last_modified_file
    fi
elif [ "$1" = "-last" ]
    then
        cat $hiddenfolder/last_sync_success.log
elif [ "$1" = "-h" ]
    then
        echo $usage               
elif [ $# -eq 0 ] 
    then #actual work
    if [ ! -f $hiddenfolder/sncr.conf ] || [ ! -s $hiddenfolder/sncr.conf ] #if conf file doesnt exist or is empty
    then
        config
    fi
    . $hiddenfolder/sncr.conf
    address="$SERVER_USERNAME@$SERVER_IP"
    minutes=$SYNC_MINUTES
    local_dir=$LOCAL_DIR
    while true
    do
        rsync -avzP --log-file=$hiddenfolder/rsynclogs/rsync-backup-log-$(date +"%Y-%m-%d").log --delete rsync://$address:12000/files $local_dir 
        if [ "$?" -eq "0" ]
        then
            echo 'Last successfull sync on' $(date) > $hiddenfolder/last_sync_success.log
        fi
        if [[ $minutes -eq 0 ]]
        then
            break
        fi
        #sleep $minutes
    done
    #TODO bashrc
else
       echo "sncr: Invalid usage, run -h for usage info!"
fi