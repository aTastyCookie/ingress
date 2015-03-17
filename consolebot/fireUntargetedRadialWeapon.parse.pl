#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
use Data::Dumper;
use Switch;
use DateTime;
use bin::Ingress::Portal;
my $portal=new Ingress::Portal;
binmode(STDOUT, ":utf8");
open (RESPONSEFILE, "$ARGV[0]");
my $PGUID=$ARGV[1];
my $json = decode_json(join '', <RESPONSEFILE>);
my $energyGlobTimestamp=$json->{gameBasket}{energyGlobTimestamp};
my $xm=$json->{gameBasket}{playerEntity}[2]{playerPersonal}{energy};
open (XMFILE, '>xm.txt');
print XMFILE $xm."\n";
close (XMFILE);
my $result=$json->{result}{damages};
foreach my $damage (@{$result}) {
  #print Dumper($damage);
  if ($damage->{targetGuid} eq $ARGV[1]) {
   print "slot: $damage->{targetSlot} - damage: $damage->{damageAmount} \n";
  }
}
my $myguid=$json->{gameBasket}{playerEntity}[0];
my $myteam=$json->{gameBasket}{playerEntity}[2]{controllingTeam}{team};
#print "working with pguid $myguid, playing for $myteam\n";
foreach my $rec (@{$json->{gameBasket}{gameEntities}}) {
  my ($guid, $time, $entity) = @$rec;
#       print Dumper($rec);
  switch ($guid) {
    case /[0-9a-z]{32}.1[1-6]/ {
      if ($guid eq $PGUID) {
        my $latitude=$entity->{locationE6}{latE6}/1000000;
        my $longitude=$entity->{locationE6}{lngE6}/1000000;
        my $title=$portal->title($entity);
        my $address=$portal->address($entity);
        my $imageUrl=$entity->{imageByUrl}{imageUrl};
        my $team=$entity->{controllingTeam}{team};
        my @resonators=@{$entity->{resonatorArray}{resonators}};
        my $resnumber=-1;
        my $rescount=0;
        my $portalhealth=0;
        foreach my $resonator (@resonators) {
          $resnumber++;

          if ( ! defined $resonator ) {
#            print "null resonator \n";
            $resonator->{slot}=$resnumber;
            $resonator->{energyTotal}=0;
            $resonator->{distanceToPortal}=0;
            $resonator->{id}='00000000-0000-0000-0000-000000000000';
            $resonator->{level}=0;
            $resonator->{ownerGuid}='00000000000000000000000000000000.c'
          }
         print 'R:',$resonator->{slot},",";
         print 'L:',$resonator->{level},",";
         print 'E:',$resonator->{energyTotal},"\n";
         $portalhealth=$portalhealth+$resonator->{energyTotal};
        }
        print "portal energy: $portalhealth \n";
        print "$team \n";
        if ( $team eq "NEUTRAL" ) {
          print "portal was eliminated!\n";
          exit 0;
        }
        if ( $team ne $myteam ) {                                                                                                                                                       
          print "portal belongs to enemy!\n";                                                                                                                                              
          exit 2;                                                                                                                                                                        
        }             
      }
    }
  }
}

#print Dumper($result), length($result), "\n";


#print Dumper($result), length($result), "\n";
#print Dumper(%{$json});
#print %{$json->{result}};
#foreach my $curxmid  (@$result) {
#   print "xm with id $curxmid \n";
#   push ($request->{params}{energyGlobGuids},$curxmid);
#}
