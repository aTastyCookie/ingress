#!/usr/bin/perl -w
use strict;
use Geo::Distance;
my $geo = new Geo::Distance;
$geo->formula('hsin');
my @pos1 = split(',',$ARGV[0]);
my @pos2 = split(',',$ARGV[1]);
my $lat1 = $pos1[0];
my $lon1 = $pos1[1];
my $lat2 = $pos2[0];
my $lon2 = $pos2[1];

my $distance = $geo->distance( 'meter', $lon1,$lat1 => $lon2,$lat2 );
print int($distance),"\n";
