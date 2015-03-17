#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
use Data::Dumper;
use Switch;
use Geo::Distance;
use utf8;
my $geo = new Geo::Distance;
$geo->formula('hsin');
binmode STDOUT, ":utf8";
my $json = decode_json(join '', <>);
my @entities = map { @{$_->{gameEntities}} } values %{$json->{result}{"map"}};
my $n=0;
foreach my $rec (@entities) {
#    print "---------------------\n";
    my ($guid, $time, $entity) = @$rec;
    switch ($guid) {
      case /[0-9a-z]{32}.1[1-6]/ {

      } 
      
      case /[0-9a-z]{32}.9/ {
        my $teamcolor="#000000";
        my $team=$entity->{team};
        my $linksrclatitude=$entity->{oLatE6}/1000000;
        my $linksrclongitude=$entity->{oLngE6}/1000000;
        my $linkdstlatitude=$entity->{dLatE6}/1000000;
        my $linkdstlongitude=$entity->{dLngE6}/1000000;
        my $dGuid=$entity->{dGuid};
        my $oGuid=$entity->{oGuid};
        if ($team eq "RESISTANCE") {
           my $distance = $geo->distance( 'meter', $linksrclongitude,$linksrclatitude, => $linkdstlongitude,$linkdstlatitude);
           if ($distance > 5000) {
             print "$linksrclatitude,$linksrclongitude,$oGuid,$distance\n";
             print "$linkdstlatitude,$linkdstlongitude,$dGuid,$distance\n";
           }
         }
#        print $team,$teamcolor,"\n";
        $guid=~ tr/\.//d;
        $guid="g".$guid;


##        print 'link found with guid ',$guid,"\n";
      }

      case /[0-9a-z]{32}.b/ {
##        print 'field found with guid ',$guid,"\n";
      }
      
      else {
##        print 'this is neither portal, nor link, nor field, guid: ',$guid,"\n";
      }
    }

    #$guid, $time, \%entity
    #my ($turret,$resonatorarray,$location,$controllingTeam,$defaultActionRange,$portalV2) = @$entity;

}
