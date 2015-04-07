#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
use Data::Dumper;
use Switch;
use DateTime;
binmode(STDOUT, ":utf8");
open (RESPONSEFILE, "$ARGV[0]");
my $json = decode_json(join '', <RESPONSEFILE>);
my $error=$json->{error};
if (defined $error) {
  print $error,"\n";
  exit 1;
}
exit 0;
