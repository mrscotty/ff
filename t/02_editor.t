#!/usr/bin/env perl
#

use strict;
use warnings;

use Test::More;
use Data::Dumper;
use Notepad::Editor;

sub cat {
    my $file = shift;
    open(FILE, $file) or die "Error opening $file: $!";
    my $data = join('', <FILE>);
    close FILE;
    return $data;
}

my $editor = Notepad::Editor->new();
isa_ok( $editor, 'Notepad::Editor' );
is($editor->editor, 'vi', 'default editor set properly at init');

$editor = Notepad::Editor->new( editor => 't/editor.sh' );
is($editor->editor, 't/editor.sh', 'explicit editor set properly at init');

$ENV{TEST_EDIT} = "The text is caf038cc618a1776c2d2";
my $ret = $editor->run( { file => 't/test.d/caf0.txt' } );
is($ret, 1, 'run editor for caf0 returns true');
is( -f 't/test.d/caf0.txt', 1, 'caf0.txt should have been created');
is(cat('t/test.d/caf0.txt'), $ENV{TEST_EDIT}, 'run editor for caf0 (check content)');

$ENV{TEST_EDIT_CMD} = "die";
$ret = $editor->run( { file => 't/test.d/die.txt' } );
is( $ret, 0, 'run editor for die.txt should fail');
is( -f 't/test.d/die.txt', undef, 'die.txt should not be created');
$ENV{TEST_EDIT_CMD} = undef;

done_testing;

__END__

my $search = Notepad::Editor->new(path => 't/01_search.d');
isa_ok( $search, 'Notepad::Editor' );
is($search->path, 't/01_search.d', 'path set properly at init');

# This should return exactly one file entry named '01_unique_for_one_file'
my $ret = $search->get( { pattern => 'unique for one file' } );
is(scalar @{ $ret }, 1, '01_unique returned just one record') or diag "Got: " . Dumper($ret);
is($ret->[0]->{file}, 't/01_search.d/01_unique_for_one_file.txt', 'single file name');

# This should return three files with the text '7e3d6dc5f67895e5e2df'
$ret = $search->get( { pattern => '7e3d6dc5f67895e5e2df' } );
is(scalar @{ $ret }, 3, "check rec cnt for '7e3d6dc5f67895e5e2df'");
is($ret->[0]->{file}, 't/01_search.d/04_test_hex_1.txt', '7e3d... 1');
is($ret->[1]->{file}, 't/01_search.d/04_test_hex_2.txt', '7e3d... 2');
is($ret->[2]->{file}, 't/01_search.d/04_test_hex_3.txt', '7e3d... 3');


