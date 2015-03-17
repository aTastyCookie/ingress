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
open (FINALRESPONSEFILE, "response/collectItemsFromPortalWithGlyphResponse");
open (RESPONSEFILE, "response/collectItemsOrGlyphsFromPortal");
my $json = decode_json(join '', <RESPONSEFILE>);
my $finaljson = decode_json(join '', <FINALRESPONSEFILE>);
my $glyphSequence=$json->{result}{glyphs}{glyphSequence};
my $glyphSequencenames=$finaljson->{result}{glyphResponse}{displayNames};
my $glresult=$finaljson->{result}{glyphResponse}{glyphResponses};
my $glcnt=0;
foreach my $glyph(@{$glyphSequencenames}) {
  print "@{$glyphSequence}[$glcnt]->{glyphOrder},";
  print "@{$glyphSequencenames}[$glcnt],";
  print "@{$glresult}[$glcnt];";
  $glcnt++;
}
print "\n";
