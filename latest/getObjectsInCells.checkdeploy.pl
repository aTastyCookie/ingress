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
           if ( $team ne "NEUTRAL") {
#          print "portal belongs to enemy!\n";
            exit 1;
           }
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
          if ($rescount < 8) {
#            print "portal not at max resonators, proceeding \n";
	    my $l8ups=0;
            my $l7ups=0;
            my $l6ups=0;
            my $l5ups=0;
            my $l4ups=0;
            my $l3ups=0;
            my $l2ups=0;
            my $l1ups=0;
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
            if ( $visiblelevel >= 3) {
              $l3ups=4;
            }
            if ( $visiblelevel >= 2) {
              $l2ups=4;
            }
            if ( $visiblelevel >= 1) {
              $l1ups=8;
            }
            print DEBUGFILE "$visiblelevel\n";
            print DEBUGFILE "$l8ups\n";
            print DEBUGFILE "$l7ups\n";
            print DEBUGFILE "$l6ups\n";
            print DEBUGFILE "$l5ups\n";
            print DEBUGFILE "$l4ups\n";
            print DEBUGFILE "$l3ups\n";
            print DEBUGFILE "$l2ups\n";
            print DEBUGFILE "$l1ups\n";


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
                  case 3 {
                    $l3ups--;
                  }
                  case 2 {
                    $l2ups--;
                  }
                  case 1 {
                    $l1ups--;
                  }
	        }
	      } #thisismyresonator
	       else {
	        switch ($resonator->{level}) {
		  case 68 {
                  #  print "resonator at $resonator->{slot} is L8, no upgrade is possible\n";
                  }
                  case 67 {
                    if ( $l8ups>0 ) {
                      print "$resonator->{slot},8\n";
		      $l8ups--;
		    }
                  }
                  case 66 {
                    if ( $l8ups>0 ) {print "$resonator->{slot},8\n";$l8ups--;} else {
                     if ( $l7ups>0 ) {print "$resonator->{slot},7\n";$l7ups--;}      }
                  }
                  case 65 {
                    if ( $l8ups>0 ) {print "$resonator->{slot},8\n";$l8ups--;} else {
                     if ( $l7ups>0 ) {print "$resonator->{slot},7\n";$l7ups--;} else {
                      if ( $l6ups>0 ) {print "$resonator->{slot},6\n";$l6ups--;}      }}
                  }
                  case 64 {
                    if ( $l8ups>0 ) {print "$resonator->{slot},8\n";$l8ups--;} else {
                     if ( $l7ups>0 ) {print "$resonator->{slot},7\n";$l7ups--;} else {
                      if ( $l6ups>0 ) {print "$resonator->{slot},6\n";$l6ups--;} else {
                        if ( $l5ups>0 ) {print "$resonator->{slot},5\n";$l5ups--;}     }}}
                  }
                  case 63 {
                    if ( $l8ups>0 ) {print "$resonator->{slot},8\n";$l8ups--;} else {
                     if ( $l7ups>0 ) {print "$resonator->{slot},7\n";$l7ups--;} else {
                      if ( $l6ups>0 ) {print "$resonator->{slot},6\n";$l6ups--;} else {
                       if ( $l5ups>0 ) {print "$resonator->{slot},5\n";$l5ups--;} else {
                        if ( $l4ups>0 ) {print "$resonator->{slot},4\n";$l4ups--;}      }}}}
                  }
                  case 62 {
                    if ( $l8ups>0 ) {print "$resonator->{slot},8\n";$l8ups--;} else {
                     if ( $l7ups>0 ) {print "$resonator->{slot},7\n";$l7ups--;} else {
                      if ( $l6ups>0 ) {print "$resonator->{slot},6\n";$l6ups--;} else {
                       if ( $l5ups>0 ) {print "$resonator->{slot},5\n";$l5ups--;} else {
                        if ( $l4ups>0 ) {print "$resonator->{slot},4\n";$l4ups--;}      }}}}

                  }
                  case 61 {
                    if ( $l8ups>0 ) {print "$resonator->{slot},8\n";$l8ups--;} else {
                     if ( $l7ups>0 ) {print "$resonator->{slot},7\n";$l7ups--;} else {
                      if ( $l6ups>0 ) {print "$resonator->{slot},6\n";$l6ups--;} else {
                       if ( $l5ups>0 ) {print "$resonator->{slot},5\n";$l5ups--;} else {
                        if ( $l4ups>0 ) {print "$resonator->{slot},4\n";$l4ups--;}      }}}}
                  }
                  case 0 {
                    if ( $l8ups>0 ) {print "$resonator->{slot},8\n";$l8ups--;} 
                    elsif ( $l7ups>0 ) {print "$resonator->{slot},7\n";$l7ups--;} 
                    elsif ( $l6ups>0 ) {print "$resonator->{slot},6\n";$l6ups--;} 
                    elsif ( $l5ups>0 ) {print "$resonator->{slot},5\n";$l5ups--;} 
                    elsif ( $l4ups>0 ) {print "$resonator->{slot},4\n";$l4ups--;}
                    elsif ( $l3ups>0 ) {print "$resonator->{slot},3\n";$l3ups--;}
                    elsif ( $l2ups>0 ) {print "$resonator->{slot},2\n";$l2ups--;}
                    elsif ( $l1ups>0 ) {print "$resonator->{slot},1\n";$l1ups--;}
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
