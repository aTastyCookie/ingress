#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
use Data::Dumper;
use Switch;
use DateTime;
binmode(STDOUT, ":utf8");
open (FILENEW, "/tmp/sql2guids");
my $guids = decode_json(join '', <FILENEW>);
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
          my $playerguid=$guids->{$playername};
#          my $playerguid=`mysql ingress -e 'select guid from guids where nickname=\"$playername\"' | grep -v guid`;
          my $resonatorlevel=%{%{$msgplextxref}->{plext}->{markup}[2][1]}->{plain};
          $resonatorlevel=~ tr/L//d;
          my $portalguid=%{%{$msgplextxref}->{plext}->{markup}[4][1]}->{guid};
          print "REPLACE INTO syscomm values (\"$msguid\",$msgts,\"$msgsenderteam\",\"$msgsendertype\",\"$playerguid\",\"$msgplaintext\",\"$eventtype\",\"$resonatorlevel\",\"$portalguid\");\n";
        }
        case /^(.*)destroyed an (.*)Resonator(.*)$/ {
          my $eventtype="resdestroy";
          my $playerguid=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{guid};
          my $playername=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{plain};
          my $playerguid=$guids->{$playername}; 
#          my $playerguid=`mysql ingress -e 'select guid from guids where nickname=\"$playername\"'|grep -v guid`;
          my $resonatorlevel=%{%{$msgplextxref}->{plext}->{markup}[2][1]}->{plain};
          $resonatorlevel=~ tr/L//d;
          my $portalguid=%{%{$msgplextxref}->{plext}->{markup}[4][1]}->{guid};
          print "REPLACE INTO syscomm values (\"$msguid\",$msgts,\"$msgsenderteam\",\"$msgsendertype\",\"$playerguid\",\"$msgplaintext\",\"$eventtype\",\"$resonatorlevel\",\"$portalguid\");\n";
#          print "REPLACE INTO guids values (\"$playername\",\"$playerguid\");\n";
#          print "$msguid,$msgts,$msgsenderteam,$msgsendertype,$playerguid,$msgplaintext,$eventtype,$resonatorlevel,$portalguid \n";
        }
        case /^(.*)destroyed the Link(.*)$/ {
          my $eventtype="linkdestroy";
          my $playerguid=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{guid};
          my $playername=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{plain};
          my $playerguid=$guids->{$playername};
#          my $playerguid=`mysql ingress -e 'select guid from guids where nickname=\"$playername\"'|grep -v guid`;
          my $resonatorlevel=0;
          my $portalguid=%{%{$msgplextxref}->{plext}->{markup}[2][1]}->{guid};
          #temp hack (msgsender team for linkdestroy is the opposite faction)
          print "REPLACE INTO syscomm values (\"$msguid\",$msgts,\"$msgsenderteam\",\"$msgsendertype\",\"$playerguid\",\"$msgplaintext\",\"$eventtype\",\"$resonatorlevel\",\"$portalguid\");\n";
#          print "REPLACE INTO guids values (\"$playername\",\"$playerguid\");\n";
#          print "$msguid,$msgts,$msgsenderteam,$msgsendertype,$playerguid,$msgplaintext,$eventtype,$resonatorlevel,$portalguid \n";
        }
        case /^(.*)linked(.*)$/ {
          my $eventtype="linkcreate";
          my $playerguid=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{guid};
          my $playername=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{plain};
          my $playerguid=`mysql ingress -e 'select guid from guids where nickname=\"$playername\"'|grep -v guid`;
          my $resonatorlevel=0;
          my $portalguid=%{%{$msgplextxref}->{plext}->{markup}[2][1]}->{guid};
          print "REPLACE INTO syscomm values (\"$msguid\",$msgts,\"$msgsenderteam\",\"$msgsendertype\",\"$playerguid\",\"$msgplaintext\",\"$eventtype\",\"$resonatorlevel\",\"$portalguid\");\n";
#          print "REPLACE INTO guids values (\"$playername\",\"$playerguid\");\n";
#          print "$msguid,$msgts,$msgsenderteam,$msgsendertype,$playerguid,$msgplaintext,$eventtype,$resonatorlevel,$portalguid \n";
        }
        case /^(.*)created a Control Field (.*)$/ {
          my $eventtype="fieldcreate";
          my $playerguid=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{guid};
          my $playername=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{plain};
          my $playerguid=`mysql ingress -e 'select guid from guids where nickname=\"$playername\"'|grep -v guid`;
          my $resonatorlevel=0;
          my $portalguid=%{%{$msgplextxref}->{plext}->{markup}[2][1]}->{guid};
          print "REPLACE INTO syscomm values (\"$msguid\",$msgts,\"$msgsenderteam\",\"$msgsendertype\",\"$playerguid\",\"$msgplaintext\",\"$eventtype\",\"$resonatorlevel\",\"$portalguid\");\n";
#          print "REPLACE INTO guids values (\"$playername\",\"$playerguid\");\n";
#          print "$msguid,$msgts,$msgsenderteam,$msgsendertype,$playerguid,$msgplaintext,$eventtype,$resonatorlevel,$portalguid \n";
        }


        case /^(.*)destroyed a Control Field (.*)$/ {
          my $eventtype="fielddestroy";
          my $playerguid=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{guid};
          my $playername=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{plain};
          my $playerguid=$guids->{$playername};
#          my $playerguid=`mysql ingress -e 'select guid from guids where nickname=\"$playername\"'|grep -v guid`;
          my $resonatorlevel=0;
          my $portalguid=%{%{$msgplextxref}->{plext}->{markup}[2][1]}->{guid};
          print "REPLACE INTO syscomm values (\"$msguid\",$msgts,\"$msgsenderteam\",\"$msgsendertype\",\"$playerguid\",\"$msgplaintext\",\"$eventtype\",\"$resonatorlevel\",\"$portalguid\");\n";
#          print "REPLACE INTO guids values (\"$playername\",\"$playerguid\");\n";
#          print "$msguid,$msgts,$msgsenderteam,$msgsendertype,$playerguid,$msgplaintext,$eventtype,$resonatorlevel,$portalguid \n";
        }

        case /^(.*)captured(.*)$/ {
          my $eventtype="portalcapture";
          my $playerguid=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{guid};
          my $playername=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{plain};
          my $playerguid=$guids->{$playername};
#          my $playerguid=`mysql ingress -e 'select guid from guids where nickname=\"$playername\"'|grep -v guid`;
          my $resonatorlevel=0;
          my $portalguid=%{%{$msgplextxref}->{plext}->{markup}[2][1]}->{guid};
          print "REPLACE INTO syscomm values (\"$msguid\",$msgts,\"$msgsenderteam\",\"$msgsendertype\",\"$playerguid\",\"$msgplaintext\",\"$eventtype\",\"$resonatorlevel\",\"$portalguid\");\n";
#          print "REPLACE INTO guids values (\"$playername\",\"$playerguid\");\n";
#          print "$msguid,$msgts,$msgsenderteam,$msgsendertype,$playerguid,$msgplaintext,$eventtype,$resonatorlevel,$portalguid \n";
        }


      }
      my $msgsenderguid=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{guid};
      my $msgsender=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{plain};
