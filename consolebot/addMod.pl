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
my $ITEMGUID=$ARGV[4];
binmode(STDOUT, ":utf8");
print STDERR "will try to found blob\n";
if (!-e "maps/portalhackblobs/".$ARGV[2]) {
  print STDERR "File $ARGV[2] does not exist \n";
  $ARGV[2]='protoblob';
  #exit 1;
}
print STDERR "found file\n";

open (BLOBFILE, "maps/portalhackblobs/".$ARGV[2]);
my $blobjson = decode_json(join '', <BLOBFILE>);
my $blob=%{$blobjson}->{params}{clientBasket}{clientBlob};
my $bloblocation=%{$blobjson}->{params}{location};
my %request;
my $request=\%request;
my $knobsyncts=`cat knobsyncts.txt|tr -d "\r"`;
chomp $knobsyncts;
#my %request;
#my $request=\%request;
$request->{params}{energyGlobGuids}=[];
$request->{params}{playerLocation}="$HEXLATE6,$HEXLONE6";
#$request->{params}{playerLocation}=$bloblocation;
$request->{params}{clientBasket}{clientBlob}=$blob;
$request->{params}{knobSyncTimestamp}=$knobsyncts;
#$request->{params}{clientBasket}{clientBlob}=undef;
$request->{params}{modResourceGuid}=$ITEMGUID;
$request->{params}{modableGuid}=$PORTALGUID;
$request->{params}{index}=$SLOTID;
#$request->{params}{playerLocation}=;
my $json_string    = encode_json($request);
print $json_string;
