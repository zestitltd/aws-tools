#!/bin/bash

DESCRIPTION="Daily_Backup"
TAG=("instance=" "volume=" "type=backup" "period=daily")
SNAPSHOTS_KEEP_FOR_DAYS=7

echo 'Searching for instances'
for INSTANCE in `/var/lib/aws-tools/ec2-describe-instances-for-humans.sh` ; do
  if [[ $INSTANCE =~ ^i-[A-Za-z0-9]+$ ]] ; then
    echo 'Found '$INSTANCE

    echo 'Searching for volumes attached to instance '$INSTANCE
    for VOLUME in `/var/lib/aws-tools/find-vols-attached-to-instance.sh -i $INSTANCE` ; do
      echo 'Found volume '$VOLUME

      ##AWS EC2 Snapshot Backups
      /var/lib/aws-tools/backup-volumes-into-snapshots.sh -s -v $VOLUME -d $DESCRIPTION -t "${TAG[0]}$INSTANCE" -t "${TAG[1]}$VOLUME" -t ${TAG[2]} -t ${TAG[3]}
    done
  else
    echo 'Not an instance: '$INSTANCE
  fi
done

##AWS EC2 Snapshot Backups Cleanup. Delete all snapshots more than a week old with particular tag.
/var/lib/aws-tools/clean-old-snapshots.sh -f tag:${TAG[2]} -d $SNAPSHOTS_KEEP_FOR_DAYS
