=head1 NAME

Bio::MLST::Blast::BlastN

=head1 SYNOPSIS

Run NCBI blast and find the top hit.

=head1 DESCRIPTION

use Bio::MLST::Blast::BlastN;

my $blast_database= Bio::MLST::Blast::BlastN->new(
  blast_database => 'output_contigs',
  query_file     => 'alleles/adk.tfa',
  word_size      => 500,
  exec           => 'blastn'
);

$blast_database->top_hit();

=head1 CONTACT

path-help@sanger.ac.uk

=cut

package Bio::MLST::Blast::BlastN;
use Moose;
use Bio::MLST::Types;

# input variables
has 'blast_database'     => ( is => 'ro', isa => 'Str', required => 1 ); 
has 'query_file'         => ( is => 'ro', isa => 'Str', required => 1 ); 
has 'word_size'          => ( is => 'ro', isa => 'Int', required => 1 ); 
has 'exec'               => ( is => 'ro', isa => 'Bio::MLST::Executable', default  => 'blastn' ); 
has 'perc_identity'      => ( is => 'ro', isa => 'Int', default  => 95 );

# Generated

has 'top_hit'           => ( is => 'ro', isa => 'Maybe[HashRef]', lazy => 1,  builder => '_build_top_hit' ); 

sub _blastn_cmd
{
  my($self) = @_;
  my $word_size = int(100/(100 - $self->perc_identity ));
  $word_size = 11 if($word_size < 11);
  
  join(' ',($self->exec, '-task blastn', '-query', $self->query_file, '-db', $self->blast_database, '-outfmt 6', '-word_size', $word_size , '-perc_identity', $self->perc_identity ));
}

sub _build_top_hit
{
  my($self) = @_;
  open( my $blast_output_fh, '-|',$self->_blastn_cmd);
  my $highest_identity = 0;
  my %top_hit;
  my %contamination_check;

  while(<$blast_output_fh>)
  {
    chomp;
    my $line = $_;
    my @blast_raw_results = split(/\t/,$line);
    next unless($blast_raw_results[3] == $self->word_size);
    if(@blast_raw_results  > 8 && $blast_raw_results[2] >= $highest_identity)
    {
      $top_hit{allele_name} = $blast_raw_results[0];
      $top_hit{percentage_identity} = int($blast_raw_results[2]);
      $top_hit{source_name} = $blast_raw_results[1];
      $top_hit{reverse} = 0;
      
      my $start  = $blast_raw_results[8];
      my $end  = $blast_raw_results[9];
      if($start > $end)
      {
        my $tmp = $start;
        $start = $end;
        $end = $tmp;
        $top_hit{reverse} = 1;
      }
      
      $top_hit{source_start} = $start;
      $top_hit{source_end} = $end;
      $highest_identity = $blast_raw_results[2];
      if($top_hit{percentage_identity} == 100)
      {
        $contamination_check{$top_hit{allele_name}} = $top_hit{percentage_identity};
      }
    }
  }
  
  if((keys %contamination_check) >= 2)
  {
    my @found_alleles = values(%contamination_check);
    $top_hit{contamination} = \@found_alleles;
  }
  
  return \%top_hit;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
