#!/usr/bin/perl

use utf8;
use Encode;
use strict;
use POSIX;
use Math::Trig;
use JSON::XS;
my %mungs;

open MUNGS, "mungs.inc.pl" or die;
while (my $line=<MUNGS>) {
     chomp($line);
     (my $hashname,my $hashvalue) = split /=/, $line;
     $mungs{$hashname} = $hashvalue;
}

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
  my @ZOOM_TO_TILES_PER_EDGE = (32, 32, 32, 32, 256, 256, 256, 1024, 1024, 1536, 4096, 4096, 6500, 6500, 6500);
  my $MAX_TILES_PER_EDGE = 9000;
  my @ZOOM_TO_LEVEL = [8, 8, 8, 8, 7, 7, 7, 6, 6, 5, 4, 4, 3, 2, 2, 1, 1];
  if ($zoom <=15 ) {
    return $ZOOM_TO_TILES_PER_EDGE[$zoom];
  }
  else {
    return $MAX_TILES_PER_EDGE;
  }
}

sub portalLevel
{
  my ($zoom) = @_;
  my @ZOOM_TO_LEVEL = [8, 8, 8, 8, 7, 7, 7, 6, 6, 5, 4, 4, 3, 2, 2, 1, 1];
  return $ZOOM_TO_LEVEL[0][$zoom];
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
  $level--;
  my $plevel = portalLevel($level);
  return $level."_".$x."_".$y."_".$plevel."_8_100";
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
sub generateBoundsParams
{
  my ($tile_id, $minLat, $minLng, $maxLat, $maxLng) = @_;
#  my %request;
#  my $request=\%request;
   my @request;
   my $request=\@request;
#  $request->{$mungs{maxLngE6}}=int round($maxLng*1E6);
#  $request->{$mungs{maxLatE6}}=int round($maxLat*1E6);
#  $request->{$mungs{minLngE6}}=int round($minLng*1E6);
#  $request->{$mungs{id}}=$tile_id;
#  $request->{$mungs{minLatE6}}=int round($minLat*1E6);
#  $request->{$mungs{qk}}=$tile_id;
   $request[0]=$tile_id;
  my $json_string    = encode_json($request);
  return $request;
}
binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";
my $z=$ARGV[0];
#my $x1 = lngToTile(27.37, $z);
#my $x2 = lngToTile(27.75, $z);
#my $y1 = latToTile(54.02, $z);
#my $y2 = latToTile(53.78, $z);
my $x1 = lngToTile($ARGV[2], $z);
my $x2 = lngToTile($ARGV[4], $z);
my $y1 = latToTile($ARGV[3], $z);
my $y2 = latToTile($ARGV[1], $z);
my $boundcount=0;
my %payload;
my $payload=\%payload;
my $json_payload;
for (my $y = $y1; $y <= $y2; $y++) {
    for (my $x = $x1; $x <= $x2; $x++) {
      my $tile_id = pointToTileId($z, $x, $y);
      my $latNorth = tileToLat($y,$z);
      my $latSouth = tileToLat($y+1,$z);
      my $lngWest = tileToLng($x,$z);
      my $lngEast = tileToLng($x+1,$z);
#      print "$latNorth,$latSouth,$lngWest,$lngEast \n";

#      debugCreateTile(tile_id,[[latSouth,lngWest],[latNorth,lngEast]]);

        my $boundsParam = generateBoundsParams(
          $tile_id,
          $latSouth,
          $lngWest,
          $latNorth,
          $lngEast
        );
      my ($tile_id, $minLat, $minLng, $maxLat, $maxLng) = @_;
    # broken in V4      $payload->{zoom}=int $z;
    #brokein in V5  $payload->{$mungs{boundsParamsList}}[0]=$boundsParam;
    #broken  in V5 $payload->{$mungs{method}}="dashboard.getThinnedEntitiesV4";
    $payload->{$mungs{method}}="$mungs{getThinnedEntities}";
    $payload->{$mungs{desiredNumItems}}=2000;
    $payload->{$mungs{maxLngE6}}=180000000;
    $payload->{$mungs{minLngE6}}=-180000000;
    $payload->{$mungs{maxLatE6}}=90000000;
    $payload->{$mungs{minLatE6}}=-90000000;
    $payload->{$mungs{version}}="$mungs{version_parameter}";
    $payload->{$mungs{quadKeys}}[$boundcount]=@{$boundsParam}[0];
    $boundcount++;
    $json_payload    = JSON::XS->new->canonical(0)->encode($payload);
     }
  }
#print "$ARGV[1],$ARGV[2],$ARGV[3],$ARGV[4]\n";
open (PAYLOAD, ">tiles/$ARGV[0]_$ARGV[1]_$ARGV[2]_$ARGV[3]_$ARGV[4]");
binmode(PAYLOAD, ":utf8");
print PAYLOAD $json_payload;
close(PAYLOAD);
