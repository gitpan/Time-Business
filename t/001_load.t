# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 2;

BEGIN { use_ok( 'Time::Business' ); }

my $object = Time::Business->new ();
isa_ok ($object, 'Time::Business');


