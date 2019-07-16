#!/usr/bin/python
import fnmatch
import os

images = ['*.jpg', '*.jpeg', '*.png', '*.tif', '*.tiff']
matches = []
dir = "/Users/pierce"
for root, dirnames, filenames in os.walk("/Volumes/Macintosh\ HD/Users/pierce"):
    for extensions in images:
        for filename in fnmatch.filter(filenames, extensions):
            matches.append(os.path.join(root, filename))
for items in images:
    print (items)

for items in matches:
    print (items)