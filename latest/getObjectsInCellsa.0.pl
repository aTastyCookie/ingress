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

my @cells = <FILE>;
chomp @cells;
my $knobsyncts=`cat knobsyncts.txt|tr -d "\r"`;
chomp $knobsyncts;
my $ts=time;
$ts=$ts*1000;
if ( $knobsyncts < $ts-86400*10*1000 ) {
	print "too old (>10d) or invalid ts \n";
	my $nothing=`touch error.present`;
	exit 1;
}
print STDERR "will try to found blob\n";
open (BLOBFILE, "maps/scanblobs/m1");
my $blobjson = decode_json(join '', <BLOBFILE>);
my $blob=$blobjson->{params}{clientBasket}{clientBlob};
my $bloblocation=$blobjson->{params}{playerLocation};


my %request;
my $request=\%request;
$request->{params}{knobSyncTimestamp}=$knobsyncts+0;
#$request->{params}{knobSyncTimestamp}=1389187124887;
$request->{params}{cells}=undef;
$request->{params}{clientBasket}{clientBlob}=$blob;;
$request->{params}{playerLocation}="$HEXLATE6,$HEXLONE6";
#$request->{params}{playerLocation}=$bloblocation;
$request->{params}{energyGlobGuids}=[];
my $cellcounter=0;
foreach my $cellid (@cells) {
	$request->{params}{dates}[$cellcounter]=0;
        $request->{params}{cellsAsHex}[$cellcounter]=$cellid;
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
