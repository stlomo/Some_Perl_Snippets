#!/usr/bin/perl
use strict;
use warnings;

use lib "/nfs/users/nfs_h/hk3/src/lib/perl5";
use lib '/nfs/users/nfs_h/hk3/src/bioperl-live';
use lib '/nfs/users/nfs_h/hk3/src/ensembl/modules';
use lib '/nfs/users/nfs_h/hk3/src/ensembl-compara/modules';
use lib '/nfs/users/nfs_h/hk3/src/ensembl-variation/modules';
use lib '/nfs/users/nfs_h/hk3/src/ensembl-functgenomics/modules';
use Bio::EnsEMBL::Registry;
use Bio::Seq;
use Bio::SeqIO;
use Bio::AlignIO;
use Bio::Perl;
use Bio::FeatureIO;
use Bio::Tools::GFF;
use Bio::SeqFeature::Generic;


srand (time ^ $$ ^ unpack "%L*", `ps axww | gzip`); 


# make connection to Ensembl Registry
my $registry = 'Bio::EnsEMBL::Registry';


#load registry
$registry->load_registry_from_db(
    -host => 'ensembldb.ensembl.org',
    -user => 'anonymous'
    );




#my $human_chr_22_seq = &GET_CHROMOSOME_SEQUENCE('Human','22','false');
#&PICK_RANDOM_SUB_REGION_OF_CHROMOSOME($human_chr_22_seq,50);

#my $number_of_tags = &GET_FREQ_OF_DINUCLEOTIDE_FROM_SEQS_IN_A_FASTQ_FILE("/nfs/th_group/hk3/UW_DNaseI_HS/K562/wgEncodeUwDnaseK562RawDataRep1.fastq",
#"/nfs/th_group/hk3/UW_DNaseI_HS/K562/wgEncodeUwDnaseK562RawDataRep1.txt");

#&GET_FREQ_OF_DINUCLEOTIDE_OVER_TAGS_IN_A_FASTQ_FILE("/nfs/th_group/hk3/UW_DNaseI_HS/H1hesc/TESTING.fastq","/nfs/th_group/hk3/UW_DNaseI_HS/H1hesc/TESTING_V1.txt", 26);

#&GET_FREQ_OF_DINUCLEOTIDE_OVER_TAGS_IN_A_FASTQ_FILE_V2("/nfs/th_group/hk3/UW_DNaseI_HS/K562/wgEncodeUwDnaseK562RawDataRep1.fastq","/nfs/th_group/hk3/UW_DNaseI_HS/K562/Dinuc_Freq_V2_wgEncodeUwDnaseK562RawDataRep1.txt", 26);
#&GET_FREQ_OF_DINUCLEOTIDE_OVER_TAGS_IN_A_FASTQ_FILE_V3("Human","22", "0", "/nfs/th_group/hk3/UW_DNaseI_HS/Gm12878/wgEncodeUwDnaseGm12878AlnRep1.bed", 
 #,36);
#&GET_FREQ_OF_DINUCLEOTIDE_OVER_TAGS_IN_A_FASTQ_FILE_V4("Human", "22", "/nfs/th_group/hk3/UW_DNaseI_HS/K562/Tags_At_Boundaries.bed",36);
#&GET_SOME_RAND0M_SEQS_FROM_THE_CHRO_AND_COUNT_FREQ_OF_THIER_INITIAL_DINUCLEOTIDES('Human','1',50000,5, 'false',
#"/nfs/th_group/hk3/UW_DNaseI_HS/Gm12878/Randomly_Picked_For_TEST.txt");
    exit;

