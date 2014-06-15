#!/bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin
cmd=$(which ss)
rrdtool=$(which rrdtool)
db=/opt/rrd/tcp.rrd
img=/usr/share/nginx/html/rrd

if [ ! -e $db ]
then
        $rrdtool create $db \
        -s 300 \
        DS:conns:GAUGE:400:0:50000000000 \
        RRA:AVERAGE:0.5:1:576 \
        RRA:AVERAGE:0.5:6:672 \
        RRA:AVERAGE:0.5:24:732 \
        RRA:AVERAGE:0.5:144:1460
fi

$rrdtool updatev $db -t conns N:`$cmd -s | grep TCP: | cut -d ' ' -f6 | tr -d ','`

for period in hour day week month year
do
        $rrdtool graph $img/connections-$period.png -s -1$period \
        -t "Established TCP connections - $period" -z \
        -c "BACK#FFFFFF" -c "SHADEA#FFFFFF" -c "SHADEB#FFFFFF" \
        -c "MGRID#AAAAAA" -c "GRID#CCCCCC" -c "ARROW#333333" \
        -c "FONT#333333" -c "AXIS#333333" -c "FRAME#333333" \
        -h 134 -w 543 -l 0 -a PNG -v "concurrent connections" \
        DEF:conns=$db:conns:AVERAGE \
        VDEF:min=conns,MINIMUM \
        VDEF:max=conns,MAXIMUM \
        VDEF:avg=conns,AVERAGE \
        VDEF:lst=conns,LAST \
        "COMMENT: \l" \
        "COMMENT:               " \
        "COMMENT:Minimum    " \
        "COMMENT:Maximum    " \
        "COMMENT:Average    " \
        "COMMENT:Current    \l" \
        "COMMENT:   " \
        "LINE1:conns#0AC43C:Conns  " \
        "GPRINT:min:%6.0lf      " \
        "GPRINT:max:%6.0lf      " \
        "GPRINT:avg:%6.0lf      " \
        "GPRINT:lst:%6.0lf      \l" > /dev/null
done
