#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
use Data::Dumper;
use Switch;
use DateTime;

binmode(STDOUT, ":utf8");
open (FILE, "$ARGV[0]");
my $HEXLATE6=$ARGV[1];
my $HEXLONE6=$ARGV[2];

my $json = decode_json(join '', <FILE>);
my $request=$json;
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
$request->{params}{knobSyncTimestamp}=$knobsyncts;
$request->{params}{cells}=undef;
$request->{params}{clientBasket}{clientBlob}=undef;
#$request->{params}{playerLocation}=;
$request->{params}{playerLocation}="$HEXLATE6,$HEXLONE6";
$request->{params}{energyGlobGuids}=[];
my $cellcounter=0;
foreach my $cellid (@{$request->{params}{cellsAsHex}}) {
	$request->{params}{dates}[$cellcounter]=0;
	$cellcounter++;
}

#print Dumper($result), length($result), "\n";
#print Dumper(%{$json});
#print %{$json->{result}};
#foreach my $curxmid  (@$result) {
#   print "xm with id $curxmid \n";
#   push ($request->{params}{energyGlobGuids},$curxmid);
#}
my $json_string    = encode_json($request);
print $json_string;
close(FILE);