sub GET_FREQ_OF_DINUCLEOTIDE_FROM_SEQS_IN_A_FASTQ_FILE ($$){
	my $fq_input_file  = shift;
	my $output_file    = shift;
	
	my $AA = 0 ;
	my $AC = 0 ;
	my $AG = 0 ;
	my $AT = 0 ;
	
	my $CA = 0 ;
	my $CC = 0 ;
	my $CG = 0 ;
	my $CT = 0 ;
	
	my $GA = 0 ;
	my $GC = 0 ;
	my $GG = 0 ;
	my $GT = 0 ;
	
	my $TA = 0 ;
	my $TC = 0 ;
	my $TG = 0 ;
	my $TT = 0 ;
	
	open(OUT,">$output_file") or die "Cannot open file $output_file to write results in!\n";
	
	my $input_obj   = Bio::SeqIO -> new(-fromat => 'fastq-illumina', - file => $fq_input_file);
	my $seq_obj;
	my $number_of_tags =0;
	while($seq_obj = $input_obj->next_seq()){
		#my $id = $seq_obj->id();
	    $number_of_tags++;
		my $seq = $seq_obj->seq();
		$seq    = uc($seq);
		next if ($seq =~ m/N/);
		my $initial_dinucleotide = substr($seq,0,2);
		
	
		if($initial_dinucleotide eq "AA"){
			$AA++;		
		}
		elsif($initial_dinucleotide eq "AC"){
			$AC++;
		}
		elsif($initial_dinucleotide eq "AG"){
			$AG++;
		}
		elsif($initial_dinucleotide eq "AT"){
			$AT++;
		}
		elsif($initial_dinucleotide eq "CA"){
			$CA++;
		}
		elsif($initial_dinucleotide eq "CC"){
			$CC++
		}
		elsif($initial_dinucleotide eq "CG"){
			$CG++;
		}
		elsif($initial_dinucleotide eq "CT"){
			$CT ++;
		}
		elsif($initial_dinucleotide eq "GA"){
			$GA ++;
		}
		elsif($initial_dinucleotide eq "GC"){
			$GC++;
		}
		elsif($initial_dinucleotide eq "GG"){
			$GG++;
		}
		elsif($initial_dinucleotide eq "GT"){
			$GT++;
		}
		elsif($initial_dinucleotide eq "TA"){
			$TA++;
		}
		elsif($initial_dinucleotide eq "TC"){
			$TC++;
		}
		elsif($initial_dinucleotide eq "TG"){
			$TG++;
		}
		elsif($initial_dinucleotide eq "TT"){
			$TT++;
		}
		else{
			print
			"ooh ha!  unknown charecter detected!\n";
		}
			}
			print OUT
			"AA\t".$AA."\n".
			"AC\t".$AC."\n".
			"AG\t".$AG."\n".
			"AT\t".$AT."\n".
			"CA\t".$CA."\n".
			"CC\t".$CC."\n".
			"CG\t".$CG."\n".
			"CT\t".$CT."\n".
			"GA\t".$GA."\n".
			"GC\t".$GC."\n".
			"GG\t".$GG."\n".
			"GT\t".$GT."\n".
			"TA\t".$TA."\n".
			"TC\t".$TC."\n".
			"TG\t".$TG."\n".
			"TT\t".$TT."\n";
	$input_obj->close();
	close(OUT);
	return $number_of_tags;
}#GET_FREQ_OF_DINUCLEOTIDE_FROM_SEQS_IN_A_FASTQ_FILE#





