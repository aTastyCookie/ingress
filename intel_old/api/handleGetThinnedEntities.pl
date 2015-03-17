#!/usr/bin/perl
use strict;
use JSON::XS;
use Data::Dumper;
use Switch;
use open qw/:std :utf8/;
use utf8;
use Encode qw( encode_utf8 );
binmode(STDOUT, ":utf8");
open (CURJSON, "response/getThinnedEntities");
my $json = decode_json(join '', <CURJSON>);
close (CURJSON);
my $exitcode=0;
foreach my $qk (keys %{$json->{result}{"map"}}) {
  if ( $json->{result}{"map"}{$qk}->{error} eq 'TIMEOUT' ) {
    print "$qk timeout \n";
    $exitcode=1;
  }
  else {
      my $result->{map}{$qk}=$json->{result}{"map"}{$qk};
      open (CURQK, ">tempjsons/$qk");
      my $json_string    = encode_json($result);
      print CURQK $json_string; 
      close CURQK;
    }
}
#print Dumper ($finaljson);
#print Dumper($gameentities);
