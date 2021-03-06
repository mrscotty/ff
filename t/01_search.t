#!/usr/bin/env perl
#

use strict;
use warnings;

use Test::More;
use Data::Dumper;
use FF::Search;

my $s_default = FF::Search->new();
isa_ok( $s_default, 'FF::Search' );
is($s_default->path, $ENV{'HOME'} . '/Notes', 'default path set properly at init');

my $search = FF::Search->new(path => 't/test.d');
isa_ok( $search, 'FF::Search' );
is($search->path, 't/test.d', 'path set properly at init');

# This should return exactly one file entry named '01_unique_for_one_file'
my $ret = $search->get( { pattern => 'unique for one file' } );
is(scalar @{ $ret }, 1, '01_unique returned just one record') or diag "Got: " . Dumper($ret);
is($ret->[0]->{file}, 't/test.d/01_unique_for_one_file.txt', 'single file name');

# This should return three files with the text '7e3d6dc5f67895e5e2df'
$ret = $search->get( { pattern => '7e3d6dc5f67895e5e2df' } );
is(scalar @{ $ret }, 3, "check rec cnt for '7e3d6dc5f67895e5e2df'");
is($ret->[0]->{file}, 't/test.d/04_test_hex_1.txt', '7e3d... 1');
is($ret->[1]->{file}, 't/test.d/04_test_hex_2.txt', '7e3d... 2');
is($ret->[2]->{file}, 't/test.d/04_test_hex_3.txt', '7e3d... 3');


done_testing;
