# Setup

Create two folders used for building the pentaho image:
```bash
mkdir pentaho/inputs
mkdir pentaho/install
```

You need to download the pentaho PDI zip from here:
http://downloads.sourceforge.net/project/pentaho/Data%20Integration/client-tools

Place it in the `pentaho/install` folder.  It is in `.gitignore` to prevent adding the massive (1.5 GB) file to git.

# Build Pentaho

First we must build the pentaho base image.  We will mount volumes to run individual tests.

```bash
cd pentaho
./build-pentaho.sh
```

# Run pentaho

First, stand up the database and apply the migrations:
```bash
./docker-up.sh
```

Place any **input** files in the `docker/pentaho/inputs` folder.  This will be mounted to the image automatically. 

We can now run pentaho for a particular job using `test.sh` or `test-win.sh`.
```bash
cd pentaho
./
```
