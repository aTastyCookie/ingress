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
open (collectItemsFromPortalFILE, "response/collectItemsFromPortalWithGlyphResponse");
my $json = decode_json(join '', <collectItemsFromPortalFILE>);
close (collectItemsFromPortalFILE);
my $portalguid=$ARGV[0];
chomp($portalguid);
#`cat cur.txt|cut -d, -f4|tr -d "\r\n"`;
my $mylevel=`bin/getmylevel.sh|tr -d "\r\n"`;
my $myguid=`pwd| sed -e 's@/@\\n\@g'|tail -n 1|tr -d "\r\n"`;
open (getObjectsInCellsFILE, "response/getModifiedEntitiesByGuid");
my $jsonportal=decode_json(join '', <getObjectsInCellsFILE>);
close (getObjectsInCellsFILE);
my $result=$json->{gameBasket}{inventory};
foreach my $rec (@{$jsonportal->{gameBasket}{gameEntities}}) {
  my ($guid, $time, $entity) = @$rec;
  switch ($guid) {
#    print "$guid,$portalguid\n";
    case /[0-9a-z]{32}.1[1-6]/ {
      if ($guid eq $portalguid) {
        $portalteam=$entity->{controllingTeam}{team};
        my $portal=new Ingress::Portal;
        $portallevel=floor($portal->level($entity));
#        print (Dumper($entity));
#        print "$portalteam,$portallevel\n";
      }
    }

  }
}
my $portalentity=$jsonportal->{gameBasket}{gameEntities};
my $myteam=$json->{gameBasket}{playerEntity}[2]{controllingTeam}{team};
$myguid=$json->{gameBasket}{playerEntity}[0];
#print Dumper($result), length($result), "\n";
#print Dumper(%{$json});
#print %{$json->{result}};
my $itemts=time;
foreach my $curmessageref  (@$result) {
#  print Dumper($curmessageref), "\n";
  my $itemguid=@$curmessageref[0];
  $itemts=int(@$curmessageref[1]/1000);
  my $itemdate=scalar localtime($itemts);
  my $itemxref=@$curmessageref[2];
  my $itemtype;
  my $itemlevel;
  open FILE, ">>hackstats.log";
  my $jsonstring=encode_json($curmessageref);
  print FILE $jsonstring,"\n";
  close FILE;
  if ( %{$itemxref}->{modResource}{resourceType} eq "RES_SHIELD" ){
    $itemtype=%{$itemxref}->{modResource}{resourceType};
#    $itemlevel=%{$itemxref}->{modResource}{rarity};
    $itemlevel=%{$itemxref}->{modResource}{stats}{MITIGATION};
  }
  elsif ( %{$itemxref}->{resource}{resourceType} eq "CAPSULE" ){
    $itemtype=%{$itemxref}->{resource}{resourceType};
    $itemlevel=%{$itemxref}->{resource}{resourceRarity};
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
  print "$itemts,$portalguid,$portalteam,$portallevel,$myguid,$myteam,$mylevel,$itemtype,$itemlevel\n";
} # loop
my $mynick=`pwd| sed -e 's@/@\\n\@g'|tail -n 1|tr -d "\r\n"`;
if ($myguid eq "") {
  print "$itemts,$portalguid,portalteam,portallevel,$mynick,myteam,$mylevel,hack_acquired_no_items,0\n"
}
