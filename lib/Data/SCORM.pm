package Data::SCORM;

use Any::Moose;
use Any::Moose qw/ ::Util::TypeConstraints /;
use Data::SCORM::Manifest;
use File::Temp qw/ tempdir /;
use Path::Class::Dir;
use Archive::Extract;

use Data::Dumper;

=head1 NAME

Data::SCORM - Parse SCO files (PIFs)

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Data::SCORM;

    my $foo = Data::SCORM->new();
    ...

=cut

has 'manifest' => (
	is        => 'rw',
	isa       => 'Data::SCORM::Manifest',
	);

subtype 'PathClassDir'
	=> as 'Path::Class::Dir';

coerce 'PathClassDir'
	=> from 'Str'
		=> via { Path::Class::Dir->new($_) };

has 'path' => (
	is        => 'rw',
	isa       => 'PathClassDir',
	coerce    => 1,
	);

sub extract_from_pif {
	my ($class, $pif, $path) = @_;
	
	$path ||= tempdir; # no cleanup?, as caller may want to rename etc.
	
	my $ae = Archive::Extract->new( archive => $pif );
	$ae->extract( to => $path )
		or die "Couldn't extract pif $pif, " . $ae->error;

	return $class->from_dir($path);
}

sub from_dir {
	my ($class, $path) = @_;
	$path = Path::Class::Dir->new($path);
	my $manifest = $path->file( 'imsmanifest.xml' );
	if ($manifest->stat) { # if it exists
		return $class->new(
			path     => $path,
			manifest => Data::SCORM::Manifest->parsefile($manifest),
		  );
	} else {
		die "No such manifest: $manifest";
	}
}

# __PACKAGE__->make_immutable;
no Any::Moose;

=head1 AUTHOR

osfameron, C<< <osfameron at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-data-scorm at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Data-SCORM>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Data::SCORM

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Data-SCORM>

=item * Search CPAN

L<http://search.cpan.org/dist/Data-SCORM/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 OSFAMERON.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of Data::SCORM
