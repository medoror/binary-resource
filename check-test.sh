#!/usr/bin/env bash

ruby src/check.rb <<EOF
{
   "source": {
     "repo": "pivotal-cf/om",
     "tag": "4.5.0"
   },
   "version": { "version": "4.5.0" }
 }
EOF

ruby src/check.rb <<EOF
{
   "source": {
     "repo": "pivotal-cf/om",
     "tag": "latest"
   },
   "version": { "version": "4.4.1" }
 }
EOF
