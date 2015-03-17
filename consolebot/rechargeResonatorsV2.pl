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
print STDERR "will try to found blob\n";
if (!-e "maps/portalhackblobs/".$ARGV[2]) {
  print STDERR "File $ARGV[2] does not exist \n";
  $ARGV[2]='protoblob';
  #exit 1;
}
print STDERR "found file\n";
open (BLOBFILE, "maps/portalhackblobs/".$ARGV[2]);
my $blobjson = decode_json(join '', <BLOBFILE>);
my $blob=$blobjson->{params}{clientBasket}{clientBlob};
my $bloblocation=$blobjson->{params}{location};
#print STDERR $bloblocation;


#my %request;
#my $request=\%request;
$request->{params}{energyGlobGuids}=[];
$request->{params}{location}="$HEXLATE6,$HEXLONE6";
#$request->{params}{location}=$bloblocation;
$request->{params}{knobSyncTimestamp}=$knobsyncts;
$request->{params}{clientBasket}{clientBlob}=$blob;
$request->{params}{portalKeyGuid}=undef;
$request->{params}{portalGuid}=$PORTALGUID;
#$request->{params}{playerLocation}=;
for (my $rescount = 0;$rescount<8;$rescount++) {
   $request->{params}{resonatorSlots}[$rescount]=$rescount;
}
my $json_string    = encode_json($request);
print $json_string;
close(FILE);
