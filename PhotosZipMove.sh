#!/bin/bash

#!/bin/bash

#### Zip up the photos app and move it to /Library/applicationsRemoved
#### Then delete the photos app.
#### Will Pierce
#### April 27, 2015

# What directory are we in?


# Zip op Photos.app
zip -r Photos.zip /Applications/Photos.app
# Now move it to /Library/applicationsRemoved
mv /Applications/Photos.zip /Library/applicationsRemoved


exit 0