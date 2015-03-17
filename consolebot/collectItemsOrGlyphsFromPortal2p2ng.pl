#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
use Data::Dumper;
my $knobsyncts=`cat knobsyncts.txt|tr -d "\r\n"`;
my $HEXLATE6=$ARGV[0];
my $HEXLONE6=$ARGV[1];
my $PORTALGUID=$ARGV[2];
binmode(STDOUT, ":utf8");
open (RESPONSEFILE, "response/collectItemsOrGlyphsFromPortal");
open (GLYPHSFILE, "maps/glyphs.json");
my $glyphsjson = decode_json(join '', <GLYPHSFILE>);
chomp $glyphsjson;
my $json = decode_json(join '', <RESPONSEFILE>);
my @glyphSequence;
my $glyphSequence=\@glyphSequence;
my $glyphSequence=$json->{result}{glyphs}{glyphSequence};
my $energyGlobTimestamp=$json->{gameBasket}{energyGlobTimestamp};
print STDERR "glyph sequence is $glyphSequence  \n";
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
$request->{params}{glyphGameRequested}=JSON::XS::false;
$request->{params}{userInputGlyphSequence}{bypassed}=JSON::XS::false;
$request->{params}{userInputGlyphSequence}{glyphSequence}=$glyphSequence;
my $numglyphs=0;
foreach my $loopvar (@{$request->{params}{userInputGlyphSequence}{glyphSequence}}) {
  $numglyphs++;
}
print STDERR "glyphs total: $numglyphs \n";
for ( my $i = 0; $i < $numglyphs; $i++ ) {
#  print Dumper($glyphSequence);
  my $curglypharray=@{$glyphsjson}[$numglyphs-1];
  my $curglyph=@{$curglypharray}[$i];
  $request->{params}{userInputGlyphSequence}{glyphSequence}[$i]{glyphOrder}=$curglyph;
}
$request->{params}{userInputGlyphSequence}{inputTimeMs}=2500;
my $json_string    = encode_json($request);
print $json_string;
close(FILE);
