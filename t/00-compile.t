use strict;
use warnings;

# This test was generated via Dist::Zilla::Plugin::Test::Compile 2.018

use Test::More 0.88;



use Capture::Tiny qw{ capture };

my @module_files = qw(
Exception/Reporter.pm
Exception/Reporter/Dumpable/File.pm
Exception/Reporter/Dumper.pm
Exception/Reporter/Dumper/YAML.pm
Exception/Reporter/Sender.pm
Exception/Reporter/Sender/Email.pm
Exception/Reporter/Summarizer.pm
Exception/Reporter/Summarizer/Email.pm
Exception/Reporter/Summarizer/ExceptionClass.pm
Exception/Reporter/Summarizer/Fallback.pm
Exception/Reporter/Summarizer/File.pm
Exception/Reporter/Summarizer/Text.pm
);

my @scripts = qw(

);

# no fake home requested

my @warnings;
for my $lib (@module_files)
{
    my ($stdout, $stderr, $exit) = capture {
        system($^X, '-Mblib', '-e', qq{require q[$lib]});
    };
    is($?, 0, "$lib loaded ok");
    warn $stderr if $stderr;
    push @warnings, $stderr if $stderr;
}



is(scalar(@warnings), 0, 'no warnings found') if $ENV{AUTHOR_TESTING};



done_testing;
