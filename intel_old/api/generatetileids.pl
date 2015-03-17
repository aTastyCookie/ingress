#!/usr/bin/perl

use utf8;
use Encode;
use strict;
use POSIX;
use Math::Trig;

sub round {
    my ($number, $places) = @_;
    my $sign = ($number < 0) ? '-' : '';
    my $abs = abs($number);

    if($places < 0) {
        $places *= -1;
        return $sign . substr($abs+("0." . "0" x $places . "5"),
                              0, $places+length(int($abs))+1);
    } else {
        my $p10 = 10**$places;
        return $sign . int($abs/$p10 + 0.5)*$p10;
    }
}

sub zoomToTilesPerEdge 
{
  my ($zoom) = @_;
  my @ZOOM_TO_TILES_PER_EDGE = (32, 32, 32, 32, 256, 256, 256, 1024, 1024, 1536, 4096, 4096, 16384, 16384, 16384);
  my $MAX_TILES_PER_EDGE = 65536;
  my @ZOOM_TO_LEVEL = [8, 8, 8, 8, 7, 7, 7, 6, 6, 5, 4, 4, 3, 2, 2, 1, 1];
  if ($zoom <=15 ) {
    return $ZOOM_TO_TILES_PER_EDGE[$zoom-1];
  }
  else {
    return $MAX_TILES_PER_EDGE;
  }
}


sub lngToTile
{
  my($lng,$level) = @_;
#  return floor(($lng + 180) / 360 * pow(2, $zoom+2));
  return floor(($lng + 180) / 360 * zoomToTilesPerEdge($level));
}
sub latToTile
{
  my($lat,$level) = @_;
#  return floor((1 - log(tan($lat*pi/180)+1/cos($lat*pi/180))/pi)/2*pow(2, $zoom+2));
  return floor((1 - log(tan($lat*pi/180)+1/cos($lat*pi/180))/pi)/2*zoomToTilesPerEdge($level));
}

sub pointToTileId
{
  my($level,$x,$y) = @_;
  return $level."_".$x."_".$y;
}

sub tileToLat
{
  my($y, $level) = @_;
  #my $n = pi-2*pi*$y/pow(2,$zoom+2);
  my $n = pi-2*pi*$y/zoomToTilesPerEdge($level);
  return 180/pi*atan(0.5*(exp($n)-exp(-$n)));
}

sub tileToLng
{
  my($x, $level) = @_;
  #return $x/pow(2,$zoom+2)*360-180;
  return $x/zoomToTilesPerEdge($level)*360 - 180;
}
binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";
my $z=$ARGV[0];
my $x1 = lngToTile($ARGV[2], $z);
my $x2 = lngToTile($ARGV[4], $z);
my $y1 = latToTile($ARGV[3], $z);
my $y2 = latToTile($ARGV[1], $z);
for (my $y = $y1; $y <= $y2; $y++) {
    for (my $x = $x1; $x <= $x2; $x++) {
      my $tile_id = pointToTileId($z, $x, $y);
      my $latNorth = tileToLat($y,$z);
      my $latSouth = tileToLat($y+1,$z);
      my $lngWest = tileToLng($x,$z);
      my $lngEast = tileToLng($x+1,$z);
      print ($tile_id,"\n");
     }
  }
