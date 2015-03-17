#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
use IO::All;
use Data::Dumper;
my $knobsyncts=`cat knobsyncts.txt|tr -d "\r\n"`;
my $HEXLATE6=$ARGV[0];
my $HEXLONE6=$ARGV[1];
my $CONTAINERGUID=$ARGV[2];
my $loadtype=$ARGV[3];
binmode(STDOUT, ":utf8");
my %request;
my $request=\%request;
my @ITEMGUIDS = io('tempitemids.txt')->slurp;
chomp(@ITEMGUIDS);
my $containerGuid=`cat inventory.txt|grep "$CONTAINERGUID"|cut -d, -f3`;
chomp($containerGuid);

if ($loadtype eq 'load') {
  $request->{params}{containerGuid}=$containerGuid;
  $request->{params}{energyGlobGuids}=[];
  $request->{params}{containerGuidsToUnload}=[];
  $request->{params}{inventoryGuidsToLoad}=[];
  $request->{params}{inventoryGuidsToLoad}=\@ITEMGUIDS;
  $request->{params}{stackableItems}=undef;
  $request->{params}{knobSyncTimestamp}=$knobsyncts;
  $request->{params}{playerLocation}="$HEXLATE6,$HEXLONE6";
}
else { 
  if($loadtype eq 'unload') {
#  my $getinv=`bin/getinventory.sh`;
  open (INVFILE, "list.unziped");
  my $invjson = decode_json(join '', <INVFILE>);
  my $result=$invjson->{gameBasket}{inventory};
  foreach my $curmessageref  (@$result) {
    my $itemguid=@$curmessageref[0];
    if ($itemguid eq $CONTAINERGUID) {
    my @CAPSULIST=@$curmessageref[2]->{container}{stackableItems}[0]{itemGuids};
     $request->{params}{containerGuid}=$containerGuid;
     $request->{params}{energyGlobGuids}=[];
#     $request->{params}{containerGuidsToUnload}=[];
     $request->{params}{containerGuidsToUnload}=@CAPSULIST[0]; 
     $request->{params}{inventoryGuidsToLoad}=[];
     $request->{params}{stackableItems}=undef;
     $request->{params}{knobSyncTimestamp}=$knobsyncts;
     $request->{params}{playerLocation}="$HEXLATE6,$HEXLONE6";
    }
  }
 }
}
my $json_string    = encode_json($request);
print $json_string;
close(FILE);
