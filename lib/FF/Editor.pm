package FF::Editor;

use Moose;

has 'editor' => (
    is      => 'rw',
    default => $ENV{EDITOR} || 'vi',
);

has 'debug' => (
    is      => 'rw',
    default => 0,
);

has 'editoropts' => (
    is  => 'rw',
    isa => 'Maybe[ArrayRef[Str]]',
);

sub run {
    my $self = shift;
    my $args = shift;

    my @cmd = ();
    push @cmd, $self->editor() || die "ERR: editor not specified";
    my $opts = $self->editoropts();
    if ( ref($opts) and scalar( @{$opts} ) ) {
        push @cmd, @{$opts};
    }
    push @cmd, $args->{file};
    warn "# run: cmd = ", join( ', ', @cmd ), "\n" if $self->debug();
    system(@cmd);
    return $? == 0 ? 1 : 0;
}

1;

