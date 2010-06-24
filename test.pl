#!/usr/local/bin/perl

use Time::Business;


my $bustime = Time::Business->new({
	STARTTIME=>"9:00",
	ENDTIME=>"17:00",
	WORKDAYS=>[1,2,3,4,5]
});

	my $seconds = $bustime->duration(time(),time()+(8*3600+12*60+33));
	print $bustime->workTimeString($seconds) . "\n";
