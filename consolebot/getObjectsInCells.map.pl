#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
use Data::Dumper;
use Switch;
use DateTime;
my $knobsyncts=`cat knobsyncts.txt|tr -d "\r"`;
chop $knobsyncts;
my $PGUID=$ARGV[1];
binmode(STDOUT, ":utf8");
open (RESPONSEFILE, "$ARGV[0]");
my $json = decode_json(join '', <RESPONSEFILE>);
my $myguid=$json->{gameBasket}{playerEntity}[0];
my $myteam=$json->{gameBasket}{playerEntity}[2]{controllingTeam}{team};
my @resonatorsup;
#print "working with pguid $myguid, playing for $myteam\n";
foreach my $rec (@{$json->{gameBasket}{gameEntities}}) {
  my ($guid, $time, $entity) = @$rec;
#	print Dumper($rec);
  switch ($guid) {
    case /[0-9a-z]{32}.4/ {
      my $latitude=$entity->{locationE6}{latE6}/1000000;
      my $longitude=$entity->{locationE6}{lngE6}/1000000;
      my $itemtype=$entity->{modResource}{resourceType};
      my $itemxref=$entity;
      my $itemlevel;
      my $itemguid;
  if ( %{$itemxref}->{modResource}{resourceType} eq "RES_SHIELD" ){
    $itemtype=%{$itemxref}->{modResource}{resourceType};
#    $itemlevel=%{$itemxref}->{modResource}{rarity};
    $itemlevel=%{$itemxref}->{modResource}{stats}{MITIGATION};
    print $latitude,",",$longitude,",",$itemtype,",",$itemlevel,",",$itemguid,"\n";
  }
  elsif ( %{$itemxref}->{modResource}{resourceType} eq "FORCE_AMP" ){
    $itemtype=%{$itemxref}->{modResource}{resourceType};
    $itemlevel=%{$itemxref}->{modResource}{stats}{FORCE_AMPLIFIER};
    print $latitude,",",$longitude,",",$itemtype,",",$itemlevel,",",$itemguid,"\n";
  }
  elsif ( %{$itemxref}->{modResource}{resourceType} eq "TURRET" ){
    $itemtype=%{$itemxref}->{modResource}{resourceType};
    $itemlevel=%{$itemxref}->{modResource}{stats}{ATTACK_FREQUENCY};
    print $latitude,",",$longitude,",",$itemtype,",",$itemlevel,",",$itemguid,"\n";
  }
  elsif ( %{$itemxref}->{modResource}{resourceType} eq "HEATSINK" ){
    $itemtype=%{$itemxref}->{modResource}{resourceType};
    $itemlevel=%{$itemxref}->{modResource}{stats}{HACK_SPEED};
    print $latitude,",",$longitude,",",$itemtype,",",$itemlevel,",",$itemguid,"\n";
  }
  elsif ( %{$itemxref}->{modResource}{resourceType} eq "MULTIHACK" ){
    $itemtype=%{$itemxref}->{modResource}{resourceType};
    $itemlevel=%{$itemxref}->{modResource}{stats}{BURNOUT_INSULATION};
    print $latitude,",",$longitude,",",$itemtype,",",$itemlevel,",",$itemguid,"\n";
  }

  elsif ( %{$itemxref}->{modResource}{resourceType} eq "LINK_AMPLIFIER" ){
    $itemtype=%{$itemxref}->{modResource}{resourceType};
    $itemlevel=%{$itemxref}->{modResource}{stats}{LINK_RANGE_MULTIPLIER};
    print $latitude,",",$longitude,",",$itemtype,",",$itemlevel,",",$itemguid,"\n";
  }
  elsif ( %{$itemxref}->{resource}{resourceType} eq "PORTAL_LINK_KEY" ){
    $itemtype=%{$itemxref}->{resource}{resourceType};
    $itemlevel=0;
    my $portaladdr=%{$itemxref}->{portalCoupler}{portalAddress};
    my $portaltitle=%{$itemxref}->{portalCoupler}{portalTitle};
    my $portalguid=%{$itemxref}->{portalCoupler}{portalGuid};
    $portaltitle=~ tr/\r\n\'\"|\’\\\///d;
    $portaladdr=~ tr/\r\n\'\"|\’\\\///d;
    print "$latitude,$longitude,$itemtype,$itemlevel,$itemguid,$portaltitle,$portaladdr,$portalguid\n";
  }
  elsif ( %{$itemxref}->{resource}{resourceType} eq "FLIP_CARD" ){
    $itemtype=%{$itemxref}->{resource}{resourceType};
    $itemlevel=%{$itemxref}->{flipCard}{flipCardType};
    print $latitude,",",$longitude,",",$itemtype,",",$itemlevel,",",$itemguid,"\n";
  }
  else {
    $itemtype=%{$itemxref}->{resourceWithLevels}->{resourceType};
    $itemlevel=%{$itemxref}->{resourceWithLevels}->{level};
    print $latitude,",",$longitude,",",$itemtype,",",$itemlevel,",",$itemguid,"\n";
 }


    }
    case /[0-9a-z]{32}.1[1-6]/ {
      if ($guid eq $PGUID) {
        my $latitude=$entity->{locationE6}{latE6}/1000000;
        my $longitude=$entity->{locationE6}{lngE6}/1000000;
        my $imageUrl=$entity->{imageByUrl}{imageUrl};
        my $team=$entity->{controllingTeam}{team};
        if ( $team ne $myteam ) {
#          print "portal belongs to enemy!\n";
          exit 1;
        }
        my $capturedTime=$entity->{captured}{capturedTime}/1000;
        my $capturingPlayerId=$entity->{captured}{capturingPlayerId};

         if ( $team eq "NEUTRAL") {
         $capturedTime=0;
         $capturingPlayerId='00000000000000000000000000000000.c';
       }
        my @resonators=@{$entity->{resonatorArray}{resonators}};
        my $resnumber=-1;
	my $rescount=0;
        foreach my $resonator (@resonators) {
          $resnumber++;
	  
	  if (  defined $resonator ) {
	    $rescount++;
          }   
          if ( ! defined $resonator ) {
#            print "null resonator \n";
            $resonator->{slot}=$resnumber;
            $resonator->{energyTotal}=0;
            $resonator->{distanceToPortal}=0;
            $resonator->{id}='00000000-0000-0000-0000-000000000000';
            $resonator->{level}=0;
            $resonator->{ownerGuid}='00000000000000000000000000000000.c'
          }
#         print 'found resonator ',$slot,"\n";
#         print 'level ',$level,"\n";
#         print 'energy ',$energyTotal,"\n";
        }
          if ($rescount eq 8) {
#            print "portal at max resonators, proceeding \n";
	    my $l8ups=1;
	    my $l7ups=1;
	    my $l6ups=2;
	    my $l5ups=2;
	    my $l4ups=4;
            my $ressum;
	    foreach my $resonator (@resonators) {
              $ressum=$ressum+$resonator->{level};
	    } #foreach my resonators
            my $portallevel=$ressum/8;
            if ($portallevel>5.99) {
              my @shields=@{$entity->{portalV2}{linkedModArray}};
              my $shieldcount=-1;
              foreach my $shield (@shields) {
                $shieldcount++;
                if ( ! defined $shield ) {
                  print "$shieldcount\n";
                }
              }
            }
        } #if rescount=8
      } #if guid=pguid
    } # portalmagicmatch
  else {
    }
  } #switch entityguid
} #foreach myrec

#my $json_string    = encode_json($request);
#print $json_string;
