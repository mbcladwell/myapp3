#! /bin/bash
export LC_ALL="C"
guileexecutable -e '(myapp3)' -s myapp3storepath/share/guile/site/3.0/myapp3.scm $1

