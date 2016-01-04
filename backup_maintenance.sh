#!/bin/bash

INSTANCE="i-b3abd86c"
#VOLUME="vol-cc990806"
DESCRIPTION="Daily_Backup"
TAG1="vps=main"
TAG2="backup=daily"
TAG3="image=boot"

KEEP_FOR=7

echo 'Searching for volumes attached to instance'$INSTANCE
for VOLUME in `/var/lib/aws-tools/find-vols-attached-to-instance.sh -i $INSTANCE`
do
  echo 'Found volume '$VOLUME
  ##AWS EC2 Backups
  /var/lib/aws-tools/backup-volumes-into-snapshots.sh -s -v $VOLUME -d $DESCRIPTION -t $TAG1 -t $TAG2 -t $TAG3

done

##AWS EC2 Backups Cleanup. Delete all snapshots more than a week old with particular tag.
/var/lib/aws-tools/clean-old-snapshots.sh -f tag:$TAG2 -d $KEEP_FOR
