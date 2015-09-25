package Notepad::Search;

use Moose;
use File::Find;

has 'path' => (
    is      => 'rw',
    default => $ENV{HOME} . '/Notes',
);

sub get {
    my $self    = shift;
    my $args    = shift;
    my $results = [];

    my $path    = $self->path();
    my $pattern = $args->{pattern};

    my $pathlen = length($path);

    if ( not defined $pattern ) {
        $pattern = '';
    }

    # this is dirty... very dirty...
    # but it takes care of matches in both filename and contents

    find(
        sub {
            # Skip dirs, symlinks and dot-files
            if ( $_ =~ m{^\.} ) {

                #warn "# skipping dot-file '$_'";
                return;
            }
            if ( not -f $_ ) {

                #warn "# dir = ", `pwd`;
                #warn "# skipping non-file '$File::Find::name'";
                return;
            }

            # match filename
            if ( $_ =~ m{$pattern}i ) {

                #warn "# grep: '$_' matches pattern '$pattern'";
                push @{$results},
                    {
                    file => $File::Find::name,
                    line => substr( $File::Find::name, $pathlen )
                    };
            }
            else {
                if ( not open( FILE, $_ ) ) {
                    warn "Error opening $File::Find::name: $!\n";
                    return;
                }
                while ( my $line = <FILE> ) {

                    #warn "# Checking line '$line' for pattern '$pattern'";
                    if ( $line =~ m{$pattern}i ) {

                        #warn "# MATCH line '$line' for pattern '$pattern'";
                        push @{$results},
                            {
                            file => $File::Find::name,
                            line => substr( $File::Find::name, $pathlen )
                            };
                        last;
                    }
                }
                close FILE;
            }
        },
        $path
    );

    return $results;
}

1;

