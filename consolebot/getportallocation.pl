#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
use Data::Dumper;
use Switch;
use utf8;
use bin::Ingress::Link;
use bin::Ingress::Field;
use bin::Ingress::Portal;
binmode STDOUT, ":utf8";
my $file = $ARGV[0] ;
  open(FILE, "$file") or die "Can't read file 'filename' [$file]\n";  
  my $document = <FILE>; 
my $portalguid= $ARGV[1];
my $json = decode_json($document);
#was for intel foreach my $rec (@entities) {
foreach my $rec (@{$json->{gameBasket}{gameEntities}})  {
  my ($guid, $time, $entity) = @$rec;
  if ($guid eq $portalguid ) {
  my $portal=new Ingress::Portal;
   my $plat=$portal->lat($entity);
   my $plon=$portal->lon($entity);
   my $ptitle=$portal->title($entity);
   my $paddr=$portal->address($entity);
  print "#$ptitle,$paddr:\n";
  print "$plat,$plon,60,$portalguid\n";
  }
}
