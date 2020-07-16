#!/usr/bin/env bash

DEST_DIR="tmp/"
if [ -d "$DEST_DIR" ]; then
    rm -Rf $DEST_DIR;
    echo "Deleting destination dir..."
fi

ruby src/in.rb "tmp/"  <<JSON
{
   "source": {
     "repo": "pivotal-cf/om",
     "tag": "4.5.0"
   },
   "version": { "version": "4.5.0" }
 }
JSON
