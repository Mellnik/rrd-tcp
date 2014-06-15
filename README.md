rrd-tcp
=======

This script monitors established TCP connections from your Linux machine. The output is gathered from ``ss -s``.

# Installation
- Upload the file to your Linux machine
- Change variable ``db`` and ``img`` according to your setting
- Add a new cronjob with internal of 5 minutes
- Last but not least make sure the file has the right permissions

# Example

![connections](http://ams1.boostlayer.net/awp/connections-day.png "ams1.boostlayer.net connections")
