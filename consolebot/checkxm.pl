#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
binmode(STDOUT, ":utf8");
open (RESPONSEFILE, "$ARGV[0]");
my $json = decode_json(join '', <RESPONSEFILE>);
my $xm;
$xm=$json->{gameBasket}{playerEntity}[2]{playerPersonal}{energy};
my $ap=$json->{gameBasket}{playerEntity}[2]{playerPersonal}{ap};
if ( $xm >0 ) {
  open (XMFILE, '>xm.txt');
  print XMFILE $xm."\n";
  print "xm left: $xm \n";
  close (XMFILE);
} 
else {
  print "hack required no items ? \n";
}
open (APFILE, '>ap.txt');
print APFILE $ap."\n";
print "ap: $ap \n";
close (APFILE);
