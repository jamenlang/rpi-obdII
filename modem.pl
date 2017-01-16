use Device::Modem;
use Getopt::Std;
use strict;

# get the command and the port
  getopt('p:c:', my $opts={});
  my $rcom = uc($opts->{'c'} || "ATL1");
  my $racom = uc($opts->{'c'} || "ATH1");
  my $com = uc($opts->{'c'} || "ATRV");
  my $portnr = defined ($opts->{'p'}) ? $opts->{'p'} : ($^O=~/MSWin/) ? "5" : "0";
  my $port  = ($^O=~/MSWin/) ? "COM$portnr" : "/dev/rfcomm$portnr";

# get modem object and connect
  my $modem = new Device::Modem(
    port=>$port,
    log=>"file,log.txt",
    loglevel=>"debug" ,
  );
  $modem->connect(baudrate=>9600);

# send at-command and retrieve the answer
  $modem->atsend( $rcom . "\r\n" );
  $modem->atsend( $racom . "\r\n" );
  $modem->atsend( $com . "\r\n" );
  my $answer = $modem->_answer($Device::Modem::STD_RESPONSE);

  print "\n
------------------------
question: '$com'
------------------------
answer:\n$answer
------------------------
";
