use strict;
use warnings;
package Exception::Reporter::Summarizer::ExceptionClass;
{
  $Exception::Reporter::Summarizer::ExceptionClass::VERSION = '0.002';
}
use parent 'Exception::Reporter::Summarizer';


use Exception::Class 1.30; # NoContextInfo
use Try::Tiny;
use YAML::XS ();

sub can_summarize {
  my ($self, $entry) = @_;
  return try { $entry->[1]->isa('Exception::Class::Base') };
}

sub summarize {
  my ($self, $entry) = @_;
  my ($name, $exception, $arg) = @$entry;

  my $fn_base = $self->sanitize_filename($name);

  my $ident = $exception->error;
  ($ident) = split /\n/, $ident; # only the first line, please

  # Yes, I have seen the case below need handling! -- rjbs, 2012-07-03
  $ident = "exception of class " . ref $exception unless length $ident;

  # Another option here is to dump this in a few parts:
  # * a YAML dump of the message, error, and fields
  # * a dump of the stack trace
  my @summaries = ({
    filename => "exception-msg.txt",
    mimetype => 'text/plain',
    ident    => $ident,
    body     => $exception->full_message,
  });

  if (! $exception->NoContextInfo) {
    push @summaries, (
      {
        filename => "exception-stack.txt",
        mimetype => 'text/plain',
        ident    => "stack trace",
        body     => $exception->trace->as_string({
          max_arg_length => 0,
        }),
      },
      {
        filename => "exception-context.txt",
        mimetype => 'text/plain',
        ident    => "context info",
        body     => YAML::XS::Dump({
          time => $exception->time,
          pid  => $exception->pid,
          uid  => $exception->uid,
          euid => $exception->euid,
          gid  => $exception->gid,
          egid => $exception->egid,
        }),
      },
    );
  }

  if ($exception->Fields) {
    my $hash = {};
    for my $field ($exception->Fields) {
      $hash->{ $field } = $exception->$field;
    }

    push @summaries, {
      filename => "exception-context.txt",
      mimetype => 'text/plain',
      ident    => "context info",
      body     => YAML::XS::Dump($hash),
    };
  }

  return @summaries;
}

1;

__END__
=pod

=head1 NAME

Exception::Reporter::Summarizer::ExceptionClass

=head1 VERSION

version 0.002

=head1 OVERVIEW

This summarizer handles only L<Exception::Class> objects.  A dumped exception
will result in between one and four summaries:

  * a text summary of the exceptions full message
  * if available, a YAML dump of the exception's pid, time, uid, etc.
  * if available, the stringification of the exception's stack trace
  * if any fields are defined, a YAML dump of the exception's fields

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

