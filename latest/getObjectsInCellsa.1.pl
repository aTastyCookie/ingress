#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
use Data::Dumper;
use Switch;
use DateTime;
use POSIX;
my  $MYLEVEL=`bin/getmylevel.sh`;
my  $MAXXM=2000+$MYLEVEL*1000;
my $knobsyncts=`cat knobsyncts.txt|tr -d "\r"`;
chop $knobsyncts;
my $HEXLATE6=$ARGV[2];
my $HEXLONE6=$ARGV[3];
binmode(STDOUT, ":utf8");
open (RESPONSEFILE, "$ARGV[0]");
my $json = decode_json(join '', <RESPONSEFILE>);
my $energyGlobTimestamp=$json->{gameBasket}{energyGlobTimestamp};
my $xm=$json->{gameBasket}{playerEntity}[2]{playerPersonal}{energy};
open (XMFILE, '>xm.txt');
print XMFILE $xm."\n";
close (XMFILE);
my $result=$json->{gameBasket}{energyGlobGuids};
my %request;
my $request=\%request;
$request->{params}{knobSyncTimestamp}=$knobsyncts;
$request->{params}{cells}=undef;
$request->{params}{clientBasket}{clientBlob}=undef;
$request->{params}{playerLocation}="$HEXLATE6,$HEXLONE6";
#this code below is very dirty, need to fix it
my $deltaxm=$MAXXM-$xm;
my $numguids=floor($deltaxm/50);
print  "need $deltaxm xm \n";
print  "aprox $numguids guids \n";
my $guidcount=0;
#my @guidsarray=$json->{gameBasket}{energyGlobGuids};
#foreach my $curxmguid (@guidsarray) {
#  print "hello \n";
#}
#print Dumper($json->{gameBasket}{energyGlobGuids});
open (CELLOGFILE, '>>cell.log');
print "using following xmguids: \n";
foreach (@{$json->{gameBasket}{energyGlobGuids}}) {
  my $curxmguid=$_;
  $curxmguid=~ /([0-9a-z]{11})00000000([0-9a-z]{5})000000([0-9a-z]{2}).6/;
  my $curxmsize = $3;
  print CELLOGFILE time,",",$energyGlobTimestamp,",",$curxmguid,"\n"; 
  my $curxmsizedecimal=hex($curxmsize);
  if ($curxmsizedecimal < $deltaxm ) {
   $request->{params}{energyGlobGuids}[$guidcount]=$json->{gameBasket}{energyGlobGuids}[$guidcount];
   $deltaxm = $deltaxm - $curxmsizedecimal;
   print "$guidcount size $curxmsizedecimal ";
   $guidcount++;
#   print "still need  $deltaxm \n";
  }
  else {
   last;
  }
}
print "\n";

close (CELLOGFILE);
#old code for eating all xm around
#$request->{params}{energyGlobGuids}=$json->{gameBasket}{energyGlobGuids};

open (CELLSFILE, "$ARGV[1]");
my @cells = <CELLSFILE>;
chomp @cells;
close (CELLSFILE);
my $cellcounter=0;
foreach my $cellid (@cells) {
        $request->{params}{dates}[$cellcounter]=$energyGlobTimestamp;
        $request->{params}{cellsAsHex}[$cellcounter]=$cellid;
        $cellcounter++;
}

#print Dumper($result), length($result), "\n";
#print Dumper(%{$json});
#print %{$json->{result}};
#foreach my $curxmid  (@$result) {
#   print "xm with id $curxmid \n";
#   push ($request->{params}{energyGlobGuids},$curxmid);
#}
my $json_string    = encode_json($request);
open (PAYLOAD, '>payload');
print PAYLOAD $json_string;
close (PAYLOAD);
