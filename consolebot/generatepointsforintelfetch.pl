#!/usr/bin/perl

use utf8;
use Encode;
use strict;
use POSIX;
use Math::Trig;
use JSON::XS;
my  %mungs = 
(
      'dashboard_getGameScore' =>  'ija9jgrf5hj7wm9r',          #// GET_GAME_SCORE
      'dashboard_getPaginatedPlextsV2' =>  '0elftx739mkbzi1b',  #// GET_PAGINATED_PLEXTS
      'dashboard_getThinnedEntitiesV4' =>  'prv0ez8cbsykh63g',  #// GET_THINNED_ENTITIES
      'dashboard_getPlayersByGuids' =>  'i0lxy6nc695z9ka3',     #// LOOKUP_PLAYERS
      'dashboard_redeemReward' =>  '376oivna8rf8qbfj',          #// REDEEM_REWARD
      'dashboard_sendInviteEmail' =>  '96y930v5q96nrcrw',       #// SEND_INVITE_EMAIL
      'dashboard_sendPlext' =>  'c04kceytofuqvyqg',             #// SEND_PLEXT
      'method'=> '9we4b31i48ui4sdm',
      'version' => 'q402kn5zqisuo1ym',
      'version_parameter' => 'dbad4485024d446ae946e3d287b5d640029ef3e3',
      'boundsParamsList'=> '3r5ctyvc2f653zjd',
      'id'=> 'izey8ciqg2dz2oqc', 
      'minLatE6'=> 'cein0n4jrifa7ui2', 
      'minLngE6'=> 'lbd1juids3johtdo', 
      'maxLatE6'=> 'h4kyot9kmvd3g284', 
      'maxLngE6'=> 'sbci6jjc2d5g9uy4', 
      'timestampMs'=> '2wurn9giagbvv6bt', 
      'qk'=> 'hq73mwpjqyvcp6ul', 
      'desiredNumItems'=> 'kyo6vh5n58hmrnua', 
      'minTimestampMs'=> 'hu4swdftcp7mvkdi', 
      'maxTimestampMs'=> 'ly6ylae5lv1z9072', 
      'chatTab' =>  'q5kxut5rmbtlqbf9', #//guessed parameter name - only seen munged
      'ascendingTimestampOrder' =>  'hvfd0io35rahwjgr',
      'message' =>  'z4hf7tzl27o14455',
      'latE6' =>  'zyzh3bdxyd47vk1x',
      'lngE6' =>  'n5d1f8pql51t641x',
      'guids' =>  'gl16ehqoc3i3oi07',
      'inviteeEmailAddress' =>  'orc9ufg7rp7g1y9j',
      'factionOnly'=> 'p88a2ztchtjhiazl', 
);
my $mungs=\%mungs;
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

sub lngToTile
{
  my($lng,$zoom) = @_;
  return floor(($lng + 180) / 360 * pow(2, $zoom+2));
}
sub latToTile
{
  my($lat,$zoom) = @_;
  return floor((1 - log(tan($lat*pi/180)+1/cos($lat*pi/180))/pi)/2*pow(2, $zoom+2));
}

sub pointToTileId
{
  my($zoom,$x,$y) = @_;
  return $zoom."_".$x."_".$y;
}

sub tileToLat
{
  my($y, $zoom) = @_;
  my $n = pi-2*pi*$y/pow(2,$zoom+2);
  return 180/pi*atan(0.5*(exp($n)-exp(-$n)));
}

sub tileToLng
{
  my($x, $zoom) = @_;
  return $x/pow(2,$zoom+2)*360-180;
}
sub generateBoundsParams
{
  my ($tile_id, $minLat, $minLng, $maxLat, $maxLng) = @_;
  my %request;
  my $request=\%request;
  $request->{$mungs{maxLngE6}}=int round($maxLng*1E6);
  $request->{$mungs{maxLatE6}}=int round($maxLat*1E6);
  $request->{$mungs{minLngE6}}=int round($minLng*1E6);
  $request->{$mungs{id}}=$tile_id;
  $request->{$mungs{minLatE6}}=int round($minLat*1E6);
  my $LAT=($maxLat+$minLat)/2;
  my $LON=($maxLng+$minLng)/2;
  print "$LAT,$LON\n";
  $request->{$mungs{qk}}=$tile_id;
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
      my %payload;
      my $payload=\%payload;
    # broken in V4      $payload->{zoom}=int $z;
    #brokein in V5  $payload->{$mungs{boundsParamsList}}[0]=$boundsParam;
    #broken  in V5 $payload->{$mungs{method}}="dashboard.getThinnedEntitiesV4";
    $payload->{$mungs{method}}="$mungs{dashboard_getThinnedEntitiesV4}";
    $payload->{$mungs{desiredNumItems}}=49;
    $payload->{$mungs{maxLngE6}}=180000000;
    $payload->{$mungs{minLngE6}}=-180000000;
    $payload->{$mungs{maxLatE6}}=90000000;
    $payload->{$mungs{minLatE6}}=-90000000;
    $payload->{$mungs{maxTimestampMs}}=time*1000;
    $payload->{$mungs{minTimestampMs}}=0;
    $payload->{$mungs{version}}="$mungs{version_parameter}";
    $payload->{$mungs{boundsParamsList}}[0]=$boundsParam;
      my $json_payload    = JSON::XS->new->canonical(0)->encode($payload);
      open (PAYLOAD, ">tiles/$boundsParam->{$mungs{id}}");
      binmode(PAYLOAD, ":utf8");
      print PAYLOAD $json_payload;
      close(PAYLOAD);
#      print $json_payload,"\n";
     }

  }
