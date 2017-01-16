# rpi-obdII
modem script and notes for obdII bluetooth dongle.

I wanted to keep track of my battery voltage while I was away and also monitor to see how long my vehicle was running to remind me to refuel.

I had in this directory:

Device-Modem-1.57
Device-SerialPort-1.04
Google-Voice-PHP-API


and in crontab

@reboot exec /usr/bin/perl /home/pi/voltage.pl >> /tmp/mydaemon.log 2>&1 &
