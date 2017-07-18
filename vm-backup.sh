#/bin/bash

# Settings
BACKUP_USING_NAMES=1
MAX_WAIT_TIME=100
BACKUPROOT="/mnt/vmbackup/"

ROTATION=`cat /root/rotation.txt`

ROTATION=$((ROTATION + 1))
if [ $ROTATION -gt 3 ]; then
        ROTATION=1
fi

echo "$ROTATION" > /root/rotation.txt

#mount volume

### MOUNT COMMANDS HERE

if mountpoint -q $BACKUPROOT; then
        for UUID in `xe vm-list is-control-domain=false is-a-template=false | grep uuid | cut -d ":" -f 2 | cut -c 2- $1`;
        do
                if [ $BACKUP_USING_NAMES == 1 ]
                then
                        NAME=`xe vm-param-get param-name=name-label uuid=$UUID`
                else
                        NAME=$UUID
                fi
                echo "Snapshotting $NAME..."
                SNAPSHOT=`xe vm-snapshot vm=$UUID new-name-label=$NAME`

                echo "Rotating backups..."
                rm $BACKUPROOT$NAME$ROTATION.xva

                date

                echo "Exporting snapshot to $NAME$ROTATION.xva..."

                SNAPSHOT_TEMPLATE=`xe template-param-set is-a-template=false uuid=$SNAPSHOT`
                snapshot_export=`xe vm-export vm=$SNAPSHOT filename="$BACKUPROOT$NAME$ROTATION.xva" compress=true`
                snapshot_delete=`xe vm-uninstall uuid=$SNAPSHOT force=true`

                echo "Completed $NAME backup."
                date
                echo "---"
        done

        umount $BACKUPROOT
else
        echo "MEDIA NOT READY, EXITING"
        exit
fi
