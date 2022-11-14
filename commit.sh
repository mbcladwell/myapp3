#! /bin/bash

git commit -a -S -m "autocommit"
git push

     
COMMITID=$(git log -1 --pretty=format:"%H")
sed -i "s/[ ]*(commit \"[a-z0-9]*\")))/             (commit \"$COMMITID\")))/" ./guix.scm

COMMITHASH=$(guix hash -x --serializer=nar ./myapp3)
sed -i "s/[ ]*(base32 \"[a-z0-9]*\"))))/             (base32 \"$COMMITHASH\"))))/" ./guix.scm