sub GET_FREQ_OF_DINUCLEOTIDE_OVER_TAGS_IN_A_FASTQ_FILE($$$){
    my $fastq_inout_file        = shift;
    my $output_file             = shift;
    my $length_of_tags          = shift;


    open(OUT,">$output_file") or die "Cannot open file $output_file to write results in!\n";
    
    
    
    
    for(my $index =0; $index < $length_of_tags; $index++ ){
	my $AA = 0 ;
	my $AC = 0 ;
	my $AG = 0 ;
	my $AT = 0 ;
	
	my $CA = 0 ;
	my $CC = 0 ;
	my $CG = 0 ;
	my $CT = 0 ;
	
	my $GA = 0 ;
	my $GC = 0 ;
	my $GG = 0 ;
	my $GT = 0 ;
	
	my $TA = 0 ;
	my $TC = 0 ;
	my $TG = 0 ;
	my $TT = 0 ;
	print " index = $index \n";
	my $input_obj   = Bio::SeqIO -> new(-fromat => 'fastq-illumina', - file => $fastq_inout_file);
	my $seq_obj;
	while($seq_obj = $input_obj->next_seq()){
		my $seq = $seq_obj->seq();
		$seq    = uc($seq);
		next if ($seq =~ m/N/);
		my $initial_dinucleotide = substr($seq,$index,2);
		    
		if($initial_dinucleotide eq "AA"){
			$AA++;		
		}
		elsif($initial_dinucleotide eq "AC"){
			$AC++;
		}
		elsif($initial_dinucleotide eq "AG"){
			$AG++;
		}
		elsif($initial_dinucleotide eq "AT"){
			$AT++;
		}
		elsif($initial_dinucleotide eq "CA"){
			$CA++;
		}
		elsif($initial_dinucleotide eq "CC"){
			$CC++
		}
		elsif($initial_dinucleotide eq "CG"){
			$CG++;
		}
		elsif($initial_dinucleotide eq "CT"){
			$CT ++;
		}
		elsif($initial_dinucleotide eq "GA"){
			$GA ++;
		}
		elsif($initial_dinucleotide eq "GC"){
			$GC++;
		}
		elsif($initial_dinucleotide eq "GG"){
			$GG++;
		}
		elsif($initial_dinucleotide eq "GT"){
			$GT++;
		}
		elsif($initial_dinucleotide eq "TA"){
			$TA++;
		}
		elsif($initial_dinucleotide eq "TC"){
			$TC++;
		}
		elsif($initial_dinucleotide eq "TG"){
			$TG++;
		}
		elsif($initial_dinucleotide eq "TT"){
			$TT++;
		}
		else{
			print
			"This looks starnge!  unknown charecter detected!\n";
		}
	}#while#
	$input_obj->close();
	print OUT
	    $AA.",".$AC.",".$AG.",".$AT.",".$CA.",".$CC.",".$CG.",".$CT.",".$GA.",".$GC.",".$GG.",".$GT.",".$TA.",".$TC.",".$TG.",".$TT."\n";

    }#for#
    
    close(OUT);
						       }#GET_FREQ_OF_DINUCLEOTIDE_OVER_TAGS_IN_A_FASTQ_FILE#




sub GET_FREQ_OF_DINUCLEOTIDE_OVER_TAGS_IN_A_FASTQ_FILE_V2($$$){
#Note: because GET_FREQ_OF_DINUCLEOTIDE_OVER_TAGS_IN_A_FASTQ_FILE wasnt efficient when the numbe of sequences was high (which is usually the case for fastq files) this V2 is implemented
    my $fastq_inout_file        = shift;
    my $output_file             = shift;
    my $length_of_tags          = shift;
    
#first it declares a matrix with 16 cols and number of row = $length_of_tags and then for each seqs it oterates over seq positions and updates the matrix;
    
#declare and assign zeros to the matrix
    my @freq_matrix;
    for (my $r=0; $r<$length_of_tags; $r++){
	for(my $c =0; $c <16; $c++){
	    $freq_matrix[$r][$c] = 0;
	}
    }
    

#start reading the fasq file:
    my $input_obj   = Bio::SeqIO -> new(-fromat => 'fastq-illumina', - file => $fastq_inout_file);
    my $seq_obj;
    while($seq_obj = $input_obj->next_seq()){
		my $seq = $seq_obj->seq();
		$seq    = uc($seq);
		next if ($seq =~ m/N/);
		for(my $p =0;$p<$length_of_tags; $p++){
		    my $one_dinucleotide =  substr($seq,$p,2);
		    if($one_dinucleotide eq "AA"){
			$freq_matrix[$p][0]= $freq_matrix[$p][0]+1;		
		    }
		    elsif($one_dinucleotide eq "AC"){
			$freq_matrix[$p][1]= $freq_matrix[$p][1]+1;
		    }
		    elsif($one_dinucleotide eq "AG"){
			$freq_matrix[$p][2]= $freq_matrix[$p][2]+1;
		    }
		    elsif($one_dinucleotide eq "AT"){
			$freq_matrix[$p][3]= $freq_matrix[$p][3]+1;
		    }
		    elsif($one_dinucleotide eq "CA"){
			$freq_matrix[$p][4]= $freq_matrix[$p][4]+1;
		    }
		    elsif($one_dinucleotide eq "CC"){
			$freq_matrix[$p][5]= $freq_matrix[$p][5]+1;
		    }
		    elsif($one_dinucleotide eq "CG"){
			$freq_matrix[$p][6]= $freq_matrix[$p][6]+1;
		    }
		    elsif($one_dinucleotide eq "CT"){
			$freq_matrix[$p][7]= $freq_matrix[$p][7]+1;
		    }
		    elsif($one_dinucleotide eq "GA"){
			$freq_matrix[$p][8]= $freq_matrix[$p][8]+1;
		    }
		    elsif($one_dinucleotide eq "GC"){
			$freq_matrix[$p][9]= $freq_matrix[$p][9]+1;
		    }
		    elsif($one_dinucleotide eq "GG"){
			$freq_matrix[$p][10]= $freq_matrix[$p][10]+1;
		    }
		    elsif($one_dinucleotide eq "GT"){
			$freq_matrix[$p][11]= $freq_matrix[$p][11]+1;
		    }
		    elsif($one_dinucleotide eq "TA"){
			$freq_matrix[$p][12]= $freq_matrix[$p][12]+1;
		    }
		    elsif($one_dinucleotide eq "TC"){
			$freq_matrix[$p][13]= $freq_matrix[$p][13]+1;
		    }
		    elsif($one_dinucleotide eq "TG"){
			$freq_matrix[$p][14]= $freq_matrix[$p][14]+1;
		    }
		    elsif($one_dinucleotide eq "TT"){
			$freq_matrix[$p][15]= $freq_matrix[$p][15]+1;
		    }
		    else{
			print
			    "This looks starnge!  unknown charecter detected!\n";
		    }
		    
		    
		}#for#
		
    }#while#
    $input_obj->close();

    open(OUT,">$output_file") or die "Cannot open file $output_file to write results in!\n";
    for(my $r=0; $r<$length_of_tags; $r++){
	for(my $c=0;$c<15; $c++){
	    print OUT
		$freq_matrix[$r][$c].",";
	}
	print OUT 
	    $freq_matrix[$r][15];
	print  OUT
	    "\n";
    }
    
    
							  }#GET_FREQ_OF_DINUCLEOTIDE_OVER_TAGS_IN_A_FASTQ_FILE_V2#



