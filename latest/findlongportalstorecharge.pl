#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
use Data::Dumper;
use Switch;
use utf8;
use bin::Ingress::Link;
use bin::Ingress::Field;
my %linkshtml;
my $linkshtml=\%linkshtml;
my $file = $ARGV[0] ;
  open(FILE, "$file") or die "Can't read file 'filename' [$file]\n";  
  my $document = <FILE>; 

my $json = decode_json($document);
#print Dumper($json);

# was for intel my @entities = map { @{$_->{gameEntities}} } values %{$json->{result}{"map"}};
my $n=0;
#was for intel foreach my $rec (@entities) {
foreach my $rec (@{$json->{gameBasket}{gameEntities}})  {
  my ($guid, $time, $entity) = @$rec;
  switch ($guid) {
    case /[0-9a-z]{32}.1[1-6]/ {
    } 
    case /[0-9a-z]{32}.9/ {
      my $link=new Ingress::Link;
      my $linklength=$link->length($entity);
      my $ctime=$link->ctime($entity);
      my $linkage=1368397824-$ctime/1000;
      #if ($linklength > 2 and $linkage<28800) {
      my $srclat=$link->srclat($entity);
      my $srclon=$link->srclon($entity);
      my $dstlat=$link->dstlat($entity);
      my $dstlon=$link->dstlon($entity);
      my $team=$entity->{controllingTeam}{team};
      my $linksrclatitude=$entity->{edge}{originPortalLocation}{latE6}/1000000;
      my $linksrclongitude=$entity->{edge}{originPortalLocation}{lngE6}/1000000;
      my $linkdstlatitude=$entity->{edge}{destinationPortalLocation}{latE6}/1000000;
      my $linkdstlongitude=$entity->{edge}{destinationPortalLocation}{lngE6}/1000000;
      my $destinationPortalGuid=$entity->{edge}{destinationPortalGuid};
      my $originPortalGuid=$entity->{edge}{originPortalGuid};
      if ($team eq "ALIENS") {
      }
      if ($team eq "RESISTANCE") {
        if ($linklength > 20000) {
          print "link,$team,$srclat,$srclon,$dstlat,$dstlon,$linklength,$originPortalGuid,$destinationPortalGuid\n";
        }
      }
    }
    case /[0-9a-z]{32}.b/ {
    }
    else {
    }
  }
}
