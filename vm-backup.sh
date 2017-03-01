#/bin/bash

#Settings
BACKUP_USING_NAMES=1
MAX_WAIT_TIME=100
BACKUPROOT="/mnt/vmbackup/"

declare -a machine_uuids=("00000000-0000-0000-0000-000000000000"
                          "00000000-0000-0000-0000-000000000000")

for MACHINE_UUID in "${MACHINE_UUIDS[@]}"
do
	if [ $BACKUP_USING_NAMES == 1 ]
	then
		NAME=`xe vm-param-get param-name=name-label uuid=$MACHINE_UUID`
	else
		NAME=$MACHINE_UUID
	fi
	echo "Snapshotting $NAME..."
	SNAPSHOT=`xe vm-snapshot vm=$MACHINE_UUID new-name-label=backup`

	echo "Rotating backups..."
	rm $BACKUPROOT$NAME.xva.1 
	mv $BACKUPROOT$NAME.xva.0 $BACKUPROOT$NAME.xva.1
	mv $BACKUPROOT$NAME.xva $BACKUPROOT$NAME.xva.0

	echo "Exporting snapshot of $NAME..."
	SNAPSHOT_TEMPLATE=`xe template-param-set is-a-template=false uuid=$SNAPSHOT`
        snapshot_export=`xe vm-export vm=$SNAPSHOT filename="$BACKUPROOT$NAME.xva"`
        snapshot_delete=`xe vm-uninstall uuid=$SNAPSHOT force=true`

        echo "Completed $NAME backup."
	echo "---"
done