sub GET_UNIQUE_FEATURES_FROM_A_BED_FILE($){
    my $input_bed_file     = shift;


    open(IN ,$input_bed_file ) or die "Cannot open file $input_bed_file for reading data\n";
    my @lines = <IN>;
    close(IN);
    my %unique_features;
    foreach my $line( @lines){
	chomp($line);
	my @line_spec = split("\t", $line);
	my $chr    = $line_spec[0];
	my $start  = $line_spec[1];
	my $end    = $line_spec[2];
	my $source = $line_spec[3];
	my $score  = $line_spec[4];
	my $strand = $line_spec[5];
	my $one_object = {
	    Chr => $chr,
	    Start => $start,
	    End   =>$end,
	    Source => $source,
	    Score  => $score,
	    Strand => $strand
	};
	$unique_features{$start}= $one_object;
    }

     return %unique_features;
}#GET_UNIQUE_FEATURES_FROM_A_BED_FILE#


sub GET_OUTPUT_FILE_NAME ($$$){
    my $input_file = shift;
    my $strand     = shift;
    my $Chr        = shift;
    
    my $St;
    if($strand eq "+"){
	$St = "positive_strand";
    }
    elsif($strand eq "-"){
	$St = "negative_strand";
    }
    elsif( $strand eq "0"){
	$St = "positive_and_negative_strand"
    }
    else{
	die "Only +, - and 0 is accepted as strand parameter!\n";
    }
    $input_file =~ s/.bed//;
    $input_file = $input_file."_".$Chr."_Freq_Matrix_".$St.".txt";
    return $input_file;
}#GET_OUTPUT_FILE_NAME#




