use strict;
use warnings;
package Exception::Reporter::Dumper::YAML;
{
  $Exception::Reporter::Dumper::YAML::VERSION = '0.005';
}
use parent 'Exception::Reporter::Dumper';

use Try::Tiny;
use YAML ();

sub dump {
  my ($self, $value, $arg) = @_;
  my $basename = $arg->{basename} || 'dump';

  my ($dump, $error) = try {
    (YAML::Dump($value), undef);
  } catch {
    (undef, $_);
  };

  if (defined $dump) {
    my $ident = ref $value     ? (try { "$value" } catch { "<unknown>" })
              : defined $value ? "$value" # quotes in case of glob, vstr, etc.
              :                  "(undef)";

    $ident =~ s/\A\n*([^\n]+)(?:\n|$).*/$1/;
    $ident = "<<unknown>>"
      unless defined $ident and length $ident and $ident =~ /\S/;

    return {
      filename => "$basename.yaml",
      mimetype => 'text/plain',
      body     => $dump,
      ident    => $ident,
    };
  } else {
    my $string = try { "$value" } catch { "value could not stringify: $_" };
    return {
      filename => "$basename.txt",
      mimetype => 'text/plain',
      body     => $string,
      ident    => "<error>",
    };
  }
}

1;

__END__

=pod

=head1 NAME

Exception::Reporter::Dumper::YAML

=head1 VERSION

version 0.005

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
