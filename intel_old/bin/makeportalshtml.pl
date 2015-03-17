#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
use Data::Dumper;
use Switch;
use utf8;
binmode STDOUT, ":utf8";
my $bluehtml="setblueMarkers(map, bluebeaches);
      }
      /**
       * Data for the markers consisting of a name, a LatLng and a zIndex for
       * the order in which these markers should display on top of each
       * other.
       */
      var bluebeaches = [\n";

my $greenhtml="setgreenMarkers(map, greenbeaches);
      }
      /**
       * Data for the markers consisting of a name, a LatLng and a zIndex for
       * the order in which these markers should display on top of each
       * other.
       */
      var greenbeaches = [\n";
my $neutralhtml="setneutralMarkers(map, neutralbeaches);
      }
      /**
       * Data for the markers consisting of a name, a LatLng and a zIndex for
       * the order in which these markers should display on top of each
       * other.
       */
      var neutralbeaches = [\n";
#print $htmlheader;
my $json = decode_json(join '', <>);
my @entities = map { @{$_->{gameEntities}} } values %{$json->{result}{"map"}};
my $nn=0;
my $ng=0;
my $nb=0;
foreach my $rec (@entities) {
#    print "---------------------\n";
    my ($guid, $time, $entity) = @$rec;
    switch ($guid) {
      case /[0-9a-z]{32}.1[1-6]/ {
#        print 'portal found with guid ',$guid,"\n";
        my $latitude=$entity->{latE6}/1000000;
        my $longitude=$entity->{lngE6}/1000000;
        my $title=$entity->{map}{TITLE};
        my $address=$entity->{map}{ADDRESS};
        my $imageUrl=$entity->{imageByUrl}{imageUrl};
        my $team=$entity->{team};
        my $capturedTime=$entity->{captured}{capturedTime};
        #print $entity->{portalV2}{resonatorArray}{resonators}[0]{level},"\n";
        my $capturingPlayerId=$entity->{captured}{capturingPlayerId};
        my $portallevel=$entity->{level};
        $title=~ tr/\r\n\'\"|\’\\\///d;
        $address=~ tr/\r\n\'\"|\’\\\///d;
        chomp($title);
        chomp($address);
#        print $guid."\n";
#        print $time."\n";
#        print $latitude."\n";
#        print $longitude."\n";
#        print $title."\n";
#        print $address."\n";
#        print $imgsrc."\n";
         $title="L".$portallevel." ".$title;
         if ( $portallevel > 0 ) {
         if ( $address !=~ m/Belkarus/ ) {
           if ( $address =~ m/Miknsk/ ) {
           }
           else {
         if ( $team eq 'NEUTRAL') {
           $neutralhtml=$neutralhtml."['".$title.", ".$address."', ".$latitude.", ".$longitude.", ".$nn."],\n";
           $nn++;
         }
         if ($team eq 'RESISTANCE' ) {
         $bluehtml=$bluehtml."['".$title.", ".$address."', ".$latitude.", ".$longitude.", ".$nb."],\n";
         $nb++;
         }
         if ($team eq 'ENLIGHTENED' ) {
         $greenhtml=$greenhtml."['".$title.", ".$address."', ".$latitude.", ".$longitude.", ".$ng."],\n";
         $ng++;
         }
         if ($team eq 'ALIENS' ) {
         $greenhtml=$greenhtml."['".$title.", ".$address."', ".$latitude.", ".$longitude.", ".$ng."],\n";
         $ng++;
         }
         }
      }
      }
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
#print $htmlfooter;
$bluehtml=$bluehtml."];

      function setblueMarkers(map, locations) {
        var image = {
          url: 'images/blue.png',
          // This marker is 20 pixels wide by 32 pixels tall.
          size: new google.maps.Size(30, 30),
          // The origin for this image is 0,0.
          origin: new google.maps.Point(0,0),
          // The anchor for this image is the base of the flagpole at 0,32.
          anchor: new google.maps.Point(15, 15)
        };
        var shape = {
            coord: [1, 1, 1, 20, 18, 20, 18 , 1],
            type: 'poly'
        };
        for (var i = 0; i < locations.length; i++) {
          var beach = locations[i];
          var myLatLng = new google.maps.LatLng(beach[1], beach[2]);
          var marker = new google.maps.Marker({
              position: myLatLng,
              map: map,
              icon: image,
              shape: shape,
              title: beach[0],
              zIndex: beach[3]
          });
        }";
$greenhtml=$greenhtml."];

      function setgreenMarkers(map, locations) {
        var image = {
          url: 'images/green.png',
          // This marker is 20 pixels wide by 32 pixels tall.
          size: new google.maps.Size(30, 30),
          // The origin for this image is 0,0.
          origin: new google.maps.Point(0,0),
          // The anchor for this image is the base of the flagpole at 0,32.
          anchor: new google.maps.Point(15, 15)
        };
        var shape = {
            coord: [1, 1, 1, 20, 18, 20, 18 , 1],
            type: 'poly'
        };
        for (var i = 0; i < locations.length; i++) {
          var beach = locations[i];
          var myLatLng = new google.maps.LatLng(beach[1], beach[2]);
          var marker = new google.maps.Marker({
              position: myLatLng,
              map: map,
              icon: image,
              shape: shape,
              title: beach[0],
              zIndex: beach[3]
          });
        }";
$neutralhtml=$neutralhtml."];

      function setneutralMarkers(map, locations) {
        var image = {
          url: 'images/neutral.png',
          // This marker is 20 pixels wide by 32 pixels tall.
          size: new google.maps.Size(30, 30),
          // The origin for this image is 0,0.
          origin: new google.maps.Point(0,0),
          // The anchor for this image is the base of the flagpole at 0,32.
          anchor: new google.maps.Point(15, 15)
        };
        var shape = {
            coord: [1, 1, 1, 20, 18, 20, 18 , 1],
            type: 'poly'
        };
        for (var i = 0; i < locations.length; i++) {
          var beach = locations[i];
          var myLatLng = new google.maps.LatLng(beach[1], beach[2]);
          var marker = new google.maps.Marker({
              position: myLatLng,
              map: map,
              icon: image,
              shape: shape,
              title: beach[0],
              zIndex: beach[3]
          });
        }";
print $neutralhtml;
print $bluehtml;
print $greenhtml;
