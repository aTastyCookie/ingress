#!/usr/bin/perl -X
use strict;
use JSON::XS;
use Encode;
use Data::Dumper;
use Switch;
use DateTime;
use bin::Ingress::Item;

binmode(STDOUT, ":utf8");
my $json = decode_json(join '', <>);
my $result=$json->{gameBasket}{inventory};
my $item=new Ingress::Item;
#print Dumper($result), length($result), "\n";
#print Dumper(%{$json});
#print %{$json->{result}};
foreach my $curmessageref  (@$result) {
#  print Dumper($curmessageref), "\n";
  my $itemguid=@$curmessageref[0];
  my $itemts=int(@$curmessageref[1]/1000);
  my $itemdate=scalar localtime($itemts);
  my $itemxref=@$curmessageref[2];
  my $itemtype;
  my $itemlevel;
## deprecated since we don't need this anymore
#  open FILE, ">>hack.log";
#  my $jsonstring=encode_json($curmessageref);
#  print FILE $jsonstring,"\n";
#  close FILE;
  if ( %{$itemxref}->{modResource}{resourceType} eq "RES_SHIELD" ){
    $itemtype=%{$itemxref}->{modResource}{resourceType};
#    $itemlevel=%{$itemxref}->{modResource}{rarity};
    $itemlevel=%{$itemxref}->{modResource}{stats}{MITIGATION};
    print $itemtype,",",$itemlevel,",",$itemguid,"\n";
  }
  elsif ( %{$itemxref}->{modResource}{resourceType} eq "EXTRA_SHIELD" ){
    $itemtype=%{$itemxref}->{modResource}{resourceType};
#    $itemlevel=%{$itemxref}->{modResource}{rarity};
    $itemlevel=%{$itemxref}->{modResource}{stats}{MITIGATION};
    print $itemtype,",",$itemlevel,",",$itemguid,"\n";
  }
 
  elsif ( %{$itemxref}->{resource}{resourceType} eq "CAPSULE" ){
    $itemtype=%{$itemxref}->{resource}{resourceType};
    $itemlevel=%{$itemxref}->{resource}{resourceRarity};
    my $capsulemoniker=%{$itemxref}->{moniker}{differentiator};
    my $capsulefill=%{$itemxref}->{container}{currentCount};
    print "$itemtype,$itemlevel,$itemguid,$capsulemoniker,$capsulefill/100\n";
    if ( $capsulefill > 0 ) {
      foreach my $curcapsstack (@{%{$itemxref}->{container}{stackableItems}}) {
        my $stacksize=scalar @{$curcapsstack->{itemGuids}};
        my $CAPSULIST=$curcapsstack->{itemGuids};
        my $entity=$curcapsstack->{exampleGameEntity}[2];
        my $stackitemtype=$item->type($entity);
        print "$stacksize,$stackitemtype,$capsulemoniker\n";
     }
    } #capsule ne
 }
  elsif ( %{$itemxref}->{modResource}{resourceType} eq "FORCE_AMP" ){
    $itemtype=%{$itemxref}->{modResource}{resourceType};
    $itemlevel=%{$itemxref}->{modResource}{stats}{FORCE_AMPLIFIER};
    print $itemtype,",",$itemlevel,",",$itemguid,"\n";
  }
  elsif ( %{$itemxref}->{modResource}{resourceType} eq "TURRET" ){
    $itemtype=%{$itemxref}->{modResource}{resourceType};
    $itemlevel=%{$itemxref}->{modResource}{stats}{ATTACK_FREQUENCY};
    print $itemtype,",",$itemlevel,",",$itemguid,"\n";
  }
  elsif ( %{$itemxref}->{modResource}{resourceType} eq "HEATSINK" ){
    $itemtype=%{$itemxref}->{modResource}{resourceType};
    $itemlevel=%{$itemxref}->{modResource}{stats}{HACK_SPEED};
    print $itemtype,",",$itemlevel,",",$itemguid,"\n";
  }
  elsif ( %{$itemxref}->{modResource}{resourceType} eq "MULTIHACK" ){
    $itemtype=%{$itemxref}->{modResource}{resourceType};
    $itemlevel=%{$itemxref}->{modResource}{stats}{BURNOUT_INSULATION};
    print $itemtype,",",$itemlevel,",",$itemguid,"\n";
  }

  elsif ( %{$itemxref}->{modResource}{resourceType} eq "LINK_AMPLIFIER" ){
    $itemtype=%{$itemxref}->{modResource}{resourceType};
    $itemlevel=%{$itemxref}->{modResource}{stats}{LINK_RANGE_MULTIPLIER};
    print $itemtype,",",$itemlevel,",",$itemguid,"\n";
  }
  elsif ( %{$itemxref}->{resource}{resourceType} eq "PORTAL_LINK_KEY" ){
    $itemtype=%{$itemxref}->{resource}{resourceType};
    $itemlevel=0;
    my $portaladdr=%{$itemxref}->{portalCoupler}{portalAddress};
    my $portaltitle=%{$itemxref}->{portalCoupler}{portalTitle};
    my $portalguid=%{$itemxref}->{portalCoupler}{portalGuid};
    $portaltitle=~ tr/\r\n\'\"|\’\\\///d;
    $portaladdr=~ tr/\r\n\'\"|\’\\\///d;
    print "$itemtype,$itemlevel,$itemguid,$portaltitle,$portaladdr,$portalguid\n";
  }
  elsif ( %{$itemxref}->{resource}{resourceType} eq "FLIP_CARD" ){ 
    $itemtype=%{$itemxref}->{resource}{resourceType};
    $itemlevel=%{$itemxref}->{flipCard}{flipCardType};
    print $itemtype,",",$itemlevel,",",$itemguid,"\n";
  }
  else {
    $itemtype=%{$itemxref}->{resourceWithLevels}->{resourceType};
    $itemlevel=%{$itemxref}->{resourceWithLevels}->{level};
    print $itemtype,",",$itemlevel,",",$itemguid,"\n";
 }
} # loop
