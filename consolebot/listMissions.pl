#!/usr/bin/perl
use strict;
use JSON::XS;
use Encode;
use Data::Dumper;
use Switch;
use Geo::Distance;
use bin::Ingress::Portal;
use POSIX;
binmode(STDOUT, ":utf8");

open (FILENEW, "response/getNearbyMissions");
my $json = decode_json(join '', <FILENEW>);
my %portalsnew;
my $portalsnew=\%portalsnew;
my %portalsl8;
my $portalsl8=\%portalsl8;
#print Dumper(%portalsl8);
my %mission;
my $mission=\%mission;
foreach my $rec (@{$json->{result}{missionSnippets}}) {
#    print "---------------------\n";
    #print Dumper ($rec);
    my $missionversion=$rec->{version};
    my $missionguid=$rec->{header}{guid};
    my $missiontitle=$rec->{header}{title};
    my $missionteam=$rec->{header}{authorTeam};
    my $missionauthor=$rec->{header}{authorNickname};
    print "$missionguid,$missionteam,$missionauthor,$missiontitle\n";
}
close (FILENEW);
