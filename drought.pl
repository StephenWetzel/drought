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
#20070731_ca_date.png
#here, 20070731 is the date, ca is the stateId, and date is the type

my $stateId = "conus"; #set this = "" and it will take the id from the command line
my $type = "date"; #date, none, text
my $baseUrl = "http://droughtmonitor.unl.edu/data/pngs/"; #base url of the png files
my $delay = 3; #gif delay


if (!$stateId) {$stateId = $ARGV[0];} #grab id from command line if passed
my $temp;
my $dir = "data.$stateId/";
my $datesDump = "dates.txt"; #filename of dates file
my @fileArray; #stores lines of input files
my $thisLine; #store individual lines of input file in for loops
my @dates; #all the valid dates

if (!-d $dir) {mkdir $dir;} #a directory for the data files

$temp = "lynx -dump -width=9999 -nolist \"$baseUrl\" > $datesDump";
if (!$testing) {system($temp);} #download page when not testing

open my $ifile, '<', $datesDump;
@fileArray = <$ifile>;
close $ifile;
foreach $thisLine (@fileArray)
{#go through the linx dump, gather data
	#  2/3/2014  9:51 AM        <dir> 20000118
	if ($thisLine =~ m/<dir> (\d{8})/)
	{#this line should contain a date
		push @dates, $1;
	}
}

foreach my $date (@dates)
{#go through dates, download the pngs
	#http://droughtmonitor.unl.edu/data/pngs/20070731/20070731_ca_date.png
	my $url = "$baseUrl$date/${date}_${stateId}_$type.png";
	
	$temp = "wget -N -P $dir $url";
	if (!$testing) {system($temp);} #download page when not testing
	else {print "\n$temp";}
	
}

#create gif with ImageMagick
`convert -delay $delay -loop 0 $dir*.png $stateId.gif`;


print "\nDone\n\n";
