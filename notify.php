<?php
include('config.php');

$min=array("00","15","30","45");

if(!trim($argv[2]) == 'running' && !in_array(date("i"),$min))
	exit;
include('GoogleVoice.php');

// NOTE: Full email address required.
$gv = new GoogleVoice($email,$password);

// Send an SMS to a phone number.
$message = ((trim($argv[2]) == 'running') ? 'Run time exceeded 8 hours' : 'Voltage changed from ' . trim($argv[1]) . ' to ' . trim($argv[2]));
$gv->sendSMS($phone, $message);

?>
