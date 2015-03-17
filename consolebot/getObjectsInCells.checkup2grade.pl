#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
use Data::Dumper;
use Switch;
use DateTime;
open (DEBUGFILE, '>debug.txt');
my $knobsyncts=`cat knobsyncts.txt|tr -d "\r"`;
my $visiblelevel=`cat config.ini|grep visiblelevel|cut -d=  -f2|tr -d "\r"`;
my $visiblelevel=`bin/getmylevel.sh`;
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
	  
	  if ( defined $resonator ) {
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
	    my $l8ups=0;
            my $l7ups=0;
            my $l6ups=0;
            my $l5ups=0;
            my $l4ups=0;
            if ( $visiblelevel >= 8) {
              $l8ups=1;
            }
            if ( $visiblelevel >= 7) {
              $l7ups=1;
            }
            if ( $visiblelevel >= 6) {
              $l6ups=2;
            }
            if ( $visiblelevel >= 5) {
              $l5ups=2;
            }
            if ( $visiblelevel >= 4) {
              $l4ups=4;
            }
            print DEBUGFILE "$visiblelevel\n";
            print DEBUGFILE "$l8ups\n";
            print DEBUGFILE "$l7ups\n";
            print DEBUGFILE "$l6ups\n";
            print DEBUGFILE "$l5ups\n";
            print DEBUGFILE "$l4ups\n";

	    foreach my $resonator (@resonators) {
              if ( $resonator->{ownerGuid} eq $myguid ) {
       #         print "your $resonator->{level} res already here\n";
		switch ($resonator->{level}) {
		  case 8 {
                    $l8ups--;
		  }
		  case 7 {
                    $l7ups--;
		  }
		  case 6 {
	            $l6ups--;
		  }
		  case 5 {
		    $l5ups--;
	          }
		  case 4 {
                    $l4ups--;
	          }
	        }
	      } #thisismyresonator
	       else {
	        switch ($resonator->{level}) {
		  case 8 {
                  #  print "resonator at $resonator->{slot} is L8, no upgrade is possible\n";
                  }
                  case 7 {
                    if ( $l8ups>0 ) {
                      print "$resonator->{slot},8\n";
		      $l8ups--;
		    }
                  }
                  case 6 {
                    if ( $l8ups>0 ) {print "$resonator->{slot},8\n";$l8ups--;} else {
                     if ( $l7ups>0 ) {print "$resonator->{slot},7\n";$l7ups--;}      }
                  }
                  case 5 {
                    if ( $l8ups>0 ) {print "$resonator->{slot},8\n";$l8ups--;} else {
                     if ( $l7ups>0 ) {print "$resonator->{slot},7\n";$l7ups--;} else {
                      if ( $l6ups>0 ) {print "$resonator->{slot},6\n";$l6ups--;}      }}
                  }
                  case 4 {
                    if ( $l8ups>0 ) {print "$resonator->{slot},8\n";$l8ups--;} else {
                     if ( $l7ups>0 ) {print "$resonator->{slot},7\n";$l7ups--;} else {
                      if ( $l6ups>0 ) {print "$resonator->{slot},6\n";$l6ups--;} else {
                        if ( $l5ups>0 ) {print "$resonator->{slot},5\n";$l5ups--;}     }}}
                  }
                  case 3 {
                    if ( $l8ups>0 ) {print "$resonator->{slot},8\n";$l8ups--;} else {
                     if ( $l7ups>0 ) {print "$resonator->{slot},7\n";$l7ups--;} else {
                      if ( $l6ups>0 ) {print "$resonator->{slot},6\n";$l6ups--;} else {
                       if ( $l5ups>0 ) {print "$resonator->{slot},5\n";$l5ups--;} else {
                        if ( $l4ups>0 ) {print "$resonator->{slot},4\n";$l4ups--;}      }}}}
                  }
                  case 2 {
                    if ( $l8ups>0 ) {print "$resonator->{slot},8\n";$l8ups--;} else {
                     if ( $l7ups>0 ) {print "$resonator->{slot},7\n";$l7ups--;} else {
                      if ( $l6ups>0 ) {print "$resonator->{slot},6\n";$l6ups--;} else {
                       if ( $l5ups>0 ) {print "$resonator->{slot},5\n";$l5ups--;} else {
                        if ( $l4ups>0 ) {print "$resonator->{slot},4\n";$l4ups--;}      }}}}

                  }
                  case 1 {
                    if ( $l8ups>0 ) {print "$resonator->{slot},8\n";$l8ups--;} else {
                     if ( $l7ups>0 ) {print "$resonator->{slot},7\n";$l7ups--;} else {
                      if ( $l6ups>0 ) {print "$resonator->{slot},6\n";$l6ups--;} else {
                       if ( $l5ups>0 ) {print "$resonator->{slot},5\n";$l5ups--;} else {
                        if ( $l4ups>0 ) {print "$resonator->{slot},4\n";$l4ups--;}      }}}}
                  }
		} 
	       } #thisisnotmyresonator
	    } #foreach my resonators
        } #if rescount=8
      } #if guid=pguid
    } # portalmagicmatch
  else {
    }
  } #switch entityguid
} #foreach myrec

#my $json_string    = encode_json($request);
#print $json_string;
close (DEBUGFILE);
