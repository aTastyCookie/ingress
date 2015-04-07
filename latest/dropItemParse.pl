#!/usr/bin/perl -X
use strict;
use JSON::XS;
use Encode;
use Data::Dumper;
use Switch;
use DateTime;
use bin::Ingress::Portal;
use POSIX;
use warnings;
my $portalteam;
my $portallevel;
binmode(STDOUT, ":utf8");
open (collectItemsFromPortalFILE, "response/dropItem");
my $json = decode_json(join '', <collectItemsFromPortalFILE>);
close (collectItemsFromPortalFILE);
#`cat cur.txt|cut -d, -f4|tr -d "\r\n"`;
my $mylevel=`bin/getmylevel.sh|tr -d "\r\n"`;
my $myguid=`pwd| sed -e 's@/@\\n\@g'|tail -n 1|tr -d "\r\n"`;
my $myteam=$json->{gameBasket}{playerEntity}[2]{controllingTeam}{team};
$myguid=$json->{gameBasket}{playerEntity}[0];
#print Dumper($result), length($result), "\n";
#print Dumper(%{$json});
#print %{$json->{result}};
my $itemts=time;
my $result=$json->{gameBasket}{gameEntities};
print Dumper($result), length($result), "\n";
foreach my $curmessageref  (@$result) {
#  print Dumper($curmessageref), "\n";
  my $itemguid=@$curmessageref[0];
  $itemts=int(@$curmessageref[1]/1000);
  my $itemdate=scalar localtime($itemts);
  my $itemxref=@$curmessageref[2];
  my $itemtype;
  my $itemlevel;
  my $itemlat=%{$itemxref}->{locationE6}{latE6};
  my $itemlon %{$itemxref}->{locationE6}{lngE6};
  open FILE, ">drop.log";
  my $jsonstring=encode_json($curmessageref);
  print FILE $jsonstring,"\n";
  close FILE;
  if ( %{$itemxref}->{modResource}{resourceType} eq "RES_SHIELD" ){
    $itemtype=%{$itemxref}->{modResource}{resourceType};
#    $itemlevel=%{$itemxref}->{modResource}{rarity};
    $itemlevel=%{$itemxref}->{modResource}{stats}{MITIGATION};
  }
  elsif ( %{$itemxref}->{modResource}{resourceType} eq "FORCE_AMP" ){
    $itemtype=%{$itemxref}->{modResource}{resourceType};
    $itemlevel=%{$itemxref}->{modResource}{stats}{FORCE_AMPLIFIER};
  }
  elsif ( %{$itemxref}->{modResource}{resourceType} eq "TURRET" ){
    $itemtype=%{$itemxref}->{modResource}{resourceType};
    $itemlevel=%{$itemxref}->{modResource}{stats}{ATTACK_FREQUENCY};
  }
  elsif ( %{$itemxref}->{modResource}{resourceType} eq "HEATSINK" ){
    $itemtype=%{$itemxref}->{modResource}{resourceType};
    $itemlevel=%{$itemxref}->{modResource}{stats}{HACK_SPEED};
  }
  elsif ( %{$itemxref}->{modResource}{resourceType} eq "MULTIHACK" ){
    $itemtype=%{$itemxref}->{modResource}{resourceType};
    $itemlevel=%{$itemxref}->{modResource}{stats}{BURNOUT_INSULATION};
  }

  elsif ( %{$itemxref}->{modResource}{resourceType} eq "LINK_AMPLIFIER" ){
    $itemtype=%{$itemxref}->{modResource}{resourceType};
    $itemlevel=%{$itemxref}->{modResource}{stats}{LINK_RANGE_MULTIPLIER};
  }
  elsif ( %{$itemxref}->{resource}{resourceType} eq "PORTAL_LINK_KEY" ){
    $itemtype=%{$itemxref}->{resource}{resourceType};
    $itemlevel=0;
    my $portaladdr=%{$itemxref}->{portalCoupler}{portalAddress};
    my $portaltitle=%{$itemxref}->{portalCoupler}{portalTitle};
    my $portalguid=%{$itemxref}->{portalCoupler}{portalGuid};
    $portaltitle=~ tr/\r\n\'\"|\’\\\///d;
    $portaladdr=~ tr/\r\n\'\"|\’\\\///d;
  }
  elsif ( %{$itemxref}->{resource}{resourceType} eq "FLIP_CARD" ){
    $itemtype=%{$itemxref}->{resource}{resourceType};
    $itemlevel=%{$itemxref}->{flipCard}{flipCardType};
  }
  else {
    $itemtype=%{$itemxref}->{resourceWithLevels}->{resourceType};
    $itemlevel=%{$itemxref}->{resourceWithLevels}->{level};
 }
  print "$itemlat,$itemlon,$itemguid,$itemts,$portalteam,$portallevel,$myguid,$myteam,$mylevel,$itemtype,$itemlevel\n";
} # loop
my $mynick=`pwd| sed -e 's@/@\\n\@g'|tail -n 1|tr -d "\r\n"`;
