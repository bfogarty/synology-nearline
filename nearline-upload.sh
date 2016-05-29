#!/usr/bin/env bash

source="${1%/}"
destination="${2%/}"

date +"[%D %T] Checking to see if Hyper Backup is idle..."

until cat $source/last_status.conf | grep -q action=\"idle\"
do
  date +"[%D %T] Hyper Backup is not idle, waiting..."
  sleep 60
done

date +"[%D %T] Hyper Backup is idle, beginning sync..."
BOTO_CONFIG=$NEARLINE_HOME/.boto $NEARLINE_HOME/gsutil -m rsync -r -d $source $destination
date +"[%D %T] Sync completed successfully."
