#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
my $knobsyncts=`cat knobsyncts.txt|tr -d "\r\n"`;
my $HEXLATE6=$ARGV[0];
my $HEXLONE6=$ARGV[1];
my $PORTALGUID=$ARGV[2];
binmode(STDOUT, ":utf8");
print STDERR "will try to found blob\n";
if (!-e "maps/portalhackblobs/".$ARGV[2]) {
  print STDERR "File $ARGV[2] does not exist \n";
  $ARGV[2]='protoblob';
  #exit 1;
}
open (BLOBFILE, "maps/portalhackblobs/".$ARGV[2]);
my $blobjson = decode_json(join '', <BLOBFILE>);
my $blob=%{$blobjson}->{params}{clientBasket}{clientBlob};
my $bloblocation=%{$blobjson}->{params}{location};
my %request;
my $request=\%request;
$request->{params}{portalGuid}=$PORTALGUID;
$request->{params}{energyGlobGuids}=undef;
$request->{params}{knobSyncTimestamp}=$knobsyncts;
$request->{params}{location}="$HEXLATE6,$HEXLONE6";
#$request->{params}{location}=$bloblocation;
$request->{params}{clientBasket}{clientBlob}=$blob;
$request->{params}{glyphGameRequested}=JSON::XS::true;
$request->{params}{userInputGlyphSequence}=undef;
my $json_string    = encode_json($request);
print $json_string;
close(FILE);
