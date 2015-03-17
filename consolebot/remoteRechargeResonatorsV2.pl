#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
use Data::Dumper;
use Switch;
use DateTime;

my $HEXLATE6=$ARGV[0];
my $HEXLONE6=$ARGV[1];
my $PORTALKEYGUID=$ARGV[2];
binmode(STDOUT, ":utf8");
my %request;
my $request=\%request;
my $knobsyncts=`cat knobsyncts.txt|tr -d "\r"`;
chomp $knobsyncts;
my $ts=time;
$ts=$ts*1000;
if ( $knobsyncts < $ts-86400*10*1000 ) {
	print "too old (>10d) or invalid ts \n";
	my $nothing=`touch error.present`;
	exit 1;
}
#my %request;
#my $request=\%request;
$request->{params}{energyGlobGuids}=[];
$request->{params}{location}="$HEXLATE6,$HEXLONE6";
$request->{params}{knobSyncTimestamp}=$knobsyncts;
#$request->{params}{clientBasket}{clientBlob}=undef;
$request->{params}{portalKeyGuid}=$PORTALKEYGUID;
$request->{params}{portalGuid}=undef;
#$request->{params}{playerLocation}=;
for (my $rescount = 0;$rescount<8;$rescount++) {
   $request->{params}{resonatorSlots}[$rescount]=$rescount;
}
my $json_string    = encode_json($request);
print $json_string;
close(FILE);
