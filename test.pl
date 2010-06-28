#!/usr/local/bin/perl

use Time::Business;


my $bustime = Time::Business->new({
	STARTTIME=>"9:00",
	ENDTIME=>"17:00",
	WORKDAYS=>[1,2,3,4,5]
});
	

for(my $days=0;$days<=16;$days++) {

	my $end = time()+86400*$days + 3700;
	print scalar localtime($end) . "\n";
	my $seconds = $bustime->duration(time(),$end);
	print $bustime->workTimeString($seconds) . "\n";
}
