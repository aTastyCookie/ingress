#!/usr/bin/perl
use strict;
use JSON::XS;
use Data::Dumper;
use Switch;
use open qw/:std :utf8/;
use bytes;
use Encode qw( encode_utf8 );
binmode(STDOUT, ":utf8");
opendir(DH, "mapres");
my @files = readdir(DH);
closedir(DH);
my %gameentities;
my $gameentities=\%gameentities;
foreach my $file (@files) {
#  print "$file \n";
  next if($file =~ /^\.$/);
  next if($file =~ /^\.\.$/);
  open (CURJSON, "mapres/$file");
  my $json = decode_json(join '', <CURJSON>);
  close (CURJSON);
  foreach my $rec (@{$json->{result}}) {
    my ($guid, $time, $entity) = @$rec;
    $gameentities->{$guid}{guid}=$guid;
    $gameentities->{$guid}{time}=$time;
    $gameentities->{$guid}{entity}=$entity;
  }
}
my %finaljson;
my $finaljson=\%finaljson;
$finaljson->{gameBasket}{inventory}=[];
$finaljson->{gameBasket}{gameEntities}=[];
$finaljson->{gameBasket}{deletedEntityGuids}=[];
$finaljson->{result}{map}{666}{gameEntities}=[];
foreach my $key (keys %{ $gameentities }) {
  my @currentportal=($gameentities->{$key}{guid},$gameentities->{$key}{time},$gameentities->{$key}{entity});
  my $currentportal=\@currentportal;
  #print ($currentportal[2]{portalV2}{descriptiveText}{TITLE});
#  $currentportal[2]{portalV2}{descriptiveText}{TITLE}=$gameentities->{$key}{entity}{portalV2}{descriptiveText}{TITLE};
  #print $gameentities->{$key}{entity}{portalV2}{descriptiveText}{TITLE},"\n";
  #print Dumper($gameentities->{$key}{entity}{portalV2}{descriptiveText}{TITLE});
  #print Dumper (@currentportal);
  push(@{$finaljson->{result}{map}{666}{gameEntities}}, [@currentportal]);
  push(@{$finaljson->{gameBasket}{gameEntities}}, [@currentportal]);
}
#print Dumper ($finaljson);
my $finaljsonstring=JSON::XS->new->utf8(0)->encode($finaljson);
print $finaljsonstring;
#print Dumper($gameentities);
