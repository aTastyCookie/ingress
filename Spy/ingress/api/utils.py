from math import pi, sin, cos, tan, asin, radians, sqrt, log, pow, atan, sinh

tilecounts = [1, 1, 1, 40, 40, 80, 80, 320, 1000, 2000, 2000, 4000, 8000, 16000, 16000, 32000]


def calc_tile(lng, lat, zoomlevel):
    rlat = radians(lat)
    tilecount = tilecounts[zoomlevel - 1]
    xtile = int((lng + 180.0) / 360.0 * tilecount)
    ytile = int((1.0 - log(tan(rlat) + (1 / cos(rlat))) / pi) / 2.0 * tilecount)
    lo, la = get_tile_center_lng_lat(xtile, ytile, zoomlevel)
    return xtile, ytile


def get_tile_center_lng_lat(xtile, ytile, zoomlevel):
    n = tilecounts[zoomlevel - 1]
    lon_deg = xtile / n * 360.0 - 180.0
    lat_rad = atan(sinh(pi * (1 - 2 * ytile / n)))
    lat_deg = 180.0 * (lat_rad / pi)
    return lon_deg, lat_deg


def calc_dist(lat1, lng1, lat2, lng2):
    lat1, lng1, lat2, lng2 = map(radians, [lat1, lng1, lat2, lng2])
    dlat = lat1 - lat2
    dlng = lng1 - lng2
    a = sin(dlat / 2) ** 2 + cos(lat1) * cos(lat2) * sin(dlng / 2) ** 2
    c = 2 * asin(sqrt(a))
    m = 6367.0 * c * 1000
    return m


def point_in_poly(x, y, poly):
    n = len(poly)
    inside = False
    p1x, p1y = poly[0]
    for i in range(n + 1):
        p2x, p2y = poly[i % n]
        if y > min(p1y, p2y):
            if y <= max(p1y, p2y):
                if x <= max(p1x, p2x):
                    if p1y != p2y:
                        xints = (y - p1y) * (p2x - p1x) / (p2y - p1y) + p1x
                    if p1x == p2x or x <= xints:
                        inside = not inside
        p1x, p1y = p2x, p2y
    return inside


def transform(wgLat, wgLon):
    """
    transform(latitude,longitude) , WGS84
    return (latitude,longitude) , GCJ02
    """
    a = 6378245.0
    ee = 0.00669342162296594323
    dLat = transformLat(wgLon - 105.0, wgLat - 35.0)
    dLon = transformLon(wgLon - 105.0, wgLat - 35.0)
    radLat = wgLat / 180.0 * pi
    magic = sin(radLat)
    magic = 1 - ee * magic * magic
    sqrtMagic = sqrt(magic)
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi)
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi)
    mgLat = wgLat + dLat
    mgLon = wgLon + dLon
    return mgLat, mgLon


def transformLat(x, y):
    ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x))
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0
    ret += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0
    ret += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0
    return ret


def transformLon(x, y):
    ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x))
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0
    ret += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0
    ret += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0
    return ret


import math

MERCATOR_RANGE = 256


def bound(value, opt_min, opt_max):
    if (opt_min != None):
        value = max(value, opt_min)
    if (opt_max != None):
        value = min(value, opt_max)
    return value


def degreesToRadians(deg):
    return deg * (math.pi / 180)


def radiansToDegrees(rad):
    return rad / (math.pi / 180)


class G_Point:
    def __init__(self, x=0, y=0):
        self.x = x
        self.y = y


class G_LatLng:
    def __init__(self, lt, ln):
        self.lat = lt
        self.lng = ln


class MercatorProjection:
    def __init__(self):
        self.pixelOrigin_ = G_Point(MERCATOR_RANGE / 2, MERCATOR_RANGE / 2)
        self.pixelsPerLonDegree_ = MERCATOR_RANGE / 360
        self.pixelsPerLonRadian_ = MERCATOR_RANGE / (2 * math.pi)

    def fromLatLngToPoint(self, lat, lng, opt_point=None):
        point = opt_point if opt_point is not None else G_Point(0, 0)
        origin = self.pixelOrigin_
        point.x = origin.x + lng * self.pixelsPerLonDegree_
        # NOTE(appleton): Truncating to 0.9999 effectively limits latitude to
        # 89.189.  This is about a third of a tile past the edge of the world tile.
        siny = bound(math.sin(degreesToRadians(lat)), -0.9999, 0.9999)
        point.y = origin.y + 0.5 * math.log((1 + siny) / (1 - siny)) * - self.pixelsPerLonRadian_
        return point

    def fromPointToLatLng(self, point):
        origin = self.pixelOrigin_
        lng = (point.x - origin.x) / self.pixelsPerLonDegree_
        latRadians = (point.y - origin.y) / -self.pixelsPerLonRadian_
        lat = radiansToDegrees(2 * math.atan(math.exp(latRadians)) - math.pi / 2)
        return G_LatLng(lat, lng)


def getField(centerLng, centerLat, zoom):
    mapWidth = 1024
    mapHeight = 768
    scale = tilecounts[zoom - 1]
    proj = MercatorProjection()
    centerPx = proj.fromLatLngToPoint(centerLng, centerLat)
    SWPoint = G_Point(centerPx.x - (mapWidth / 2) / scale, centerPx.y + (mapHeight / 2) / scale)
    SWLatLon = proj.fromPointToLatLng(SWPoint)
    NEPoint = G_Point(centerPx.x + (mapWidth / 2) / scale, centerPx.y - (mapHeight / 2) / scale)
    NELatLon = proj.fromPointToLatLng(NEPoint)
    return {
        'maxLngE6': int(NELatLon.lng * 1E6),
        'maxLatE6': int(NELatLon.lat * 1E6),
        'minLngE6': int(SWLatLon.lng * 1E6),
        'minLatE6': int(SWLatLon.lat * 1E6)
    }
