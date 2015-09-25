package Notepad::Search;

use Moose;
use File::Find;

has 'path' => (
    is => 'rw',
    default => $ENV{HOME} . '/Notes',
);

sub get {
    my $self = shift;
    my $args = shift;
    my $results = [];

    my $path = $self->path();
    my $pattern = $args->{pattern};
    my $type = $args->{type} || 'file';

    if ( not defined $pattern ) {
        $pattern = '';
    }

    if ( $type eq 'data' ) {
        # this is dirty... very dirty...
        # TODO: Either do the find and grep in pure perl or perhaps
        # use 'git grep' to take advantage of the git internal 
        # indexing
    #    warn "# search pattern = $pattern";
        open(GREP, "find $path -type f -print0 | xargs -0 grep -i '$pattern' |") or die "Error running search command: $!";
        while (my $line = <GREP>) {
            chomp $line;
            my ($file, $data) = split(/:/, $line, 2);
            push @{ $results },  { file => $file, line => $data };
        }
        return $results;
    } elsif ( $type eq 'file' ) {
        # this is dirty... very dirty...
        find( sub {
                if ( -f $File::Find::name ) {
                    # Exclude ALL hidden files
                    if ( $_ =~ m{^\.} ) {
                        return;
                    }
#                    warn "# checking $File::Find::name for pattern $pattern...";
                    if ( $pattern and (not $File::Find::name =~ m{$pattern}i) ) {
#                        warn "DEBUG: skipping '$File::Find::name' (no pattern match)";
                    } else {
                        push @{ $results }, {
                            file => $File::Find::name,
                        };
                    }
                };
            }, $path
        );
        return $results;
    }
    return;
}


1;