#      print "$msgsenderguid, $msgsender \n";

    }
    case /PLAYER_GENERATED/ {
      my $msgplaintext=%{$msgplextxref}->{plext}->{text};
      #print $msgplaintext,"\n";
      switch ($msgplaintext) {
        case /^\[secure\](.*): @(.*)$/ {
      my $msgsecure=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{plain};
      my $msgsender=%{%{$msgplextxref}->{plext}->{markup}[1][1]}->{plain};
      $msgsender=~ tr/\:\ //d;
      my $msgsenderguid=%{%{$msgplextxref}->{plext}->{markup}[1][1]}->{guid};
      my $msgsendertype=%{$msgplextxref}->{plext}->{plextType};
      my $msgtext=%{%{$msgplextxref}->{plext}->{markup}[4][1]}->{plain};
      $msgtext=~ tr/\'\"|\\\’//d;
      #  print Dumper($msgplextxref), "\n";
      print "REPLACE INTO comm values (\"$msguid\",$msgts,\"$msgsenderteam\",\"$msgsendertype\",\"$msgsenderguid\",\"$msgplaintext\");\n";
#      print "REPLACE INTO guids values (\"$msgsender\",\"$msgsenderguid\");\n";
      #  print "$msgdate,$msgtext\n";
        }
        else {
      my $msgsecure=%{%{$msgplextxref}->{plext}->{markup}[0][1]}->{plain};
      my $msgsender=%{%{$msgplextxref}->{plext}->{markup}[1][1]}->{plain};
      $msgsender=~ tr/\:\ //d;
      my $msgsenderguid=%{%{$msgplextxref}->{plext}->{markup}[1][1]}->{guid};
      my $msgsendertype=%{$msgplextxref}->{plext}->{plextType};
      my $msgtext=%{%{$msgplextxref}->{plext}->{markup}[2][1]}->{plain};
      $msgtext=~ tr/\'\"|\\\’//d;
      #  print Dumper($msgplextxref), "\n";
      print "REPLACE INTO comm values (\"$msguid\",$msgts,\"$msgsenderteam\",\"$msgsendertype\",\"$msgsenderguid\",\"$msgplaintext\");\n";
#      print "REPLACE INTO guids values (\"$msgsender\",\"$msgsenderguid\");\n";
      #  print "$msgdate,$msgtext\n";

        }
      }
     
    }

    else {
##        print 'this is neither portal, nor link, nor field, gid: ',$guid,"\n";
    }
  }
}
exit 0;
