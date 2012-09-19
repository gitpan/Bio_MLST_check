
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "do this once\nexport MLST_DATABASES=/path/to/where_you_want_to_store_the_databases",
  "AUTHOR" => "Andrew J. Page <ap13\@sanger.ac.uk>",
  "BUILD_REQUIRES" => {
    "Test::Most" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Bio_MLST_check",
  "EXE_FILES" => [
    "bin/download_mlst_databases",
    "bin/get_sequence_type"
  ],
  "LICENSE" => "gpl",
  "NAME" => "Bio_MLST_check",
  "PREREQ_PM" => {
    "Bio::AlignIO" => 0,
    "Bio::Perl" => 0,
    "Bio::PrimarySeq" => 0,
    "Bio::SeqIO" => 0,
    "Bio::SimpleAlign" => 0,
    "Cwd" => 0,
    "File::Basename" => 0,
    "File::Copy" => 0,
    "File::Path" => "2.06",
    "File::Temp" => 0,
    "File::Which" => 0,
    "Getopt::Long" => 0,
    "LWP::Simple" => 0,
    "Moose" => 0,
    "Moose::Role" => 0,
    "Moose::Util::TypeConstraints" => 0,
    "Parallel::ForkManager" => 0,
    "Text::CSV" => 0,
    "XML::LibXML" => 0
  },
  "VERSION" => "20120919.1323",
  "test" => {
    "TESTS" => "t/Blast/*.t t/Download/*.t t/Input/*.t t/Output/*.t t/Overall/*.t t/SequenceTypes/*.t t/Settings/*.t"
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



