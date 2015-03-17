package Ingress::PortalIntel;
{
  $Ingress::PortalIntel::VERSION = '0.20';
}
use strict;
use warnings;
use Geo::Distance;
=head1 NAME

Ingress::PortalIntel - Calculate Distances and Closest Locations

=head1 SYNOPSIS

  use Ingress::PortalIntel;
  my $geo = new Ingress::PortalIntel;
  $geo->formula('hsin');
  $geo->reg_unit( 'toad_hop', 200120 );
  $geo->reg_unit( 'frog_hop' => 6 => 'toad_hop' );
  my $distance = $geo->distance( 'unit_type', $lon1,$lat1 => $lon2,$lat2 );
  my $locations = $geo->closest(
    dbh => $dbh,
    table => $table,
    lon => $lon,
    lat => $lat,
    unit => $unit_type,
    distance => $dist_in_unit
  );

=head1 DESCRIPTION

This perl library aims to provide as many tools to make it as simple as possible to calculate 
distances between geographic points, and anything that can be derived from that.  Currently 
there is support for finding the closest locations within a specified distance, to find the 
closest number of points to a specified point, and to do basic point-to-point distance 
calculations.

=head1 DECOMMISSIONED

The L<GIS::Distance> module is being worked on as a replacement for this module.  In the
near future Ingress::PortalIntel will become a lightweight wrapper around GIS::Distance so that
legacy code benefits from fixes to GIS::Distance through the old Ingress::PortalIntel API.  For
any new developement I suggest that you look in to GIS::Distance.

=head1 STABILITY

The interface to Ingress::PortalIntel is fairly stable nowadays.  If this changes it 
will be noted here.

0.10 - The closest() method has a changed argument syntax and no longer supports array searches.
0.09 - Changed the behavior of the reg_unit function.
0.07 - OO only, and other changes all over.

=cut

use Carp;
use Math::Trig qw( great_circle_distance deg2rad rad2deg acos pi asin tan atan );
use constant KILOMETER_RHO => 6371.64;

=head1 PROPERTIES

=head2 UNITS

All functions accept a unit type to do the computations of distance with.  By default no units 
are defined in a Ingress::PortalIntel object.  You can add units with reg_unit() or create some default 
units with default_units().

=head2 LATITUDE AND LONGITUDE

When a function needs a longitude and latitude, they must always be in decimal degree format.
Here is some sample code for converting from other formats to decimal:

  # DMS to Decimal
  my $decimal = $degrees + ($minutes/60) + ($seconds/3600);
  
  # Precision Six Integer to Decimal
  my $decimal = $integer * .000001;

If you want to convert from decimal radians to degrees you can use Math::Trig's rad2deg function.

=head1 METHODS

=head2 new

  my $geo = new Ingress::PortalIntel;
  my $geo = new Ingress::PortalIntel( no_units=>1 );

Returns a blessed Ingress::PortalIntel object.  The new constructor accepts one optional 
argument.

  no_units - Whether or not to load the default units. Defaults to 0 (false).
             kilometer, kilometre, meter, metre, centimeter, centimetre, millimeter, 
             millimetre, yard, foot, inch, light second, mile, nautical mile, 
             poppy seed, barleycorn, rod, pole, perch, chain, furlong, league, 
             fathom

=cut

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    my %args = @_;
    
    $self->{formula} = 'hsin';
    $self->{units} = {};
    # Number of units in a single degree (lat or lon) at the equator.
    # Derived from: $geo->distance( 'kilometer', 10,0, 11,0 ) / $geo->{units}->{kilometer}
    $self->{deg_ratio} = 0.0174532925199433;

    return $self;
}

=head2 distance

  my $distance = $geo->distance( 'unit_type', $lon1,$lat1 => $lon2,$lat2 );

Calculates the distance between two lon/lat points.

