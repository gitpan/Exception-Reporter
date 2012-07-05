use strict;
use warnings;
package Exception::Reporter::Summarizer;
{
  $Exception::Reporter::Summarizer::VERSION = '0.003';
}
# ABSTRACT: a thing that summarizes dumpables for reporting

use Carp ();


sub new {
  my $class = shift;

  Carp::confess("$class constructor does not take any parameters") if @_;

  return bless {}, $class;
}

sub sanitize_filename {
  my ($self, $filename) = @_;

  # These don't need to be actually secure, since we won't use this for
  # opening any filehandles. -- rjbs, 2012-07-03
  $filename =~ s/\.+/./g;
  $filename =~ s/[^-a-zA-Z0-9]/-/g;
  return $filename;
}

1;

__END__
=pod

=head1 NAME

Exception::Reporter::Summarizer - a thing that summarizes dumpables for reporting

=head1 VERSION

version 0.003

=head1 OVERVIEW

This class exists almost entirely to allow C<isa>-checking.  It provides a
C<new> method that returns a blessed, empty object.  Passing it any parameters
will cause an exception to be thrown.

A C<sanitize_filename> method is also provided, which turns a vaguely
filename-like string into a safer filename string.

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

