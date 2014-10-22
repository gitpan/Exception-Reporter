use strict;
use warnings;
package Exception::Reporter::Summarizer::Email;
{
  $Exception::Reporter::Summarizer::Email::VERSION = '0.001';
}
use parent 'Exception::Reporter::Summarizer';


use Try::Tiny;

sub can_summarize {
  my ($self, $entry) = @_;
  return try { $entry->[1]->isa('Email::Simple') };
}

sub summarize {
  my ($self, $entry) = @_;
  my ($name, $value, $arg) = @$entry;

  my $fn_base = $self->sanitize_filename($name);

  return {
    filename => "$fn_base.msg",
    mimetype => 'message/rfc822',
    ident    => "email message for $fn_base",
    body     => $value->as_string,
    body_is_bytes => 1,
  };
}

1;

__END__
=pod

=head1 NAME

Exception::Reporter::Summarizer::Email

=head1 VERSION

version 0.001

=head1 OVERVIEW

This summarizer will only summarize Email::Simple (or subclass) objects.  The
emails will be summarized as C<message/rfc822> data containing the
stringification of the message.

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