=cut
sub team {
    my($self,$portalhash) = @_;
    return $portalhash->{controllingTeam}{team};
}
sub title {
    my($self,$portalhash) = @_;
    my $portaltitle=$portalhash->{descriptiveText}{map}{TITLE};
    chop($portaltitle);
    $portaltitle=~ tr/\n\'\"|\’\\\///d;
    return $portaltitle;
}
sub address {
    my($self,$portalhash) = @_;
    my $portaladdress=$portalhash->{descriptiveText}{map}{ADDRESS};
    chop($portaladdress);
    $portaladdress=~ tr/\n\'\"|\’\\\///d;
    return $portaladdress;
}
sub level {
    my($self,$portalhash) = @_;
    my $ressum=0;
    for(my $i = 0; $i < 8; $i++) {
        my $resonator=$portalhash->{resonatorArray}{resonators}[$i];
        if ( defined $resonator ) {
            my $resonatorlevel=$portalhash->{resonatorArray}{resonators}[$i]{level};
#            print $resonatorlevel;
            $ressum+=$resonatorlevel;
          }
        }
    if ($ressum <8 and $ressum >0) {
      return (1);
    }
    return($ressum/8);
}

sub health {
    my($self,$portalhash) = @_;
    my $reshealth=0;
    for(my $i = 0; $i < 8; $i++) {
        my $resonator=$portalhash->{resonatorArray}{resonators}[$i];
        if ( defined $resonator ) {
            my $resonatorhealth=$portalhash->{resonatorArray}{resonators}[$i]{energyTotal};
            $reshealth+=$resonatorhealth;
          }
        }
    return($reshealth);
}

sub maxhealth {
    my($self,$portalhash) = @_;
    my $resmaxhealth=0;
    my @resxm=(0,1000,1500,2000,2500,3000,4000,5000,6000);
    for(my $i = 0; $i < 8; $i++) {
        my $resonator=$portalhash->{resonatorArray}{resonators}[$i];
        if ( defined $resonator ) {
            my $resonatorlevel=$portalhash->{resonatorArray}{resonators}[$i]{level};
            $resmaxhealth+=$resxm[$resonatorlevel];
          }
        }
    return($resmaxhealth);
}


sub mitigation {
    my($self,$portalhash) = @_;
    my $portalmitigation=0;
    for(my $i = 0; $i < 4; $i++) {
        my $mod=$portalhash->{portalV2}{linkedModArray}[$i];
        if ( defined $mod ) {
            if ( $mod->{type} eq 'RES_SHIELD' ) {
                $portalmitigation=$portalmitigation+$mod->{stats}{MITIGATION};
            }
        }
    }
    return $portalmitigation;
}

sub multihack {
    my($self,$portalhash) = @_;
    my $portalmultihack=0;
    for(my $i = 0; $i < 4; $i++) {
        my $mod=$portalhash->{portalV2}{linkedModArray}[$i];
        if ( defined $mod ) {
            if ( $mod->{type} eq 'MULTIHACK' ) {
                $portalmultihack=$portalmultihack+$mod->{stats}{BURNOUT_INSULATION};
            }
        }
    }
    return $portalmultihack;
}
sub heatsink {
    my($self,$portalhash) = @_;
    my $portalheatsink=0;
    for(my $i = 0; $i < 4; $i++) {
        my $mod=$portalhash->{portalV2}{linkedModArray}[$i];
        if ( defined $mod ) {
            if ( $mod->{type} eq 'HEATSINK' ) {
                $portalheatsink=$portalheatsink+$mod->{stats}{HACK_SPEED};
            }
        }
    }
    return $portalheatsink;
}

sub attackfreq {
    my($self,$portalhash) = @_;
    my $portalattackfreq=0;
    for(my $i = 0; $i < 4; $i++) {
        my $mod=$portalhash->{portalV2}{linkedModArray}[$i];
        if ( defined $mod ) {
            if ( $mod->{type} eq 'TURRET' ) {
                $portalattackfreq=$portalattackfreq+$mod->{stats}{ATTACK_FREQUENCY};
            }
        }
    }
    return $portalattackfreq;
}
sub hitbonus {
    my($self,$portalhash) = @_;
    my $portalhitbonus=0;
    for(my $i = 0; $i < 4; $i++) {
        my $mod=$portalhash->{portalV2}{linkedModArray}[$i];
        if ( defined $mod ) {
            if ( $mod->{type} eq 'TURRET' ) {
                $portalhitbonus=$portalhitbonus+$mod->{stats}{HIT_BONUS};
            }
        }
    }
    return $portalhitbonus;
}


