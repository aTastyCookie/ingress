#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
use Data::Dumper;
use Switch;
use DateTime;
use bin::Ingress::Portal;
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
    case /[0-9a-z]{32}.1[1-6]/ {
      if ($guid eq $PGUID) {
        my $portal=new Ingress::Portal;
        my $latitude=$entity->{locationE6}{latE6}/1000000;
        my $longitude=$entity->{locationE6}{lngE6}/1000000;
        my $imageUrl=$entity->{imageByUrl}{imageUrl};
        my $team=$entity->{controllingTeam}{team};
        print $team,"\n";
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
        my $portalhealth=$portal->health($entity);
        my $portalmaxhealth=$portal->maxhealth($entity);
        my $needtorecharge=1;
        if ( 100*$portalhealth/($portalmaxhealth+1) > 99 ) {$needtorecharge=0};
        if ( $needtorecharge==1 ) {
          print "need2charge\n";
          open (PUFILE, '>portalcharge.txt');
          print PUFILE "ok2recharge\n";
          close (PUFILE);
        }

        my @resonators=@{$entity->{resonatorArray}{resonators}};
        my $resnumber=-1;
	my $rescount=0;
        foreach my $resonator (@resonators) {
          $resnumber++;
	  
	  if ( defined $resonator ) {
	    $rescount++;
            print "$resonator->{energyTotal},";
            my $modul=$resonator->{energyTotal} % 500;
            if ( $modul > 0 ) {
              open (PUFILE, '>portalcharge.txt');
              print PUFILE "ok2recharge\n";
              close (PUFILE);
            }
          }   
        } #foreach resonator
        print "\n";
      } #if guid=pguid
    } # portalmagicmatch
  else {
    }
  } #switch entityguid
} #foreach myrec

#my $json_string    = encode_json($request);
#print $json_string;
