#!/usr/bin/perl -w
use strict;
use Geo::Distance;
use List::Util qw (minstr);
use Data::Dumper;
my $startpoint=$ARGV[1];
my $previouspoint=$startpoint;
open (FILE, "$ARGV[0]");
my @PORTALS = <FILE>;
close FILE;
#print $portalcount;
@PORTALS=grep {!/$startpoint/} @PORTALS;
my $portalcount=scalar(@PORTALS);
#print $portalcount;
my @shortestpath;
for (my $count=0; $count<$portalcount; $count++)
{
  my %hash;
  foreach my $CURPOS (@PORTALS) {
     chomp($CURPOS);
     #print $CURPOS->[0],"\n";
     my $currentpoint=$CURPOS;
     my @pos1 = split(',',$previouspoint);
     my @pos2 = split(',',$currentpoint);
     my $lat1 = $pos1[0];
     my $lon1 = $pos1[1];
     my $lat2 = $pos2[0];
     my $lon2 = $pos2[1];
     my $geo = new Geo::Distance;
     my $curdistance=int $geo->distance( 'meter', $lon1,$lat1 => $lon2,$lat2 );
     $hash{$currentpoint} = $curdistance;
     #  print "distance between ".$previouspoint." and ".$currentpoint." is ";
     #print $curdistance,"\n";
   }

#   print Dumper(%hash);
#   print "\n";
   my $hashkeymin = (sort {$hash{$a} <=> $hash{$b}} keys %hash)[0];
   #print $hash{$hashkeymin};
   push (@shortestpath,$hashkeymin,$hash{$hashkeymin});
   $previouspoint=$hashkeymin;
   @PORTALS=grep {!/$previouspoint/} @PORTALS;
   %hash = ();
}
my $count;
print $ARGV[1],"\n";
for ($count=0; $count<$portalcount; $count++)
{ 
  print $shortestpath[$count*2];
  print ",",$shortestpath[$count*2+1],"\n";

}
exit 0;
#we don't need first point to last anymore since we are randomizing route every round
print $ARGV[1];
my @pos1 = split(',',$shortestpath[$count*2-2]);
my @pos2 = split(',',$ARGV[1]);
my $lat1 = $pos1[0];
my $lon1 = $pos1[1];
my $lat2 = $pos2[0];
my $lon2 = $pos2[1];
my $geo = new Geo::Distance;
my $curdistance=$geo->distance( 'meter', $lon1,$lat1 => $lon2,$lat2 );
print ",",int($curdistance),"\n";
