
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "a generic exception-reporting object",
  "AUTHOR" => "Ricardo Signes <rjbs\@cpan.org>",
  "BUILD_REQUIRES" => {
    "Email::MIME::ContentType" => 0,
    "Exception::Class::Base" => 0,
    "File::Find" => 0,
    "File::Temp" => 0,
    "Test::More" => "0.96"
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Exception-Reporter",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Exception::Reporter",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Data::GUID" => 0,
    "Digest::MD5" => 0,
    "Email::Address" => 0,
    "Email::MIME::Creator" => 0,
    "Email::MessageID" => 0,
    "Email::Sender::Simple" => 0,
    "Exception::Class" => "1.30",
    "File::Basename" => 0,
    "String::Truncate" => 0,
    "Try::Tiny" => 0,
    "YAML::XS" => 0,
    "parent" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.002",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



