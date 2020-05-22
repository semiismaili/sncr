#!/bin/bash
hiddenfolder=$HOME/.serget
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
    read -p "Path to local directory where the content is to be copied (default is $HOME/serget_files): " local_dir
    mkdir -p $hiddenfolder
    touch $hiddenfolder/serget.conf
    if [ -z "${local_dir}" ] 
    then
        local_dir=$HOME/serget_files
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
    echo "SERVER_IP=$serverip" > $hiddenfolder/serget.conf
    echo "SERVER_USERNAME=$serverusername" >> $hiddenfolder/serget.conf
    echo "SYNC_MINUTES=$minutes" >> $hiddenfolder/serget.conf
    echo "LOCAL_DIR=$local_dir" >> $hiddenfolder/serget.conf
    echo "New configuration saved!"
}
if [ "$1" = "-config" ]
then
    config
    exit 1
elif [ $# -eq 0 ] 
    then #actual work
    if [ ! -f $hiddenfolder/serget.conf ] || [ ! -s $hiddenfolder/serget.conf ] #if conf file doesnt exist or is empty
    then
        config
    fi
    . $hiddenfolder/serget.conf
    address="$SERVER_USERNAME@$SERVER_IP"
    minutes=$SYNC_MINUTES
    local_dir=$LOCAL_DIR
    while true
    do
        rsync -avzP --log-file=$hiddenfolder/rsynclogs/rsync-backup-log-$(date +"%Y-%m-%d").log --delete rsync://$address:12000/files $local_dir
        if [[ $minutes -eq 0 ]]
        then
            break
        fi
        #sleep $minutes
    done
    #TODO make config file so koj server, koja datoteka, i last synced etc (-p bar)
    #TODO bashrc
fi