sub GET_FREQ_OF_DINUCLEOTIDE_OVER_TAGS_IN_A_FASTQ_FILE_V3($$$$$$){
    # get information of features from the bed file, then retain the required ones from the ENSEMBL and get the dinucleotide freqs and print them in a matrix format.
    # difference with V2 is that here features (tags) are read from the bed files that have obtained by bam2bed conversion. but V2 was reading tags from the fastq files. 
    my $species                = shift;
    my $Chr                    = shift;
    my $Strand                 = shift;
    my $input_bed_file         = shift;
    #my $output_file            = shift;
    my $tag_lengths            = shift;
    
    
    my $output_file    = &GET_OUTPUT_FILE_NAME($input_bed_file,$Strand,$Chr);
    my $tem_file =  $input_bed_file;
    $tem_file   =~ s/.bed//;
    $tem_file  = $tem_file."_chr".$Chr.".bed";
    
    #get features only for the given chromosome
    my $CMD = "grep -e '^chr$Chr' $input_bed_file > $tem_file";
    system $CMD;
    print
	"feature from $Chr was writen into a file\n";

    #get save unique features in a has and delete the temp file
    my %unique_features = &GET_UNIQUE_FEATURES_FROM_A_BED_FILE($tem_file);
    unlink($tem_file);
    print
	"unique features was stored in a hash\n";
    
    
#declare and assign zeros to the matrix
    my @freq_matrix;
    for (my $r=0; $r<$tag_lengths ; $r++){
	for(my $c =0; $c <16; $c++){
	    $freq_matrix[$r][$c] = 0;
	}
    }
    
    my $slice_adaptor = $registry->get_adaptor($species, 'Core', 'Slice');
    

    
    
    foreach my $start_position(keys %unique_features){
	my $one_feat    =   $unique_features{$start_position};
	my $chr         =   $one_feat->{Chr};
	my $start       =   $one_feat->{Start};
	my $end         =   $one_feat->{End};
	my $source_tag  =   $one_feat->{Source};
	my $score       =   $one_feat->{Score};
	my $strand      =   $one_feat->{Strand};
	
	$chr  =~ s/chr//;
	my $seq_slice;
	if($Strand eq "0"){
	    $seq_slice = $slice_adaptor->fetch_by_region('chromosome',$chr,$start,$end);
	    
	}
	elsif ($Strand eq $strand  ){
	    $seq_slice = $slice_adaptor->fetch_by_region('chromosome',$chr,$start,$end);
	}
	else{
	    next;
	}
	my $seq = uc($seq_slice->seq());
	next if ($seq =~ m/N/);
	my $seq_length = length($seq);
	if($seq_length ne $tag_lengths+1){
	    die "you passed $tag_lengths as tag_length parameter where as there are some tags with length $seq_length\n";
	}

	
	
	for(my $p =0;$p<$tag_lengths; $p++){
	    my $one_dinucleotide =  substr($seq,$p,2);
	    if($one_dinucleotide eq "AA"){
		$freq_matrix[$p][0]= $freq_matrix[$p][0]+1;		
	    }
	    elsif($one_dinucleotide eq "AC"){
		$freq_matrix[$p][1]= $freq_matrix[$p][1]+1;
	    }
	    elsif($one_dinucleotide eq "AG"){
		$freq_matrix[$p][2]= $freq_matrix[$p][2]+1;
	    }
	    elsif($one_dinucleotide eq "AT"){
		$freq_matrix[$p][3]= $freq_matrix[$p][3]+1;
	    }
	    elsif($one_dinucleotide eq "CA"){
		$freq_matrix[$p][4]= $freq_matrix[$p][4]+1;
	    }
	    elsif($one_dinucleotide eq "CC"){
		$freq_matrix[$p][5]= $freq_matrix[$p][5]+1;
	    }
	    elsif($one_dinucleotide eq "CG"){
		$freq_matrix[$p][6]= $freq_matrix[$p][6]+1;
	    }
	    elsif($one_dinucleotide eq "CT"){
		$freq_matrix[$p][7]= $freq_matrix[$p][7]+1;
	    }
	    elsif($one_dinucleotide eq "GA"){
		$freq_matrix[$p][8]= $freq_matrix[$p][8]+1;
	    }
	    elsif($one_dinucleotide eq "GC"){
		$freq_matrix[$p][9]= $freq_matrix[$p][9]+1;
	    }
	    elsif($one_dinucleotide eq "GG"){
		$freq_matrix[$p][10]= $freq_matrix[$p][10]+1;
	    }
	    elsif($one_dinucleotide eq "GT"){
		$freq_matrix[$p][11]= $freq_matrix[$p][11]+1;
	    }
	    elsif($one_dinucleotide eq "TA"){
		$freq_matrix[$p][12]= $freq_matrix[$p][12]+1;
	    }
	    elsif($one_dinucleotide eq "TC"){
		$freq_matrix[$p][13]= $freq_matrix[$p][13]+1;
	    }
	    elsif($one_dinucleotide eq "TG"){
		$freq_matrix[$p][14]= $freq_matrix[$p][14]+1;
	    }
	    elsif($one_dinucleotide eq "TT"){
		$freq_matrix[$p][15]= $freq_matrix[$p][15]+1;
	    }
	    else{
		print
		    "This looks starnge!  unknown charecter detected!\n";
	    }
	    
	    
	}#for#	
	
	
	
    }#foreach#

#print out data into a file
    open(OUT,">$output_file") or die "Cannot open file $output_file to write results in!\n";
    for(my $r=0; $r<$tag_lengths; $r++){
	for(my $c=0;$c<15; $c++){
	    print OUT
		$freq_matrix[$r][$c].",";
	}#c#
	print OUT 
	    $freq_matrix[$r][15];
	print  OUT
	    	"\n";
    }#r#  
}#GET_FREQ_OF_DINUCLEOTIDE_OVER_TAGS_IN_A_FASTQ_FILE_V3#

