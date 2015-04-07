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
my $ap=$json->{result}{ap};
my $Visited=$json->{result}{metrics}[0]{formattedValueAllTime};
my $Discovered=$json->{result}{metrics}[1]{formattedValueAllTime};
my $Collected=$json->{result}{metrics}[2]{formattedValueAllTime};
my $Hacked=$json->{result}{metrics}[3]{formattedValueAllTime};
my $Deployed=$json->{result}{metrics}[4]{formattedValueAllTime};
my $Linked=$json->{result}{metrics}[5]{formattedValueAllTime};
my $Fielded=$json->{result}{metrics}[6]{formattedValueAllTime};
my $RDestroyed=$json->{result}{metrics}[7]{formattedValueAllTime};
my $LDestroyed=$json->{result}{metrics}[8]{formattedValueAllTime};
my $FDestroyed=$json->{result}{metrics}[9]{formattedValueAllTime};
my $Distance=$json->{result}{metrics}[10]{formattedValueAllTime};
my $Defence=$json->{result}{metrics}[11]{formattedValueAllTime};



print "$ARGV[0] :: $ap :: $Visited :: $Discovered :: $Collected :: $Hacked :: $Deployed :: $Linked :: $Fielded :: $RDestroyed :: $LDestroyed :: $FDestroyed :: $Distance :: $Defence \n";
exit 0;
