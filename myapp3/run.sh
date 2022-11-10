#! /bin/bash
## export GUILE_LOAD_PATH="/home/mbc/projects/myapp2${GUILE_LOAD_PATH:+:}$GUILE_LOAD_PATH"
## export GUILE_LOAD_PATH="/home/mbc/projects/myapp2${GUILE_LOAD_PATH:+:}$GUILE_LOAD_PATH"
guile -e '(myapp pages)' -s /home/mbc/projects/myapp2/myapp/pages.scm 