###################

sub GET_FREQ_OF_DINUCLEOTIDE_OVER_TAGS_IN_A_FASTQ_FILE_V4($$$$$){
#difference with V4 and V3 is that in V4 we do not need the strand pararameter, there for if a feature has a negative strand its sequence is reversed
# and then diculeotides are counted. This is the normal way of doing that not to seperate them up by strands. 
    my $species                = shift;
    my $Chr                    = shift;
    my $input_bed_file         = shift;
    my $tag_lengths            = shift;
    
    
    
   
    my $tem_file =  $input_bed_file;
    $tem_file   =~ s/.bed//;
    my $output_file    = $tem_file."_".$Chr."_Freq_Matrix.txt";
    $tem_file  = $tem_file."_chr".$Chr.".bed";

   

    #get features only for the given chromosome
    my $CMD = "grep -e '^chr$Chr\t' $input_bed_file > $tem_file";
    system $CMD;
    print
	"feature from $Chr was writen into a file\n";

    #get save unique features in a has and delete the temp file
    my %unique_features = &GET_UNIQUE_FEATURES_FROM_A_BED_FILE($tem_file);
    unlink($tem_file);
    print
	"unique features was stored in a hash\n";
    
    
#declare and assign zeros to the matrix
    my @freq_matrix;
    for (my $r=0; $r<$tag_lengths ; $r++){
	for(my $c =0; $c <16; $c++){
	    $freq_matrix[$r][$c] = 0;
	}
    }
    
    my $slice_adaptor = $registry->get_adaptor($species, 'Core', 'Slice');
    

    
    
    foreach my $start_position(keys %unique_features){
	my $one_feat    =   $unique_features{$start_position};
	my $chr         =   $one_feat->{Chr};
	my $start       =   $one_feat->{Start};
	my $end         =   $one_feat->{End};
	my $source_tag  =   $one_feat->{Source};
	my $score       =   $one_feat->{Score};
	my $strand      =   $one_feat->{Strand};
	
	$chr  =~ s/chr//;
	my $seq_slice =  $slice_adaptor->fetch_by_region('chromosome',$chr,$start,$end);
	my $seq = uc($seq_slice->seq());
	if($strand eq "-"){
	   # $seq = reverse $seq;
	    $seq  = &GET_REVCOMP($seq);
	}
	next if ($seq =~ m/N/);
	my $seq_length = length($seq);
	if($seq_length ne $tag_lengths+1){
	    die "you passed $tag_lengths as tag_length parameter where as there are some tags with length $seq_length\n";
	}

	
	
	for(my $p =0;$p<$tag_lengths; $p++){
	    my $one_dinucleotide =  substr($seq,$p,2);
	    if($one_dinucleotide eq "AA"){
		$freq_matrix[$p][0]= $freq_matrix[$p][0]+1;		
	    }
	    elsif($one_dinucleotide eq "AC"){
		$freq_matrix[$p][1]= $freq_matrix[$p][1]+1;
	    }
	    elsif($one_dinucleotide eq "AG"){
		$freq_matrix[$p][2]= $freq_matrix[$p][2]+1;
	    }
	    elsif($one_dinucleotide eq "AT"){
		$freq_matrix[$p][3]= $freq_matrix[$p][3]+1;
	    }
	    elsif($one_dinucleotide eq "CA"){
		$freq_matrix[$p][4]= $freq_matrix[$p][4]+1;
	    }
	    elsif($one_dinucleotide eq "CC"){
		$freq_matrix[$p][5]= $freq_matrix[$p][5]+1;
	    }
	    elsif($one_dinucleotide eq "CG"){
		$freq_matrix[$p][6]= $freq_matrix[$p][6]+1;
	    }
	    elsif($one_dinucleotide eq "CT"){
		$freq_matrix[$p][7]= $freq_matrix[$p][7]+1;
	    }
	    elsif($one_dinucleotide eq "GA"){
		$freq_matrix[$p][8]= $freq_matrix[$p][8]+1;
	    }
	    elsif($one_dinucleotide eq "GC"){
		$freq_matrix[$p][9]= $freq_matrix[$p][9]+1;
	    }
	    elsif($one_dinucleotide eq "GG"){
		$freq_matrix[$p][10]= $freq_matrix[$p][10]+1;
	    }
	    elsif($one_dinucleotide eq "GT"){
		$freq_matrix[$p][11]= $freq_matrix[$p][11]+1;
	    }
	    elsif($one_dinucleotide eq "TA"){
		$freq_matrix[$p][12]= $freq_matrix[$p][12]+1;
	    }
	    elsif($one_dinucleotide eq "TC"){
		$freq_matrix[$p][13]= $freq_matrix[$p][13]+1;
	    }
	    elsif($one_dinucleotide eq "TG"){
		$freq_matrix[$p][14]= $freq_matrix[$p][14]+1;
	    }
	    elsif($one_dinucleotide eq "TT"){
		$freq_matrix[$p][15]= $freq_matrix[$p][15]+1;
	    }
	    else{
		print
		    "This looks starnge!  unknown charecter detected!\n";
	    }
	    
	    
	}#for#	
	
	
	
    }#foreach#

#print out data into a file
    open(OUT,">$output_file") or die "Cannot open file $output_file to write results in!\n";
    for(my $r=0; $r<$tag_lengths; $r++){
	for(my $c=0;$c<15; $c++){
	    print OUT
		$freq_matrix[$r][$c].",";
	}#c#
	print OUT 
	    $freq_matrix[$r][15];
	print  OUT
	    	"\n";
    }#r#  
}#GET_FREQ_OF_DINUCLEOTIDE_OVER_TAGS_IN_A_FASTQ_FILE_V4#



