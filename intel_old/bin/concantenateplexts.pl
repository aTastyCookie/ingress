#!/usr/bin/perl
use strict;
use JSON::XS;
use Data::Dumper;
use Switch;
use open qw/:std :utf8/;
use utf8;
use Encode qw( encode_utf8 );
binmode(STDOUT, ":utf8");
opendir(DH, "plexts");
my @files = readdir(DH);
closedir(DH);
my %gameplexts;
my $gameplexts=\%gameplexts;
foreach my $file (@files) {
  next if($file =~ /^\.$/);
  next if($file =~ /^\.\.$/);
  open (CURJSON, "plexts/$file");
  my $json = decode_json(join '', <CURJSON>);
  close (CURJSON);
    foreach my $rec (@{$json->{success}}) {
      my ($guid, $time, $entity) = @$rec;
      #check if there is already such guid from previous qk
          $gameplexts->{$guid}{guid}=$guid;
          $gameplexts->{$guid}{time}=$time;
          $gameplexts->{$guid}{entity}=$entity;
  }
}

my %finaljson;
my $finaljson=\%finaljson;
$finaljson->{success}=[];
$finaljson->{gameBasket}{deletedEntityGuids}=[];
$finaljson->{result}{map}{666}{gameEntities}=[];
foreach my $key (keys %{ $gameplexts }) {
  my @currentportal=($gameplexts->{$key}{guid},$gameplexts->{$key}{time},$gameplexts->{$key}{entity});
  my $currentportal=\@currentportal;
  #print ($currentportal[2]{portalV2}{descriptiveText}{TITLE});
  #print $gameplexts->{$key}{entity}{portalV2}{descriptiveText}{TITLE},"\n";
  #print Dumper($gameplexts->{$key}{entity}{portalV2}{descriptiveText}{TITLE});
  #print Dumper (@currentportal);
  push(@{$finaljson->{success}}, [@currentportal]);
}
#print Dumper ($finaljson);
my $finaljsonstring=JSON::XS->new->utf8(0)->encode($finaljson);
print $finaljsonstring;
#print Dumper($gameplexts);
