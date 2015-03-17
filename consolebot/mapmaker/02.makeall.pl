#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
use Data::Dumper;
use Switch;
use utf8;
use bin::Ingress::Portal;
my $portal=new Ingress::Portal;

my $json = decode_json(join '', <>);
my @entities = map { @{$_->{gameEntities}} } values %{$json->{result}{"map"}};
my $n=0;
foreach my $rec (@entities) {
#    print "---------------------\n";
    my ($guid, $time, $entity) = @$rec;
    switch ($guid) {
      case /[0-9a-z]{32}.1[1-6]/ {
#        print 'portal found with guid ',$guid,"\n";
        my $latitude=$entity->{locationE6}{latE6}/1000000;
        my $longitude=$entity->{locationE6}{lngE6}/1000000;
        my $title=$portal->title($entity);
        my $address=$portal->address($entity);
        my $imageUrl=$entity->{imageByUrl}{imageUrl};
        my $team=$entity->{controllingTeam}{team};
        my $capturedTime=$entity->{captured}{capturedTime};
        my $capturingPlayerId=$entity->{captured}{capturingPlayerId};
        $title=~ tr/\r\n\'\"|\’\\\///d;
        $address=~ tr/\r\n\'\"|\’\\\///d;

#        print $guid."\n";
#        print $time."\n";
#        print $latitude."\n";
#        print $longitude."\n";
#        print $title."\n";
#        print $address."\n";
#        print $imgsrc."\n";
        print "['",$title," ",$address,"', ",$latitude,", ",$longitude,", ",$n,"],\n";
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

    #$guid, $time, \%entity
    #my ($turret,$resonatorarray,$location,$controllingTeam,$defaultActionRange,$portalV2) = @$entity;

}
