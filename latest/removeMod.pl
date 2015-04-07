#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
use Data::Dumper;
use Switch;
use DateTime;

my $HEXLATE6=$ARGV[0];
my $HEXLONE6=$ARGV[1];
my $PORTALGUID=$ARGV[2];
my $SLOTID=$ARGV[3];
binmode(STDOUT, ":utf8");
my %request;
my $request=\%request;
my $knobsyncts=`cat knobsyncts.txt|tr -d "\r"`;
chomp $knobsyncts;
#my %request;
#my $request=\%request;
$request->{params}{energyGlobGuids}=[];
$request->{params}{playerLocation}="$HEXLATE6,$HEXLONE6";
$request->{params}{knobSyncTimestamp}=$knobsyncts;
#$request->{params}{clientBasket}{clientBlob}=undef;
$request->{params}{modableGuid}=$PORTALGUID;
$request->{params}{index}=$SLOTID;
my $json_string    = encode_json($request);
print $json_string;
