package Ingress::Link;
{
  $Ingress::Link::VERSION = '0.20';
}
use strict;
use warnings;
use Geo::Distance;
=head1 NAME

Ingress::Link - Calculate Distances and Closest Locations

=head1 SYNOPSIS

  use Ingress::Link;
  my $geo = new Ingress::Link;
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
near future Ingress::Link will become a lightweight wrapper around GIS::Distance so that
legacy code benefits from fixes to GIS::Distance through the old Ingress::Link API.  For
any new developement I suggest that you look in to GIS::Distance.

=head1 STABILITY

The interface to Ingress::Link is fairly stable nowadays.  If this changes it 
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
are defined in a Ingress::Link object.  You can add units with reg_unit() or create some default 
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

  my $geo = new Ingress::Link;
  my $geo = new Ingress::Link( no_units=>1 );

Returns a blessed Ingress::Link object.  The new constructor accepts one optional 
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
    if(!$args{no_units}){
    }
    
    # Number of units in a single degree (lat or lon) at the equator.
    # Derived from: $geo->distance( 'kilometer', 10,0, 11,0 ) / $geo->{units}->{kilometer}
    $self->{deg_ratio} = 0.0174532925199433;

    return $self;
}

=head2 distance

  my $distance = $geo->distance( 'unit_type', $lon1,$lat1 => $lon2,$lat2 );

Calculates the distance between two lon/lat points.

=cut

sub length {
    my($self,$linkhash) = @_;
    my $geo=new Geo::Distance;
    my $linksrclatitude=$linkhash->{edge}{originPortalLocation}{latE6}/1000000;
    my $linksrclongitude=$linkhash->{edge}{originPortalLocation}{lngE6}/1000000;
    my $linkdstlatitude=$linkhash->{edge}{destinationPortalLocation}{latE6}/1000000;
    my $linkdstlongitude=$linkhash->{edge}{destinationPortalLocation}{lngE6}/1000000;
    my $resultdistance=int $geo->distance( 'meter', $linksrclongitude,$linksrclatitude => $linkdstlongitude,$linkdstlatitude );
    return($resultdistance);
}

sub srclat {
    my($self,$linkhash) = @_;
    return $linkhash->{edge}{originPortalLocation}{latE6}/1000000;
}
sub srclon {
    my($self,$linkhash) = @_;
    return $linkhash->{edge}{originPortalLocation}{lngE6}/1000000;
}

sub dstlat {
    my($self,$linkhash) = @_;
    return $linkhash->{edge}{destinationPortalLocation}{latE6}/1000000;
}
sub dstlon {
    my($self,$linkhash) = @_;
    return $linkhash->{edge}{destinationPortalLocation}{lngE6}/1000000;
}
sub team {
    my($self,$linkhash) = @_;
    return$linkhash->{controllingTeam}{team};
}

sub ctime {
    my($self,$linkhash) = @_;
    return $linkhash->{creator}{creationTime};
}
sub cguid {
    my($self,$linkhash) = @_;
    return $linkhash->{creator}{creatorGuid};
}
sub srcguid {
    my($self,$linkhash) = @_;
    return $linkhash->{edge}{originPortalGuid};
}
sub dstguid {
    my($self,$linkhash) = @_;
    return $linkhash->{edge}{destinationPortalGuid};
}

1;
__END__

=head1 FORMULAS

Currently Ingress::Link only has spherical and flat type formulas.  
If you have any information concerning ellipsoid and geoid formulas, 
the author would much appreciate some links to this information.

=head2 tv: Thaddeus Vincenty Formula

This is a highly accurate ellipsoid formula.  For most applications 
hsin will be faster and accurate enough.  I've read that this formula can 
be accurate to within a few millimeters.

This formula is still considered alpha quality.  It has not been tested 
enough to be used in production.

=head2 hsin: Haversine Formula

  dlon = lon2 - lon1
  dlat = lat2 - lat1
  a = (sin(dlat/2))^2 + cos(lat1) * cos(lat2) * (sin(dlon/2))^2
  c = 2 * atan2( sqrt(a), sqrt(1-a) )
  d = R * c 

The hsin formula is the new standard formula for Ingress::Link because 
of it's improved accuracy over the cos formula.

=head2 polar: Polar Coordinate Flat-Earth Formula

  a = pi/2 - lat1
  b = pi/2 - lat2
  c = sqrt( a^2 + b^2 - 2 * a * b * cos(lon2 - lon1) )
  d = R * c 

While implimented, this formula has not been tested much.  If you use it 
PLEASE share your results with the author!

=head2 cos: Law of Cosines for Spherical Trigonometry

  a = sin(lat1) * sin(lat2)
  b = cos(lat1) * cos(lat2) * cos(lon2 - lon1)
  c = arccos(a + b)
  d = R * c

Although this formula is mathematically exact, it is unreliable for 
small distances because the inverse cosine is ill-conditioned.

=head2 gcd: Great Circle Distance.

  c = 2 * asin( sqrt(
    ( sin(( lat1 - lat2 )/2) )^2 + 
    cos( lat1 ) * cos( lat2 ) * 
    ( sin(( lon1 - lon2 )/2) )^2
  ) )

Similar notes to the mt and cos formula, not too terribly accurate.

=head2 mt: Math::Trig great_circle_distance

This formula uses Meth::Trig's great_circle_distance function which at this time uses math almost 
exactly the same as the cos formula.  If you want to use the cos formula you may find 
that mt will calculate faster (untested assumption).  For some reason mt and cos return 
slight differences at very close distances. The mt formula has the same drawbacks as the cos formula.

This is the same formula that was previously the only one used by 
Ingress::Link (ending at version 0.06) and was wrongly called the "gcd" formula.

Math::Trig states that the formula that it uses is:

  lat0 = 90 degrees - phi0
  lat1 = 90 degrees - phi1
  d = R * arccos(cos(lat0) * cos(lat1) * cos(lon1 - lon01) + sin(lat0) * sin(lat1))

=head1 NOTES

If L<Ingress::Link::XS> is installed, this module will use it. You can
stick with the pure Perl version by setting the GEO_DISTANCE_PP environment
variable before using this module.

=head1 TODO

=over 4

=item *

A second pass should be done in closest before distance calculations are made that does an inner 
radius simplistic calculation to find the locations that are obviously within the distance needed.

=item *

Tests!  We need more tests!

=item *

For NASA-quality accuracy a geoid forumula.

=item *

The closest() method needs to be more flexible and (among other things) allow table joins.

=back

=head1 SEE ALSO

L<Math::Trig> - Inverse and hyperbolic trigonemetric Functions.

L<http://www.census.gov/cgi-bin/geo/gisfaq?Q5.1> - A overview of calculating distances.

L<http://williams.best.vwh.net/avform.htm> - Aviation Formulary.

=head1 AUTHOR

Aran Clary Deltac <bluefeet@cpan.org>

=head1 CONTRIBUTORS

gray, <gray at cpan.org>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

