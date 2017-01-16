#!/usr/bin/perl -w
# cross-platform example5

use strict;
use vars qw( $OS_win $ob $port );

BEGIN {
        $OS_win = ($^O eq "MSWin32") ? 1 : 0;
        if ($OS_win) {
            eval "use Win32::SerialPort 0.11";
	    die "$@\n" if ($@);
        }
        else {
            eval "use Device::SerialPort";
	    die "$@\n" if ($@);
        }
} # End BEGIN

while (1){
     sleep 60;

     if ($OS_win) {
         $ob = Win32::SerialPort->start ($port);
     }
     else {
         $port = '/dev/rfcomm0';
         $ob = Device::SerialPort->new ($port);
     }
     if ($ob){
         last;
     }
}

die "Can't open serial port $port: $^E\n" unless ($ob);

$ob->user_msg(1);       # misc. warnings
$ob->error_msg(1);      # hardware and data errors

$ob->baudrate(38400);
$ob->parity("none");
## $ob->parity_enable(1);   # for any parity except "none"
$ob->databits(8);
$ob->stopbits(1);
$ob->handshake('rts');

$ob->write("ATL1\r");
$ob->write("ATH0\r");
$ob->write("ATS0\r");
sleep 1;
my $result = $ob->input;
my @arr;
my $new = 0;
my $old = 0;
my $newmovedp = 0;
my $oldmovedp = 0;
my $running = 0;
my @args;

while (1){
     $ob->write("ATRV\r");
     sleep 2;
     $result = $ob->input;

     @arr = split(/\r/,$result);
     $new = $arr[1];
     $newmovedp = sprintf("%.1g", $new)

     if($oldmovedp gt $newmovedp){
          #bark about it.
          @args = ("php", "/home/pi/notify.php", $old, $new);
          system(@args);
     }
     if($newmovedp gt 140){
          #keep track of it.
          $running += 1;
          #if it's been running for more than 8 hours let me know so i can refuel
          if($running gt 480){
               @args = ("php", "/home/pi/notify.php", $running, 'running');
               system(@args);
               $running = 0;
          }
     }
     $old = $new;
     $oldmovedp = sprintf("%.1g", $old);
     sleep 60;
}
undef $ob;


# equal(NUM1, NUM2, PRECISION) : returns true if NUM1 and NUM2 are
# equal to PRECISION number of decimal places
sub equal {
    my ($A, $B, $dp) = @_;
    return sprintf("%.1g", $A) eq sprintf("%.${dp}g", $B);
  }
