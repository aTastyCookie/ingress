#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
use Data::Dumper;
use Switch;
use DateTime;
use bin::Ingress::Item;
my $item=new Ingress::Item;
my $knobsyncts=`cat knobsyncts.txt|tr -d "\r"`;
chop $knobsyncts;
my $PGUID=$ARGV[1];
binmode(STDOUT, ":utf8");
open (RESPONSEFILE, "$ARGV[0]");
my $json = decode_json(join '', <RESPONSEFILE>);
my $myguid=$json->{gameBasket}{playerEntity}[0];
my $myteam=$json->{gameBasket}{playerEntity}[2]{controllingTeam}{team};
my @resonatorsup;
#print "working with pguid $myguid, playing for $myteam\n";
foreach my $rec (@{$json->{gameBasket}{gameEntities}}) {
  my ($guid, $time, $entity) = @$rec;
#	print Dumper($rec);
  switch ($guid) {
    case /[0-9a-z]{32}.4/ {
      my $latitude=$entity->{locationE6}{latE6}/1000000;
      my $longitude=$entity->{locationE6}{lngE6}/1000000;
      my $itemtype=$item->type($entity);
      print "$latitude,$longitude,$guid,$itemtype\n";

    }
  else {
    }
  } #switch entityguid
} #foreach myrec

#my $json_string    = encode_json($request);
#print $json_string;