##################







sub GET_CHROMOSOME_SEQUENCE($$$){
    my $species      = shift;
    my $chromosome   = shift;
    my $repeat_mask  = shift;
    
    
#get slice adaptor
    my $sa      = $registry->get_adaptor($species,'Core','slice');
    my $slice = $sa->fetch_by_region('chromosome', $chromosome);
    my $sequence;
    if($repeat_mask eq 'true'){
	my $slice_masked  = $slice->get_repeatmasked_seq();
	print STDERR
	    "Repeatmasking, please be patient!\n";
	$sequence = uc($slice_masked->seq());
    }
    else{
	$sequence = uc($slice->seq());
    }
    return $sequence;   
			    }# GET_CHROMOSOME_SEQUENCE#



sub PICK_RANDOM_SUB_REGION_OF_CHROMOSOME($$){
    my $chr_seq    = shift;
    my $length_of_rand_seq  = shift;

    my $rand_seq;
    my $successfull_selection = 'false';
    my $range = length($chr_seq);
    while($successfull_selection ne 'true'){
	my $start_position_upper_bound  = $range - $length_of_rand_seq -1;
	my $start_position              = int( rand( $start_position_upper_bound  )  );
	$rand_seq   = substr($chr_seq,$start_position,$length_of_rand_seq);
	$successfull_selection = 'true';
	if($rand_seq =~ m/N/){
	    $successfull_selection = 'false';
	}
    }
    return $rand_seq;
}#PICK_RANDOM_SUB_REGION_OF_CHROMOSOME#

