#/bin/bash

#Settings
BACKUP_USING_NAMES=1
MAX_WAIT_TIME=100
BACKUPROOT="/mnt/vmbackup/"

declare -a machine_uuids=("00000000-0000-0000-0000-000000000000"
                          "00000000-0000-0000-0000-000000000000")

#Backup Script
for machine_uuid in "${machine_uuids[@]}"
do
        if [ $BACKUP_USING_NAMES == 1 ]
        then
            NAME=`xe vm-param-get param-name=name-label uuid=$machine_uuid`
        else
            NAME=$machine_uuid
        fi

        echo "Stopping $NAME..."
        xe vm-shutdown uuid=$machine_uuid

        TIMEOUT=0
        STATUS="running"
        while [ $STATUS != "halted" ]; do
            sleep 1
            STATUS=`xe vm-param-get param-name=power-state uuid=$machine_uuid`
            TIMEOUT=$((TIMEOUT+1))
            if [ $TIMEOUT -gt $MAX_WAIT_TIME ] 
            then
                echo "Backup failed!"
                echo "Could not stop VM: $NAME"
                echo "ID: $machine_uuid"
                exit 1
            fi
        done

        echo "Stopped."
        date

        rm $BACKUPROOT$machine.xva.1
        mv $BACKUPROOT$machine.xva.0 $BACKUPROOT$machine.xva.1
        mv $BACKUPROOT$machine.xva $BACKUPROOT$machine.xva.0
        
        xe vm-export vm=$machine filename=$BACKUPROOT$NAME.xva

        echo "Completed backup of $NAME."
        date

        xe vm-start uuid=$machine_uuid
        STATUS="halted"
        TIMEOUT=0
        while [ $STATUS != "running" ]; do
            sleep 1
            STATUS=`xe vm-param-get param-name=power-state uuid=$machine_uuid`
            TIMEOUT=$((TIMEOUT+1))
            if [ $TIMEOUT -gt $MAX_WAIT_TIME ] 
            then
                echo "Backup succeeded!"
                echo "Could not start VM: $NAME"
                echo "ID: $machine_uuid"
            fi
        done
        echo "$NAME started."
done
