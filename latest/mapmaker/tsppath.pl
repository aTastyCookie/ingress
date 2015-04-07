#!/usr/bin/perl -w
use strict;
use POSIX;
use Geo::Distance;
my $geo = new Geo::Distance;
$geo->formula('hsin');
open (FILE, "minsk.linkern");
my @solution;
while(my $line = <FILE>){
    chomp $line;
    my @linearray = split(",", $line);
    push(@solution, \@linearray);
}
close (FILE);

open (FILE, "minsk.coordswithpgid");
my @indexarray;
while(my $line = <FILE>){
    chomp $line;
    my @linearray = split(",", $line);
    push(@indexarray, \@linearray);
}
close (FILE);

foreach (@solution) {
  my $indexfromnu=$_->[0];
  my $indextonu=$_->[1];
  my $latfrom=$indexarray[$indexfromnu][0];
  my $lonfrom=$indexarray[$indexfromnu][1];
  my $latto=$indexarray[$indextonu][0];
  my $lonto=$indexarray[$indextonu][1];
  my $pguid=$indexarray[$indextonu][2];
  my $distance = $geo->distance( 'meter', $lonfrom,$latfrom => $lonto,$latto );
  my $sleepdelay = ceil(70*$distance/1000);
  print "$latto,$lonto,$sleepdelay,$pguid\n";
}


exit 0

#my @pos1 = split(',',$ARGV[0]);
#my @pos2 = split(',',$ARGV[1]);
#my $lat1 = $pos1[0];
#my $lon1 = $pos1[1];
#my $lat2 = $pos2[0];
#my $lon2 = $pos2[1];
#
#my $distance = $geo->distance( 'meter', $lon1,$lat1 => $lon2,$lat2 );
#print int($distance),"\n";
