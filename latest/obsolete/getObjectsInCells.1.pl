#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
use Data::Dumper;
use Switch;
use DateTime;
my $knobsyncts=`cat knobsyncts.txt|tr -d "\r"`;
chop $knobsyncts;
my $HEXLATE6=$ARGV[2];
my $HEXLONE6=$ARGV[3];
binmode(STDOUT, ":utf8");
open (RESPONSEFILE, "$ARGV[0]");
my $json = decode_json(join '', <RESPONSEFILE>);
my $energyGlobTimestamp=$json->{gameBasket}{energyGlobTimestamp};
my $xm=$json->{gameBasket}{playerEntity}[2]{playerPersonal}{energy};
open (XMFILE, '>xm.txt');
print XMFILE $xm."\n";
close (XMFILE);
my $result=$json->{gameBasket}{energyGlobGuids};
my %request;
my $request=\%request;
$request->{params}{knobSyncTimestamp}=$knobsyncts;
$request->{params}{cells}=undef;
$request->{params}{clientBasket}{clientBlob}=undef;
$request->{params}{playerLocation}="$HEXLATE6,$HEXLONE6";
$request->{params}{energyGlobGuids}=$json->{gameBasket}{energyGlobGuids};
open (REQUESTFILE, "$ARGV[1]");
my $json2 = decode_json(join '', <REQUESTFILE>);

$request->{params}{cellsAsHex}=$json2->{params}{cellsAsHex};
$request->{params}{dates}=$json2->{params}{dates};


my $cellcounter=0;
foreach my $cellid (@{$request->{params}{cellsAsHex}}) {
        $request->{params}{dates}[$cellcounter]=$energyGlobTimestamp;
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
