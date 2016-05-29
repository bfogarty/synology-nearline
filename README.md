# synology-nearline
This script syncs a local Hyper Backup destination to Google Cloud Storage Nearline on a Synology running DSM 6.0 or greater.
The script will check to see if Hyper Backup is idle, and if it is, rsync the Hyper Backup destination to Nearline.

# Installation

Create a new share on your Synology to serve as the local Hyper Backup destination. It will also store the Nearline scripts.

SSH into your Synology, run `sudo su -`, and `cd` to your newly created share. Create a new directory named `nearline` and `cd` to it.

Download gsutil:

    curl -O https://storage.googleapis.com/pub/gsutil.tar.gz
    tar xzvf gsutil.tar.gz
    rm gsutil.tar.gz

Configure gsutil:

    gsutil/gsutil config -o .boto

Download synology-nearline:

    curl -O https://raw.githubusercontent.com/bfogarty/synology-nearline/master/nearline-upload.sh
    chmod +x nearline-upload.sh

Using DSM, install Hyper Backup and configure a local backup to a subfolder of the share created earlier.
Then, go to Control Panel > Task Scheduler and click Create > Scheduled Task > User-defined Script.
Ensure the task is set to run as root. Use the following command:

    NEARLINE_HOME=/path/to/nearline bash -c 'flock -n $NEARLINE_HOME/nearline-upload.lockfile -c "$NEARLINE_HOME/nearline-upload.sh /path/to/hyper/backup/destination gs://path/to/nearline/bucket >> $NEARLINE_HOME/nearline-upload.log"'

# Updating

Updating gsutil:

    cd /path/to/nearline/gsutil
    gsutil update
    
Updating synology-nearline:

    cd /path/to/nearline/synology-nearline
    curl https://raw.githubusercontent.com/bfogarty/synology-nearline/master/nearline-upload.sh > nearline-upload.sh
    chmod +x nearline-upload.sh
