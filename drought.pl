#!/usr/bin/perl
#Drought GIF creator by Stephen Wetzel Aug 08 2014
#Grabs imdb ratings and generate graphs
#requires lynx and ImageMagick
#http://droughtmonitor.unl.edu/

use strict;
use warnings;
use autodie;

#$|++; #autoflush disk buffer

my $time = time;

my $testing = 0; #set to 1 to prevent actual downloading, 0 normally
my $stateId = ""; #set this = "" and it will take the id from the command line

if (!$stateId) {$stateId = $ARGV[0];} #grab id from command line if passed

my $dir = "data.$stateId/";
mkdir $dir; #a directory for the data files

my $datesUrl = "http://droughtmonitor.unl.edu/data/pngs/"; #this url lists all the dates
my $datesDump = "dates.txt";

my @fileArray; #stores lines of input files
my $thisLine; #store individual lines of input file in for loops

#lynx -dump -width=9999 -nolist "http://www.imdb.com/title/tt0106145/eprate" >dump.txt
$temp = "lynx -dump -width=9999 -nolist \"$datesUrl\" > $datesDump";
if (!$testing) {system($temp);} #download page when not testing
if ($testing) {$datesDump = "dump.txt";} #if testing use saved page

open my $ifile, '<', $datesDump;
@fileArray = <$ifile>;
close $ifile;
foreach $thisLine (@fileArray)
{#go through the linx dump, gather data
	#   IMDb > "Star Trek: The Next Generation" (1987)
	if ($thisLine =~ m/\s+IMDb\s\>\s\"(.+?)\"\s+/)
	{#this line should contain title
		$title = $1;
		print "\nTitle:'$title'";
	}
}


open my $ofile, '>', $allEpisodesFile;
for (my $i=1; $i <= $numEpisodes; $i++)
{#go through each episode
	print $ofile "$temp \t$stats[$i][3]\n";
}
close $ofile;



print "\nDone\n\n";
