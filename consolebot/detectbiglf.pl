#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
use Data::Dumper;
use Switch;
use DateTime;
no warnings;
use Geo::Distance;
use POSIX;

my $geo = new Geo::Distance;
$geo->formula('hsin');

binmode(STDOUT, ":utf8");
my $json = decode_json(join '', <>);
my $result=$json->{result};
#print Dumper($result), length($result), "\n";
#print Dumper(%{$json});
#print %{$json->{result}};
foreach my $curmessageref  (@$result) {
#  print Dumper($curmessageref), "\n";
  my $msguid=@$curmessageref[0];
  my $msgts=int(@$curmessageref[1]/1000);
  my $msgdate=scalar localtime($msgts);
  my $msgplextxref=@$curmessageref[2];
  my $msgsendertype=%{$msgplextxref}->{plext}->{plextType};
  my $msgsenderteam=%{$msgplextxref}->{plext}->{team};
  switch ($msgsendertype) {
    case /SYSTEM_BROADCAST/ {
      my $msgplaintext=%{$msgplextxref}->{plext}->{text};
      #print "$msgplaintext \n";
      $msgplaintext=~ tr/"//d;
      switch ($msgplaintext) {
        case /^(.*)deployed(.*)$/ {
          my $eventtype="resdeploy";
          my $playerguid=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{guid};
          my $playername=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{plain};
          my $resonatorlevel=%{%{$msgplextxref}->{plext}->{markup}[2][1]}->{plain};
          $resonatorlevel=~ tr/L//d;
          my $portalguid=%{%{$msgplextxref}->{plext}->{markup}[4][1]}->{guid};
          #print "REPLACE INTO syscomm values (\"$msguid\",$msgts,\"$msgsenderteam\",\"$msgsendertype\",\"$playerguid\",\"$msgplaintext\",\"$eventtype\",\"$resonatorlevel\",\"$portalguid\");\n";
        }
        case /^(.*)destroyed an (.*)Resonator(.*)$/ {
          my $eventtype="resdestroy";
          my $playerguid=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{guid};
          my $playername=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{plain};
          my $resonatorlevel=%{%{$msgplextxref}->{plext}->{markup}[2][1]}->{plain};
          $resonatorlevel=~ tr/L//d;
          my $portalguid=%{%{$msgplextxref}->{plext}->{markup}[4][1]}->{guid};
          #print "REPLACE INTO syscomm values (\"$msguid\",$msgts,\"$msgsenderteam\",\"$msgsendertype\",\"$playerguid\",\"$msgplaintext\",\"$eventtype\",\"$resonatorlevel\",\"$portalguid\");\n";
        }
        case /^(.*)destroyed the Link(.*)$/ {
          my $eventtype="linkdestroy";
          my $playerguid=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{guid};
          my $playername=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{plain};
          my $resonatorlevel=0;
          my $portalguid=%{%{$msgplextxref}->{plext}->{markup}[2][1]}->{guid};
          my $linksrclatitude=%{%{$msgplextxref}->{plext}->{markup}[2][1]}->{latE6}/1000000;                                                                                             
          my $linksrclongitude=%{%{$msgplextxref}->{plext}->{markup}[2][1]}->{lngE6}/1000000;                                                                                            
          my $linkdstlatitude=%{%{$msgplextxref}->{plext}->{markup}[4][1]}->{latE6}/1000000;                                                                                             
          my $linkdstlongitude=%{%{$msgplextxref}->{plext}->{markup}[4][1]}->{lngE6}/1000000;                                                                                            
          my $team=$msgplextxref->{plext}{team};                                                                                                                                         
          my $distance = $geo->distance( 'meter', $linksrclongitude,$linksrclatitude, => $linkdstlongitude,$linkdstlatitude);                                                            
          if ($distance > 50000) {                                                                                                                                                       
             $distance=floor($distance/1000);                                                                                                                                            
             #print "$team,$linksrclatitude,$linksrclongitude,$linkdstlatitude,$linkdstlongitude,$distance\n";                                                                           
             print "$msgdate $team $msgplextxref->{plext}{text} ,$distance km length\n";
             if ( $msgplextxref->{plext}{text} =~ m/Belarus/ ) {
               my $sendresult=`bin/sendskype.sh "$msguid $msgdate $team $msgplextxref->{plext}{text} ,$distance km length"`;
             }
          }                                                                                       
          print "$msgdate $team,$linksrclatitude,$linksrclongitude,$linkdstlatitude,$linkdstlongitude,$distance\n";
          #print "REPLACE INTO syscomm values (\"$msguid\",$msgts,\"$msgsenderteam\",\"$msgsendertype\",\"$playerguid\",\"$msgplaintext\",\"$eventtype\",\"$resonatorlevel\",\"$portalguid\");\n";
        }
        case /^(.*)linked(.*)$/ {
          my $eventtype="linkcreate";
          my $playerguid=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{guid};
          my $playername=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{plain};
          my $resonatorlevel=0;
          my $portalsrcguid=%{%{$msgplextxref}->{plext}->{markup}[2][1]}->{guid};
          my $portaldstguid=%{%{$msgplextxref}->{plext}->{markup}[4][1]}->{guid};
          my $linksrclatitude=%{%{$msgplextxref}->{plext}->{markup}[2][1]}->{latE6}/1000000;
          my $linksrclongitude=%{%{$msgplextxref}->{plext}->{markup}[2][1]}->{lngE6}/1000000;
          my $linkdstlatitude=%{%{$msgplextxref}->{plext}->{markup}[4][1]}->{latE6}/1000000;
          my $linkdstlongitude=%{%{$msgplextxref}->{plext}->{markup}[4][1]}->{lngE6}/1000000;
          my $team=$msgplextxref->{plext}{team};
          my $distance = $geo->distance( 'meter', $linksrclongitude,$linksrclatitude, => $linkdstlongitude,$linkdstlatitude);
          if ($distance > 50000) {
             $distance=floor($distance/1000);
             #print "$team,$linksrclatitude,$linksrclongitude,$linkdstlatitude,$linkdstlongitude,$distance\n";
             print "$msgdate $team $msgplextxref->{plext}{text} ,$distance km length\n";
             if ( $msgplextxref->{plext}{text} =~ m/Belarus/ ) {
               my $result=`echo $linksrclatitude,$linksrclongitude,portalkeyguid,$portalsrcguid,$portaldstguid >> /var/log/link.log`;
               my $result=`echo $linksrclatitude,$linksrclongitude,$portalsrcguid >> /var/log/flip.log`;
               my $result=`echo $linkdstlatitude,$linkdstlongitude,$portaldstguid >> /var/log/flip.log`;
               my $sendresult=`bin/sendskype.sh "$msguid $msgdate $team $msgplextxref->{plext}{text} ,$distance km length"`;
             }
             my $copyresult=`cp response/getPaginatedPlexts gpp`;
          }
 
            
          #print "REPLACE INTO syscomm values (\"$msguid\",$msgts,\"$msgsenderteam\",\"$msgsendertype\",\"$playerguid\",\"$msgplaintext\",\"$eventtype\",\"$resonatorlevel\",\"$portalguid\");\n";
        }
        case /^(.*)created a Control Field (.*)$/ {
          my $eventtype="fieldcreate";
          my $playerguid=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{guid};
          my $playername=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{plain};
          my $resonatorlevel=0;
          my $portalguid=%{%{$msgplextxref}->{plext}->{markup}[2][1]}->{guid};
          my $fieldmu=%{%{$msgplextxref}->{plext}->{markup}[4][1]}->{plain};
          my $fieldlat=%{%{$msgplextxref}->{plext}->{markup}[2][1]}->{latE6}/1000000;
          my $fieldlon=%{%{$msgplextxref}->{plext}->{markup}[2][1]}->{lngE6}/1000000;
          my $team=$msgplextxref->{plext}{team};
          if ($fieldmu > 150000) {
            print "$msgdate $team $msgplextxref->{plext}{text} at $fieldlat,$fieldlon\n";
            if ( $msgplextxref->{plext}{text} =~ m/Belarus/ ) {
              my $sendresult=`bin/sendskype.sh "$msguid $msgdate $team $msgplextxref->{plext}{text} at $fieldlat,$fieldlon"`;
            }
          }
        }


        case /^(.*)destroyed a Control Field (.*)$/ {
          my $eventtype="fielddestroy";
          my $playerguid=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{guid};
          my $playername=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{plain};
          my $resonatorlevel=0;
          my $portalguid=%{%{$msgplextxref}->{plext}->{markup}[2][1]}->{guid};
          #print "REPLACE INTO syscomm values (\"$msguid\",$msgts,\"$msgsenderteam\",\"$msgsendertype\",\"$playerguid\",\"$msgplaintext\",\"$eventtype\",\"$resonatorlevel\",\"$portalguid\");\n";
        }

        case /^(.*)captured(.*)$/ {
          my $eventtype="portalcapture";
          my $playerguid=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{guid};
          my $playername=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{plain};
          my $resonatorlevel=0;
          my $portalguid=%{%{$msgplextxref}->{plext}->{markup}[2][1]}->{guid};
          #print "REPLACE INTO syscomm values (\"$msguid\",$msgts,\"$msgsenderteam\",\"$msgsendertype\",\"$playerguid\",\"$msgplaintext\",\"$eventtype\",\"$resonatorlevel\",\"$portalguid\");\n";
        }


      }
      my $msgsenderguid=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{guid};
      my $msgsender=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{plain};
#      print "$msgsenderguid, $msgsender \n";

    }
    case /PLAYER_GENERATED/ {
     
    }

    else {
##        print 'this is neither portal, nor link, nor field, gid: ',$guid,"\n";
    }
  }
}
exit 0;
