use strict;
use warnings;
package Exception::Reporter::Summarizer::Text;
{
  $Exception::Reporter::Summarizer::Text::VERSION = '0.010';
}
use parent 'Exception::Reporter::Summarizer';
# ABSTRACT: a summarizer for plain text strings


# Maybe in the future we can have options to allow empty strings. -- rjbs,
# 2013-02-06

use Encode ();
use Try::Tiny;

sub can_summarize {
  my ($self, $entry) = @_;
  my $value = $entry->[1];
  return unless defined $value;
  return if ref $value;
  return if ref \$value ne 'SCALAR';
  return 1;
}

sub summarize {
  my ($self, $entry, $internal_arg) = @_;
  my ($name, $value, $arg) = @$entry;

  my $fn_base = $self->sanitize_filename($name);

  my $octets = try {
    encode('utf-8', $value, Encode::FB_CROAK);
  } catch {
    $value;
  };

  my $ident = $value;
  $ident =~ s/\A\n+//;
  ($ident) = split /\n/, $ident;

  return {
    filename => "$fn_base.txt",
    ident    => $ident,
    mimetype => 'text/plain',
    charset  => 'utf-8', # possibly a lie if the try failed
    body     => "$value",
  };
}

1;

__END__

=pod

=head1 NAME

Exception::Reporter::Summarizer::Text - a summarizer for plain text strings

=head1 VERSION

version 0.010

=head1 OVERVIEW

This summarizer will summarize simple, non-empty strings by accepting them
verbatim.  They are assumed to be text, and will be encoded to UTF-8.  If that
fails, they will be used verbatim, possibly with strange results.

The summary's C<ident> will be the first non-blank line of the string.

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
