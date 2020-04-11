#!/bin/bash

torrentid=$1
torrentname=$2
torrentpath=$3
x=1
ddport=13206 #delude的端口

while [ $x -le 100000 ]
do
sleep 2

echo "Running $x times" >> ~/script.log
echo "TorrentID: $torrentid" >> ~/script.log
line=$(deluge-console "connect 127.0.0.1:$ddport; info" $1 | grep "Tracker status")
echo $line >> ~/script.log
case "$line" in
*unregistered*|*End*of*file*|*Bad*Gateway*|*error*|*Error*|*Sent*)
deluge-console "connect 127.0.0.1:$ddport; pause '$torrentid'"
sleep 2
deluge-console "connect 127.0.0.1:$ddport; resume '$torrentid'"
;;
*)
echo "Found working torrent: $torrentname $torrentpath $torrentid" >> ~/script.log
exit 1;;
esac
x=$(( $x + 1 ))
done
