#!/usr/bin/env bash

ruby src/in.rb "tmp/"  <<EOF
{
   "source": {
     "repo": "pivotal-cf/om",
     "tag": "4.5.0"
   },
   "version": { "version": "4.5.0" }
 }
EOF
