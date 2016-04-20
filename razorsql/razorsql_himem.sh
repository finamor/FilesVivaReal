#!/bin/sh
CWD=$(dirname "$0")
CMD="$CWD/razorsql.jar"
$CWD/jre/bin/java -Xms256M -Xmx1024M -client -jar ${CMD}
RC=$?
if [ ${RC} != 0 ]; then
        echo "Error returned code found. Retrying . . ."
        $CWD/jre/bin/java -Xms256M -Xmx1024M -client -jar ${CMD}
        RC2=$?
        if [ ${RC2} != 0 ]; then
                echo "Trying local JRE . . ."
                java -Xms256M -Xmx1024M -client -jar ${CMD}
        fi
fi