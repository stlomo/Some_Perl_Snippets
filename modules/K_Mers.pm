use strict;
use warnings;

package K_Mers;






######################## subroutines ####################

sub make_arrays_of_k_mers($){
    my $k = shift;
my @bases = ('A','C','G','T');
my @words = @bases;

for my $i (1..$k-1){
    undef my @newwords;
    foreach my $w (@words){
         foreach my $b (@bases){
             push (@newwords,$w.$b);
         }
    }
    undef @words;
    @words = @newwords;
 }

    
    return @words;
}#make_arrays_of_k_mers#

sub count_number_of_occurrances_of_word_in_a_seq($$){
    #note this funtions counts number of overlap words
    my $sequence = shift;
    my $word     = shift;
    
    my $word_length = length($word);
    my $count       = 0;
    while ($sequence =~ /$word/g) {
	pos $sequence -= $word_length-1;
	$count++;
    }
    return $count;
}#count_number_of_occurrances_of_word_in_a_seq#

sub count_number_of_occurrances_of_k_mers_in_tags($$$$$$$){
    my $input_bed_file                               = shift; # file of tags
    my $output_file                                  = shift; # for writting results
    my $start_offset                                 = shift; 
    my $end_offset                                   = shift;
    my $shifting_lengths_ref                         = shift; # can be used for bg otherwise put it zero
    my $k_mers_and_thier_occurrances_ref             = shift; # ref to array of k_mers
    my $chr_sequence                                 = shift;

    my %k_mers_and_thier_occurrances  = %$k_mers_and_thier_occurrances_ref;
    my @k_mers                        = keys %k_mers_and_thier_occurrances;   
    my $first_k_mer                   = $k_mers[0];
    my $k_mer_length                  = length($first_k_mer);

    my @shifting_lengths              = @$shifting_lengths_ref;
    my $number_of_shifting_lengths =  @shifting_lengths; 

   
    

       foreach my $shift_length(@shifting_lengths){
	open(IN, "$input_bed_file") or die "can not open $input_bed_file to read the features!\n";
	print 
	    "========shifting_length =  $shift_length\n";
    
	my $field_counter = 0;
	while (<IN>) {
	    if( $field_counter % 100000 eq 0){
	    	print
	    	    $field_counter."\n";
	    }
	    $field_counter++;
	    chomp $_;
	    my @fields = split("\t", $_);
	    my $chr    = $fields[0];
	    my $start  = $fields[1];
	    my $end    = $fields[2];
	    my $source = $fields[3];
	    my $score  = $fields[4];
	    my $strand  = $fields[5];
	   # if ( !(  ($chr) && ($start) && ($end) && ($source) && ($score) && ($strand)   )) {
		 if ( !( defined($chr) && defined($start) && defined($end) && defined($source) &&  defined($score) && defined($strand)  )) {
		print
		    "chr = $chr\t start= $start\t end = $end\t source = $source\t score = $score\t strand=$strand\n";
	    	die "required six columns but it didnt get it at:  $_ \n";
	    }
	    my $modified_start;
	    my $modified_end;
	    my $modified_length;
	    if($strand eq "+"){
	    	$modified_start = $start - $start_offset + $shift_length ;
	    	$modified_end   = $end +  $end_offset + $shift_length ;
	    }
	    elsif($strand eq "-"){
	    	$modified_start = $start - $end_offset - $shift_length ;
	    	$modified_end = $end + $start_offset - $shift_length ;
	    }
	    else {
	    	die "Unknown strand! at line:\n $_\n";
	    }
	    $modified_length = $modified_end - $modified_start;
	    my $one_sequence  = uc(substr($chr_sequence, $modified_start, $modified_length));
	    next if ($one_sequence =~ m/N/);
	    if ($strand eq "-") {
	    	$one_sequence = &SeqTools::get_revcomp($one_sequence);
		
	    }
	    
	    
	    for (my $p = 0; $p < $modified_length - $k_mer_length; $p++) {
	    	my $subseq = substr($one_sequence, $p, $k_mer_length);
	    	$k_mers_and_thier_occurrances{$subseq}++;
	    	#$k_mers_and_counts{$subseq}++;
	    }
	    
	    
	}
	close(IN);
    }
     open(OUT, ">$output_file") or die "can not open $output_file to write the results into it!\n";
    my %normalized_k_mers_and_counts =  &normlize_a_hash(\%k_mers_and_thier_occurrances, $number_of_shifting_lengths);
    foreach my $key(keys  %normalized_k_mers_and_counts){
	print OUT
	    $key."\t".$normalized_k_mers_and_counts{$key}."\n";
    }
    close(OUT);
    return %normalized_k_mers_and_counts;
}#count_number_of_occurrances_of_k_mers_in_tags#

sub normlize_a_hash($$){
    my $hash_ref            = shift;
    my $normaliztion_number = shift;
    
    my %hash    = %$hash_ref;
    my @words       = keys %hash;
    foreach my $w(@words){
	$hash{$w} = $hash{$w} / $normaliztion_number; 
	   
    }
    return %hash;
}#normlize_a_hash#

sub array_to_hash_with_zero_values($){
    my $array_of_k_mers_ref      = shift;
    
    my @array_of_k_mers          = @$array_of_k_mers_ref;
    my %hash_of_k_mers = ();
    foreach my $k ( @array_of_k_mers){
	$hash_of_k_mers{$k} = 0;
    }
    return  %hash_of_k_mers;
}#array_to_hash_with_zero_values#
1;



