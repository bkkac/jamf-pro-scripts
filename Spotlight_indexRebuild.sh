#!/bin/bash	

# Erase and rebuild the Spotlight index.
# Will Pierce
# May 11, 2015

# erase the Spotlight index
 mdutil -E /

 # turn Spotlight indexing off
 mdutil -i off /

 # turn Spotlight indexing back on
 mdutil -i on /

 exit 0