#!/usr/bin/env perl

# 6-25-10 version edited on 8-12-10 
# 8-12-10 use to convert various eol characters to the unix defaults
# 9-29-10 this version edited from 6-25-10 version
use strict;
use warnings;
use Getopt::Long;

my $input_file    = "input.file"; # expected is md5."\t".count."\t".seq_id(i)."\s"... for seq_id i to n, the number of reads in the bin
my $verbose       = 0;
my $help          = "0";
my $arguments     =     $ARGV[0];

GetOptions ("i|input_file=s"  => \$input_file,
	    "o|output_file=s" => \$output_file,
	    "h|help"          => \$help,
	    "v|verbose"       => \$verbose);  # flag

# sub usage, provides the usage information if -help is called, or if no input argument is specified (see two if's directly below)
sub usage {
  print "\n"."DESCRIPTION (line_term.pl):"."\n".
      "places trailing , on lines of *.json that are missing them"."\n";
  print "\n"."USAGE: [-i infile] [-o outfile] [-h] [-v]"."\n"."\n".
      "     -i|input_file  (required, default = input.file)     string, name of the input file"."\n".
      "     -h|help        (option)"."\n".
      "     -v|verbose     (option)"."\n"."\n";	
  exit;
}

if ($help){ # Kevin - this works if you call help like this "-help", as you would any other long option 3-10-10
     &usage;
}

# supply the usage if the scripted is called with no arguments
unless($arguments){ # Kevin solution 3-10-10
     &usage
}

open(INPUT_FILE, "<", $input_file) or die "Couldn't open INPUT_FILE $input_file"."\n";
open(OUTPUT_FILE, ">", $output_file.".scrubbed_json") or die "Couldn't open OUTPUT_FILE $output_file"."\n";

while (my $line = <INPUT_FILE>){          

  unless ( $line =~ m/^\{/ ){
    unless ( $line =~ m/^\}/ ){
    
      if ( $line =~ m/[,]$/ ){
	print OUTPUT_FILE $line.",";
      }else{
	print $line;
      }   

    }
  }
}

close(INPUT_FILE);
close(OUTPUT_FILE);

# # if the output is "default", replaces the old file with a new one with the same name
# if( $output_file eq "default"  ){
#   unlink($input_file); # delete input
#   my $move_string="mv ".$output_file." ".$input_file; # rename the output with the input filename
#   system($move_string);
# }
