package Time::Business;
use Data::Dumper;
use strict;

BEGIN {
    use Exporter ();
    use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS @starttime @endtime);
    $VERSION     = '0.12';
    @ISA         = qw(Exporter);
    #Give a hoot don't pollute, do not export more than needed by default
    @EXPORT      = qw();
    @EXPORT_OK   = qw();
    %EXPORT_TAGS = ();
}


sub new
{
    my ($class, $parameters) = @_;

    my $self = bless ({}, ref ($class) || $class);
	
	$self->{STARTTIME} = $parameters->{STARTTIME};
	$self->{ENDTIME} = $parameters->{ENDTIME};
	
	foreach my $workday (@{$parameters->{WORKDAYS}}){
		$self->{WORKDAYS}->{$workday}=1;
	}
	
	@starttime = split /:/, $self->{STARTTIME};
	@endtime = split /:/, $self->{ENDTIME}; 
		
	$self->{worksecs} = ($endtime[0] - $starttime[0]) * 3600 + ($endtime[1] - $starttime[1]) * 60;
	$self->{startworkmin} = $starttime[0] * 60 + $starttime[1];
	$self->{endworkmin} = $endtime[0] * 60 + $endtime[1];
	
	
	return $self;
    
}

sub duration {
	
	my $self =shift;
	my($start,$end) = @_;
	
	my $duration = $end - $start;
	
	
	
	my ($ssec,$smin,$shour,$smday,$smon,$syear,$swday,$syday,$sisdst) = localtime($start);
	my ($esec,$emin,$ehour,$emday,$emon,$eyear,$ewday,$eyday,$eisdst) = localtime($end);
	my ($dsec,$dmin,$dhour,$dmday,$dmon,$dyear,$dwday,$dyday,$disdst) = localtime($duration);

	my $daysin;
	my $daysleft;

	

	if($eyday - $syday >= 2) { 
		$daysin = int($dyday / 7) * 5;
		$daysleft = $dyday % 7;
			
		my $startloop = ($swday)%7;
		my $endloop = $startloop + $daysleft - 1;
	
		for (my $i = $startloop;$i<=$endloop;$i++) {
			my $wday = $i%7;
			if(defined $self->{WORKDAYS}->{$wday}) {
				$daysin++;
			}
		}
		
	
		
	} 
	
		
	# Count valid hours in first day
	my $seconds = 0;
	if($duration != ($dyday * 24 * 60 * 60)) {
		
		
		if( defined $self->{WORKDAYS}->{$swday}) {
		
			my $end_seconds = $ehour * 3600 + $emin * 60 + $esec;
			my $end_day = $endtime[0] * 3600 + $endtime[1] * 60;

			
			if(($end_seconds > $end_day) || $eyday - $syday >= 1 ) {

				$end_seconds = $end_day;
			}
			
			
			my $start_seconds = $shour * 3600 + $smin * 60 + $ssec;
			$seconds = $end_seconds - $start_seconds;

		}
			
		# Count valid hours in last day
		if($eyday > $syday && defined $self->{WORKDAYS}->{$ewday}  ) {
	
	
			if($ehour * 60 + $emin >= $self->{startworkmin}) {
	
									
					my $start_seconds = $starttime[0] * 3600 + $starttime[1] * 60;
					my $end_seconds = $ehour * 3600 + $emin * 60 + $esec;
					$seconds = $seconds + ($end_seconds - $start_seconds);
		
			}
		}
	}
	
	
	$seconds = $seconds + $daysin * $self->{worksecs};
	return $seconds;
	
}

sub workTimeString {
	
	my $self = shift;
	my $seconds = shift;
	
	
	
	my $days = int($seconds/$self->{worksecs});
	my $minutes = int($seconds%$self->{worksecs});
	my ($ssec,$smin,$shour,$smday,$smon,$syear,$swday,$syday,$sisdst) = gmtime($minutes);
	return "$days days $shour hours $smin minutes";
}


=head1 NAME

Time::Business - Business Time Between Two Times

=head1 SYNOPSIS

  use Time::Business;
  
  my $btime = Time::Business->new({
  		WORKDAYS=>[1,2,3,4,5],
  		STARTIME=>900,
  		ENDTIME=>1700,
  	})

  $start=time();
  $end=time()+86400;
  $seconds = $btime->calctime($start,$end);

=head1 DESCRIPTION

Calculates the number of business seconds between two dates (specified in 
epoch seconds) given a list of working days and start and end times.

=head1 METHODS

=head2 new({....})

 
Setup a Time::Business object, passing the working time parameters.
eg.

 my $btime = Time::Business->new({
  		WORKDAYS=>[1,2,3,4,5],
  		STARTIME=>'9:00',
  		STOPTIME=>'17:00',
  	})

where WORKDAYS is specified as a list of 0..6 where Sun is 0 and Sat is 6. 


=head2 duration($start,$end) - Return number of business seconds.
  
Returns the number of business seconds between $start and $end (seconds since epoch)
given the parameters specified in the Time::Business->new.   

=head2 workTimeString($seconds) - Convert seconds to human readable work time.

Converts the $seconds given to a string of the form "n days n hours n minutes".
NOTE: This conversion is based on business hours so one day is one working
day, not one 24 hour day. Useful for reports etc. 

=head1 SUPPORT



=head1 AUTHOR

    David Peters
    CPAN ID: DAVIDP
    davidp@electronf.com
    http://www.electronf.com

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.


=head1 SEE ALSO

perl(1).

=cut

#################### main pod documentation end ###################


1;
# The preceding line will help the module return a true value

