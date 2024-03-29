#!/usr/bin/env perl
use strict;
use warnings;
use File::Temp;

BEGIN { unshift(@INC, './lib') }
BEGIN {
    use Test::Most;
    use_ok('Bio::MLST::SequenceType');
}

ok((my $sequence_type = Bio::MLST::SequenceType->new(
  profiles_filename => 't/data/Escherichia_coli_1/profiles/escherichia_coli.txt',
  sequence_names => ['adk-2','purA-3','recA-1']
)), 'initialise ST');
is($sequence_type->sequence_type, 4, 'lookup the sequence type');
is($sequence_type->nearest_sequence_type,undef, 'lookup the nearest sequence type when exact match found');

# sequence type that doesnt exist in profile
ok(($sequence_type = Bio::MLST::SequenceType->new(
  profiles_filename => 't/data/Escherichia_coli_1/profiles/escherichia_coli.txt',
  sequence_names => ['adk-2','purA-3','recA-200']
)), 'initialise sequence type that doesnt exist in profile');
is($sequence_type->sequence_type,undef, 'lookup the sequence type that doesnt exist in profile');
is($sequence_type->nearest_sequence_type,1, 'lookup the nearest sequence type for allele that doesnt exist in profile');

# missing an allele
ok(($sequence_type = Bio::MLST::SequenceType->new(
  profiles_filename => 't/data/Escherichia_coli_1/profiles/escherichia_coli.txt',
  sequence_names => ['adk-2','purA-3']
)), 'initialise ST missing an allele');
is( $sequence_type->sequence_type, undef, 'lookup the sequence type missing an allele');
is($sequence_type->nearest_sequence_type, 1, 'lookup the nearest sequence type for missing an allele');

done_testing();
