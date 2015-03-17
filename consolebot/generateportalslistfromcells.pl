#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
use Data::Dumper;
use Switch;
use Geo::Distance;
use bin::Ingress::Portal;
use POSIX;
binmode(STDOUT, ":utf8");
if (!-e $ARGV[0]) {
  print "File $ARGV[0] does not exist \n";
  exit 1;
}

open (FILENEW, "$ARGV[0]");
my $json = decode_json(join '', <FILENEW>);
my %portalsnew;
my $portalsnew=\%portalsnew;
my %portalsl8;
my $portalsl8=\%portalsl8;
#print Dumper(%portalsl8);
my %farms;
my $farms=\%farms;
foreach my $rec (@{$json->{gameBasket}{gameEntities}}) {
#    print "---------------------\n";
    my ($guid, $time, $entity) = @$rec;
    switch ($guid) {
      case /[0-9a-z]{32}.1[1-6]/ {
#        print 'portal found with guid ',$guid,"\n";
        my $latitude=$entity->{locationE6}{latE6}/1000000;
        my $longitude=$entity->{locationE6}{lngE6}/1000000;
        my $imageUrl=$entity->{imageByUrl}{imageUrl};
        my $team=$entity->{controllingTeam}{team};
        my $capturedTime=$entity->{captured}{capturedTime}/1000;
        my $capturingPlayerId=$entity->{captured}{capturingPlayerId};
        my $hashguid="p".$guid;
        $hashguid=~ tr/\.//d;
        $portalsnew->{$hashguid}=$entity;
        $portalsnew->{$hashguid}{guid}=$guid;
      }

      case /[0-9a-z]{32}.9/ {
##        print 'link found with gid ',$guid,"\n";
      }

      case /[0-9a-z]{32}.b/ {
##        print 'field found with gid ',$guid,"\n";
      }

      else {
##        print 'this is neither portal, nor link, nor field, gid: ',$guid,"\n";
      }
    }
}
close (FILENEW);
#---------------------
foreach my $curhash (keys %portalsnew) {
  my $portal=new Ingress::Portal;
  my $portallevel=floor($portal->level($portalsnew->{$curhash}));
  my $portaltitle=$portal->title($portalsnew->{$curhash});
  my $portaladdr=$portal->address($portalsnew->{$curhash});
#  print "level $portallevel \n";
  #my $curdistance=int $geo->distance( 'meter', $lon1,$lat1 => $lon2,$lat2 );
  my $portalownernew=$portalsnew->{$curhash}{captured}{capturingPlayerId};
  my $portalteamnew=$portalsnew->{$curhash}{controllingTeam}{team};
  my $portalhealth=$portal->health($portalsnew->{$curhash});
  my $portalmaxhealth=$portal->maxhealth($portalsnew->{$curhash});
  my $needtorecharge=1;
  if ( $portalhealth eq  $portalmaxhealth ) {$needtorecharge=0};
  my $portalguid=$portalsnew->{$curhash}{guid};
  my $portalnewl8count=0;
  my $resonatorenergynew=0;
  my $portaltitle=$portal->title($portalsnew->{$curhash});
  my $portaladdr=$portal->address($portalsnew->{$curhash});
  my $portallat=$portal->lat($portalsnew->{$curhash});
  my $portallon=$portal->lon($portalsnew->{$curhash});
  my $portalmodcount=$portal->modcount($portalsnew->{$curhash});
  if ($ARGV[1] == 1 ) {
    print "$portallat,$portallon,$portalguid,$portallevel,$portalteamnew,$portalmodcount,$needtorecharge,$portaltitle,$portaladdr\n";
  } 
  else {
    print "$portallat,$portallon,$portalguid,$portallevel,$portalteamnew,$portalmodcount,$needtorecharge\n";
  }
}
