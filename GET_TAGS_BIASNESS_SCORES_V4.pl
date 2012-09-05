#!/usr/bin/perl
use strict;
use warnings;

use lib "/nfs/users/nfs_h/hk3/My_Perl_Scripts/modules";
use Ensembl;
use FileTools;
use SeqTools;
use MathsTools;
use PrintingTools;


my $start_offset = 10;
my $end_offset   = 4;
my $tags_bed_file = "/nfs/th_group/hk3/UW_DNaseI_HS/Gm12878/wgEncodeUwDnaseGm12878AlnRep1_chr22.bed";
my $tags_bed_file_with_biasness_scores  = "/nfs/th_group/hk3/UW_DNaseI_HS/Gm12878_For_Paper_Analyis/wgEncodeUwDnaseGm12878AlnRep1_chr22_with_biasness_scores_2.bed";

my $chr_22 = &FileTools::get_seq_from_fasta_file("/nfs/th_group/hk3/Human_CHRS/chr_22.fasta", "Human_chromosome_22");

my $pwm_file_real = "/nfs/th_group/hk3/UW_DNaseI_HS/Gm12878_For_Paper_Analyis/pwm_real_tags.txt";
my $pwm_file_bg   = "/nfs/th_group/hk3/UW_DNaseI_HS/Gm12878_For_Paper_Analyis/pwm_shifted_tags.txt";
my $pwm_real      = &FileTools::read_in_a_matrix_from_a_file($pwm_file_real);
my $pwm_bg        =  &FileTools::read_in_a_matrix_from_a_file($pwm_file_bg);
&get_tags_bias_scores($chr_22, $tags_bed_file, $tags_bed_file_with_biasness_scores, $pwm_real, $pwm_bg, $start_offset, $end_offset, 8, 36);
exit;


############################## subroutines ############## 

sub get_tags_bias_scores($$$$$$$$$){
    my $chr_seq          = shift;
    my $tags_file        = shift; # must be bed file with six columns
    my $output_file      = shift;
    my $pwm_real_tags    = shift;
    my $pwm_bg_tag       = shift;
    my $start_offset     = shift; # how many bases offset from the beging of tags you want
    my $end_offset       = shift; # how many bases offset from the end of tags you want
    my $starting_pos     = shift; # start position you want to look at. must be a number between zero and tag_lengths+ $start_offset+$end_offset, for example in [0,50)
    my $length           = shift; # length of stretch of seq you want too look at


    open(IN, "$tags_file") or die "cannot open file $tags_file to read the data!\n";
    open(OUT, ">$output_file") or die "cannot open file $output_file to write the data!\n";

    my $number_seqs_with_ns = 0;
    while (<IN>) {
	chomp $_;
	my @fields = split("\t", $_);
	my $chr    = $fields[0];
	my $start  = $fields[1];
	my $end    = $fields[2];
	my $source = $fields[3];
	my $score  = $fields[4];
	my $strand  = $fields[5];
	if ( !(  ($chr) && ($start) && ($end) && ($source) && ($score) && ($strand)   )) {
	    die "required six columns but it didnt get it at: \n $_";
	}
	my $modified_start;
	my $modified_end;
	my $modified_length;
	if($strand eq "+"){
	    $modified_start = $start - $start_offset;
	    $modified_end   = $end +  $end_offset;
	}
	elsif($strand eq "-"){
	    $modified_start = $start - $end_offset;
	    $modified_end = $end + $start_offset;
	}
	else {
	    die "unkwon strand! at line:\n $_\n";
	}
	$modified_length = $modified_end - $modified_start;
	my $one_sequence  = uc(substr($chr_seq, $modified_start, $modified_length));
	if ($one_sequence =~ m/N/) {
	    $number_seqs_with_ns++;

	    next;
	    
	}
	if ($strand eq "-") {
	    $one_sequence = &SeqTools::get_revcomp($one_sequence);

	}
	my $prob_seq_give_real_pwm = &MathsTools::get_prob_seq_given_pwm($pwm_real_tags, $one_sequence,$starting_pos, $length );
	my $prob_seq_give_bg_pwm = &MathsTools::get_prob_seq_given_pwm($pwm_bg_tag, $one_sequence, $starting_pos, $length);
	my $one_log_ratio = $prob_seq_give_real_pwm - $prob_seq_give_bg_pwm;
       
#	print
	   # $prob_seq_give_real_pwm ."\t".$prob_seq_give_bg_pwm."\n";
    print OUT
	$chr."\t".$start."\t".$end."\t".$source."\t".$one_log_ratio."\t".$strand."\n";

    }
    close(IN);
    close(OUT);
}#get_tags_bias_scores#