sub GET_SOME_RAND0M_SEQS_FROM_THE_CHRO_AND_COUNT_FREQ_OF_THIER_INITIAL_DINUCLEOTIDES($$$$$$){
    my $species               = shift;
    my $chro                  = shift;
    my $number_of_random_seqs = shift;
    my $length_of_rand_seqs   = shift;
    my $repeat_masked         = shift;
    my$output_file_name       = shift;

    my $chro_seq = &GET_CHROMOSOME_SEQUENCE($species,$chro, $repeat_masked);
    print
	"fetched the whole chromosome!\n";



	my $AA = 0 ;
	my $AC = 0 ;
	my $AG = 0 ;
	my $AT = 0 ;
	
	my $CA = 0 ;
	my $CC = 0 ;
	my $CG = 0 ;
	my $CT = 0 ;
	
	my $GA = 0 ;
	my $GC = 0 ;
	my $GG = 0 ;
	my $GT = 0 ;
	
	my $TA = 0 ;
	my $TC = 0 ;
	my $TG = 0 ;
	my $TT = 0 ;
	
   
    while($number_of_random_seqs > 0){
	print
	    "$number_of_random_seqs\n";
	my $one_rand_seq = &PICK_RANDOM_SUB_REGION_OF_CHROMOSOME($chro_seq,$length_of_rand_seqs);
	$one_rand_seq = uc($one_rand_seq);
	next if ($one_rand_seq =~ m/N/);
	my $initial_dinucleotide = substr($one_rand_seq,0,2);
		if($initial_dinucleotide eq "AA"){
			$AA++;		
		}
		elsif($initial_dinucleotide eq "AC"){
			$AC++;
		}
		elsif($initial_dinucleotide eq "AG"){
			$AG++;
		}
		elsif($initial_dinucleotide eq "AT"){
			$AT++;
		}
		elsif($initial_dinucleotide eq "CA"){
			$CA++;
		}
		elsif($initial_dinucleotide eq "CC"){
			$CC++
		}
		elsif($initial_dinucleotide eq "CG"){
			$CG++;
		}
		elsif($initial_dinucleotide eq "CT"){
			$CT ++;
		}
		elsif($initial_dinucleotide eq "GA"){
			$GA ++;
		}
		elsif($initial_dinucleotide eq "GC"){
			$GC++;
		}
		elsif($initial_dinucleotide eq "GG"){
			$GG++;
		}
		elsif($initial_dinucleotide eq "GT"){
			$GT++;
		}
		elsif($initial_dinucleotide eq "TA"){
			$TA++;
		}
		elsif($initial_dinucleotide eq "TC"){
			$TC++;
		}
		elsif($initial_dinucleotide eq "TG"){
			$TG++;
		}
		elsif($initial_dinucleotide eq "TT"){
			$TT++;
		}
		else{
			print
			"ooh ha!  unknown charecter detected!\n";
		}




	$number_of_random_seqs--;
}
    open(OUT,">$output_file_name") or die "Cannot open file $output_file_name to write results in!\n";
    print OUT
	"AA\t".$AA."\n".
	"AC\t".$AC."\n".
	"AG\t".$AG."\n".
	"AT\t".$AT."\n".
	"CA\t".$CA."\n".
	"CC\t".$CC."\n".
	"CG\t".$CG."\n".
	"CT\t".$CT."\n".
	"GA\t".$GA."\n".
	"GC\t".$GC."\n".
	"GG\t".$GG."\n".
	"GT\t".$GT."\n".
	"TA\t".$TA."\n".
	"TC\t".$TC."\n".
	"TG\t".$TG."\n".
	"TT\t".$TT."\n";
    close(OUT);
}#GET_SOME_RAND0M_SEQS_FROM_THE_CHRO_AND_COUNT_FREQ_OF_THIER_INITIAL_DINUCLEOTIDES#


sub TEST_MATRIX($$){
    my $nRows   = shift;
    my$nCols    = shift;

    my @matrix;
    for(my$i=0;$i<$nRows;$i++){
	for(my $j=0;$j<$nCols;$j++){
	    $matrix[$i][$j] = $i+$j;
	}
    }

    for(my $i=0;$i<$nRows;$i++){
	for(my $j =0; $j<$nCols; $j++){
	    print
		$matrix[$i][$j]."\t";
	}
	print
	    "\n";
    }
}#TEST_MATRIX#


sub GET_REVCOMP($){
    my $dna_seq  = shift;
    
    my $revcom_seq = reverse $dna_seq;
    $revcom_seq =~ tr/ACGTacgt/TGCAtgca/;
    return $revcom_seq;
		}#GET_REVCOMP#