sub lat {
    my($self,$portalhash) = @_;
    return $portalhash->{locationE6}{latE6}/1000000;
}
sub lon {
    my($self,$portalhash) = @_;
    return $portalhash->{locationE6}{lngE6}/1000000;
}
sub distance {
    my($self,$portalhash1,$portalhash2) = @_;
    my $geo=new Geo::Distance;
    my $lat1=$portalhash1->{locationE6}{latE6}/1000000;
    my $lon1=$portalhash1->{locationE6}{lngE6}/1000000;
    my $lat2=$portalhash2->{locationE6}{latE6}/1000000;
    my $lon2=$portalhash2->{locationE6}{lngE6}/1000000;
    my $resultdistance=int $geo->distance( 'meter', $lon1,$lat1 => $lon2,$lat2 );
    return($resultdistance);
}

sub modcount {
    my($self,$portalhash) = @_;
    my @shields=@{$portalhash->{portalV2}{linkedModArray}};
    my $shieldcount=0;
    foreach my $shield (@shields) {
      if (  defined $shield ) {
        $shieldcount++;
      }
    }
    return $shieldcount;

}

sub square {
    my ($self,$fieldhash) = @_;
    my $lat1=$fieldhash->{points}[0]{latE6}/1000000;
    my $lon1=$fieldhash->{points}[0]{lngE6}/1000000;
    my $lat2=$fieldhash->{points}[1]{latE6}/1000000;
    my $lon2=$fieldhash->{points}[1]{lngE6}/1000000;
    my $lat3=$fieldhash->{points}[2]{latE6}/1000000;
    my $lon3=$fieldhash->{points}[2]{lngE6}/1000000;
    my $geo=new Geo::Distance;
    my $a=$geo->distance( 'meter', $lon1,$lat1 => $lon2,$lat2 );
    my $b=$geo->distance( 'meter', $lon2,$lat2 => $lon3,$lat3 );
    my $c=$geo->distance( 'meter', $lon1,$lat1 => $lon3,$lat3 );
    my $p=($a+$b+$c)/2;
    my $sqr=sqrt($p*($p-$a)*($p-$b)*($p-$c));
    return $sqr;
}
sub htmlheader {
  my ($self,$lat,$lon,$zoom) = @_;
  my $htmlblob="
  <!DOCTYPE html>
   <html>
    <head>
     <meta name=\"viewport\" content=\"initial-scale=1.0, user-scalable=no\">
      <meta charset=\"utf-8\">
       <title>Megafield</title>
        <link href=\"default.css\" rel=\"stylesheet\">
         <script src=\"https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false\"></script>
          <script>

           function initialize() {
              var myLatLng = new google.maps.LatLng($lat, $lon);
               var mapOptions = {
                  zoom: $zoom,
                   center: myLatLng,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                     };

                      var map = new google.maps.Map(document.getElementById('map_canvas'),
                         mapOptions);
  ";
  return $htmlblob;


}
sub fieldhtml {
    my ($self,$fieldhash,$fieldguid) = @_;
    $fieldguid =~tr/./d/;
    my $color="#FF0000";
    my $team=$fieldhash->{team};
    my $lat1=$fieldhash->{points}[0]{latE6}/1000000;
    my $lon1=$fieldhash->{points}[0]{lngE6}/1000000;
    my $lat2=$fieldhash->{points}[1]{latE6}/1000000;
    my $lon2=$fieldhash->{points}[1]{lngE6}/1000000;
    my $lat3=$fieldhash->{points}[2]{latE6}/1000000;
    my $lon3=$fieldhash->{points}[2]{lngE6}/1000000;    
    if ($team eq "RESISTANCE" ) { $color="0000FF" };
    if ($team eq "ENLIGHTENED" ) { $color="00FF00" };
    my $htmlblob="var Coords$fieldguid = [
            new google.maps.LatLng($lat1, $lon1),
            new google.maps.LatLng($lat2, $lon2), 
            new google.maps.LatLng($lat3, $lon3), 
            new google.maps.LatLng($lat1, $lon1), 
];

 // Construct the polygon
 c$fieldguid = new google.maps.Polygon({
 paths: Coords$fieldguid,
 strokeColor: '$color',
 strokeOpacity: 0.8,
 strokeWeight: 2,
 fillColor: '$color',
 fillOpacity: 0.35
 });
 c$fieldguid.setMap(map);
 ";
    return $htmlblob;

}
unless( $ENV{GEO_DISTANCE_PP} ) {
    eval "use Ingress::PortalIntel::XS";
}

1;
__END__

