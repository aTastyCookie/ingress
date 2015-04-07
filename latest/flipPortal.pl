#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
my $knobsyncts=`cat knobsyncts.txt|tr -d "\r\n"`;
my $HEXLATE6=$ARGV[0];
my $HEXLONE6=$ARGV[1];
my $ITEMGUID=$ARGV[2];
my $PORTALGUID=$ARGV[3];
binmode(STDOUT, ":utf8");
print STDERR "will try to found blob\n";
if (!-e "maps/portalhackblobs/".$ARGV[3]) {   
  print STDERR "File $ARGV[3] does not exist \n";   
  $ARGV[3]='protoblob';
#  exit 1;   
}   
open (BLOBFILE, "maps/portalhackblobs/".$ARGV[3]);
my $blobjson = decode_json(join '', <BLOBFILE>);
my $blob=%{$blobjson}->{params}{clientBasket}{clientBlob};
my $bloblocation=%{$blobjson}->{params}{location};
my %request;
my $request=\%request;
$request->{params}{resourceGuid}=$ITEMGUID;
$request->{params}{portalGuid}=$PORTALGUID;
$request->{params}{energyGlobGuids}=[];
$request->{params}{knobSyncTimestamp}=$knobsyncts;
$request->{params}{playerLocation}="$HEXLATE6,$HEXLONE6";
#$request->{params}{playerLocation}=$bloblocation;
$request->{params}{clientBasket}{clientBlob}=$blob;
my $json_string    = encode_json($request);
print $json_string;
close(FILE);
