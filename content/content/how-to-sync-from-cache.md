---
title: How to sync from cache
---

If you're starting with a blank database, you'll need to run `sync_local_sources` to get all of the missions setup properly.  Here's how to run that initial sync quickly, assuming you're in the root of the `dsserver` repo, and your local `dscontent` is on the latest version of the master branch:

```bash
python manage.py add_local_source ../dscontent --main
docker pull dataquestio/dscontent  # to pull down the latest dscontent Docker container
docker create --name content dataquestio/dscontent  # create a container to enable `docker cp`
mkdir -p media/sync  # the default location for reading dump files
docker cp content:/opt/wwc/mission_data/. media/sync  #copy dump files to dump folder
docker rm content  # remove content container
python manage.py sync_local_sources --read-from-file  # sync files!
rm -rf media/sync # (optional) remove the dump folder to save space
```

This sync should take ~10 minutes to sync everything, and shouldn't hit docker at all.