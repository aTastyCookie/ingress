#!/usr/bin/perl
use strict;
use JSON::XS;
use Data::Dumper;
binmode(STDOUT, ":utf8");
open (RESPONSEFILE, "$ARGV[0]");
my $KEYID=$ARGV[1];
my $json = decode_json(join '', <RESPONSEFILE>);

my $response=$json->{result}{$KEYID};

print $response."\n";

exit 0;


