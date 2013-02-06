use strict;
use warnings;
package Exception::Reporter::Summarizer::Fallback;
{
  $Exception::Reporter::Summarizer::Fallback::VERSION = '0.005';
}
use parent 'Exception::Reporter::Summarizer';


use Try::Tiny;

sub can_summarize { 1 }

sub summarize {
  my ($self, $entry, $internal_arg) = @_;
  my ($name, $value, $arg) = @$entry;

  my $fn_base = $self->sanitize_filename($name);

  my $dump = $self->dump($value, { basename => $fn_base });

  return {
    filename => "$fn_base.txt",
    ident    => "dump of $name",
    %$dump,
  };
}

1;

__END__

=pod

=head1 NAME

Exception::Reporter::Summarizer::Fallback

=head1 VERSION

version 0.005

=head1 OVERVIEW

This summarizer will accept any input and summarize it by dumping it with the
Exception::Reporter's dumper.

I recommended that this summarizer is always in your list of summarizers,
and always last.

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
