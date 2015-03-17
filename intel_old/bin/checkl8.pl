#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
use Data::Dumper;
use Switch;
use Net::XMPP;
use Ingress::PortalIntel;
my $portal=new Ingress::PortalIntel;
my $con=new Net::XMPP::Client();
my @emails=(
            "valery.tereshko\@gmail.com"
           );
$con->Connect(hostname=>"jabber.ru");
$con->AuthSend(username=>"ingress.stat.minsk",
                        password=>"huyhuyhuy",
                        resource=>"ALARM!");
binmode(STDOUT, ":utf8");
open (FILEOLD, "$ARGV[0]");
open (FILENEW, "$ARGV[1]");
my $json = decode_json(join '', <FILEOLD>);
my @entities = map { @{$_->{gameEntities}} } values %{$json->{result}{"map"}};
#print Dumper(@entities);
my %portalsold;
my %portalsnew;
my $portalsold=\%portalsold;
my $portalsnew=\%portalsnew;
foreach my $rec (@entities) {
    my ($guid, $time, $entity) = @$rec;
    switch ($guid) {
      case /[0-9a-z]{32}.1[1-6]/ {
        my $latitude=$entity->{latE6}/1000000;
        my $longitude=$entity->{lngE6}/1000000;
        my $imageUrl=$entity->{image};
        my $team=$entity->{team};
        my $health=$entity->{health};
        my $level=$entity->{level};
        my $hashguid="p".$guid;
        $hashguid=~ tr/\.//d;
        $portalsold->{$hashguid}=$entity;
        $portalsold->{$hashguid}{guid}=$guid;
      } 
      case /[0-9a-z]{32}.9/ {
##        print 'link found with gid ',$guid,"\n";
      }
      case /[0-9a-z]{32}.b/ {
##        print 'field found with gid ',$guid,"\n";
      }
      else {
##        print 'this is neither portal, nor link, nor field, gid: ',$guid,"\n";
      }
    }
}
my $json = decode_json(join '', <FILENEW>);
my @entities = map { @{$_->{gameEntities}} } values %{$json->{result}{"map"}};

foreach my $rec (@entities) {
#    print "---------------------\n";
    my ($guid, $time, $entity) = @$rec;
    switch ($guid) {
      case /[0-9a-z]{32}.1[1-6]/ {
        my $latitude=$entity->{latE6}/1000000;
        my $longitude=$entity->{lngE6}/1000000;
        my $imageUrl=$entity->{image};
        my $team=$entity->{team};
#        print "team $team \n";
        my $health=$entity->{health};
        my $level=$entity->{level};
        my $hashguid="p".$guid;
        $hashguid=~ tr/\.//d;
        $portalsnew->{$hashguid}=$entity;
        $portalsnew->{$hashguid}{guid}=$guid;
      }
      case /[0-9a-z]{32}.9/ {
##        print 'link found with gid ',$guid,"\n";
      }
      case /[0-9a-z]{32}.b/ {
##        print 'field found with gid ',$guid,"\n";
      }
      else {
##        print 'this is neither portal, nor link, nor field, gid: ',$guid,"\n";
      }
    }
}

close (FILEOLD);
close (FILENEW);
#---------------------
#at this moment we have two hashes with portals - 15m ago ($portalsold) and current ($portalsnew)
#we should compare 
#---------------------
foreach my $oldkey (keys %portalsold) {
  my $portalteamnew=$portalsnew->{$oldkey}{team};
  my $portalteamold=$portalsold->{$oldkey}{team};
#  print "new $portalteamnew \n";
#  print "old $portalteamold \n";
  my $portalguid=$portalsold->{$oldkey}{guid};
  my $portaltitle=$portalsnew->{$oldkey}{title};
  my $portaltitleold=$portalsold->{$oldkey}{title};
  my $portallevelold=$portalsold->{$oldkey}{level};
  my $portallevelnew=$portalsnew->{$oldkey}{level};
  my $portalhealthold=$portalsold->{$oldkey}{health};
  my $portalhealthnew=$portalsnew->{$oldkey}{health};
  if ($portallevelnew ==8) {
   if ($portallevelold <8) {
     foreach my $email (@emails) {
       #sleep 1;
       my $msg=new Net::XMPP::Message();
       $msg->SetMessage(
         to=>$email,
         from=>"ingress.stat.minsk\@jabber.ru",
         body=>"$portalteamnew have built L8 portal at  $portaltitle ($portallevelold > $portallevelnew)"
       );
       $con->Send($msg);
       print "$portalteamnew have built L8 portal at  $portaltitle ($portallevelold > $portallevelnew)\n";
       my $res=`/var/www/thesuki.org/ingress/stats/send.sh "::  $portalteamnew have built L8 portal at  $portaltitle"`;
     }
   }
 }
#if ( $portalhealthnew < $portalhealthold ) {
# print "portal health at L$portallevelold $portaltitleold has changed from $portalhealthold to $portalhealthnew \n";
#}
if ( $portallevelnew ne $portallevelold ) { 
   print "portal level at $portaltitleold has changed from $portallevelold to $portallevelnew \n";
 }

#print "$portallevelold,$portallevelnew,$portaltitle  \n";
 if ($portallevelnew ==8) {
   if ( $portalteamold eq 'RESISTANCE' ) {
    if ($portalhealthnew > 0 ) {
     if ( $portalhealthnew < $portalhealthold ) {
       foreach my $email (@emails) {
         #sleep 1;
         my $msg=new Net::XMPP::Message();
         $msg->SetMessage(
           to=>$email,
           from=>"ingress.stat.minsk\@jabber.ru",
           body=>"L8 portal health at $portaltitleold has changed from $portalhealthold to $portalhealthnew"
         );
         if ($portalhealthnew != 40800) {
           $con->Send($msg);
         }
#         print "L8 portal health at $portaltitle has changed from $portalhealthold to $portalhealthnew \n";
       }
     }
    } 
   }
 }
#  if ($portalownerold ne $portalownernew) {
#    print $portalguid," was captured by ",$portalownernew,"\n";
#  }
}
$con->Disconnect();
