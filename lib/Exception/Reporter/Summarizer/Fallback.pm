use strict;
use warnings;
package Exception::Reporter::Summarizer::Fallback;
{
  $Exception::Reporter::Summarizer::Fallback::VERSION = '0.002';
}
use parent 'Exception::Reporter::Summarizer';


use YAML::XS ();
use Try::Tiny;

sub can_summarize { 1 }

sub summarize {
  my ($self, $entry) = @_;
  my ($name, $value, $arg) = @$entry;

  my $fn_base = $self->sanitize_filename($name);

  return try {
    my $body  = ref $value     ? YAML::XS::Dump($value)
              : defined $value ? $value
              :                  "(undef)";;

    my $ident = $body;
    $ident =~ s/\A---\s*// if ref $value; # strip the document marker

    # If we've got a Perl-like exception string, make it more generic by
    # stripping the throw location.
    $ident =~ s/\s+(?:at .+?)? ?line\s\d+\.?$//;

    return {
      filename => "$fn_base.yaml",
      mimetype => 'text/plain',
      ident    => $ident,
      body     => $body,
    };
  } catch {
    return(
      {
        filename => "$fn_base-error.txt",
        mimetype => 'text/plain',
        ident    => "$name dumpable dumping error",
        body     => "could not summarize $name value: $_\n",
      },
      {
        filename => "$fn_base-raw.txt",
        mimetype => 'text/plain',
        ident    => "$name dumpable stringification",
        body     => do { no warnings 'uninitialized'; "$name" },
      },
    );
  };
}

1;

__END__
=pod

=head1 NAME

Exception::Reporter::Summarizer::Fallback

=head1 VERSION

version 0.002

=head1 OVERVIEW

This summarizer will accept any input and summarize it by dumping it to YAML.

I recommended that this summarizer is always in your list of summarizers,
and always last.

If a YAML dump can't be produced, the exception from YAML will be attached,
along with the stringification of the dumpable value.

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

