#!/usr/local/bin/perl

use Time::Business;


my $bustime = Time::Business->new({
	STARTTIME=>"9:00",
	ENDTIME=>"17:00",
	WORKDAYS=>[1,2,3,4,5]
});

for( $i=1;$i<100000;$i=$i+1) {
	$t = $bustime->duration(time(),time()+(86400)*11-3600*4);
	$h = int($t/(8*3600));
	$r = int($t%(8*3600));
	my ($ssec,$smin,$shour,$smday,$smon,$syear,$swday,$syday,$sisdst) = gmtime($r	);
}
print "$h days $shour hours $smin minutes\n";


