#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
my $knobsyncts=`cat knobsyncts.txt|tr -d "\r\n"`;
my $HEXLATE6=$ARGV[0];
my $HEXLONE6=$ARGV[1];
my $MISSIONGUID=$ARGV[2];
my $RATING=$ARGV[3];
#open (BLOBFILE, "maps/portalhackblobs/".$ARGV[3]);
#my $blobjson = decode_json(join '', <BLOBFILE>);
#my $blob=$blobjson->{params}{clientBasket}{clientBlob};

binmode(STDOUT, ":utf8");
my %request;
my $request=\%request;
$request->{params}{rating}=$RATING*100/100;
$request->{params}{missionGuid}=$MISSIONGUID;
$request->{params}{energyGlobGuids}=[];
$request->{params}{knobSyncTimestamp}=$knobsyncts;
$request->{params}{location}="$HEXLATE6,$HEXLONE6";
$request->{params}{clientBasket}{clientBlob}=undef;
my $json_string    = encode_json($request);
print $json_string;
close(FILE);
