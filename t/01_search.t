#!/usr/bin/env perl
#

use strict;
use warnings;

use Test::More;
use Data::Dumper;
use Notepad::Search;

my $s_default = Notepad::Search->new();
isa_ok( $s_default, 'Notepad::Search' );
is($s_default->path, $ENV{'HOME'} . '/Notes', 'default path set properly at init');

my $search = Notepad::Search->new(path => 't/test.d');
isa_ok( $search, 'Notepad::Search' );
is($search->path, 't/test.d', 'path set properly at init');

# This should return exactly one file entry named '01_unique_for_one_file'
my $ret = $search->get( { pattern => 'unique for one file', type => 'data' } );
is(scalar @{ $ret }, 1, '01_unique returned just one record') or diag "Got: " . Dumper($ret);
is($ret->[0]->{file}, 't/test.d/01_unique_for_one_file.txt', 'single file name');

# This should return three files with the text '7e3d6dc5f67895e5e2df'
$ret = $search->get( { pattern => '7e3d6dc5f67895e5e2df', type => 'data' } );
is(scalar @{ $ret }, 3, "check rec cnt for '7e3d6dc5f67895e5e2df'");
is($ret->[0]->{file}, 't/test.d/04_test_hex_1.txt', '7e3d... 1');
is($ret->[1]->{file}, 't/test.d/04_test_hex_2.txt', '7e3d... 2');
is($ret->[2]->{file}, 't/test.d/04_test_hex_3.txt', '7e3d... 3');

# This should return just one file
$ret = $search->get( { pattern => '01_unique_for_one', type => 'file' } );
is(scalar @{ $ret }, 1, 'type=file, 01_unique returned just one record') or diag "Got: " . Dumper($ret);
is($ret->[0]->{file}, 't/test.d/01_unique_for_one_file.txt', 'type=file, single file name');

# This should return three files with the names 04_test_hex*
$ret = $search->get( { pattern => '04_test_hex', type => 'file' } );
is(scalar @{ $ret }, 3, "check rec cnt for '04_test_hex'");
is($ret->[0]->{file}, 't/test.d/04_test_hex_1.txt', '04_test_hex... 1');
is($ret->[1]->{file}, 't/test.d/04_test_hex_2.txt', '04_test_hex... 2');
is($ret->[2]->{file}, 't/test.d/04_test_hex_3.txt', '04_test_hex... 3');


done_testing;
