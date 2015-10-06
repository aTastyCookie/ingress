from spy.api.utils import calc_tile, getField, get_tile_center_lng_lat


class Tilier:
    def __init__(self, config):
        self.config = config

    def getTiles(self):
        field = getField(self.config['base_lat'], self.config['base_lng'], 10)
        minxtile, maxytile = calc_tile(field['minLngE6'] / 1E6, field['minLatE6'] / 1E6, 14)
        maxxtile, minytile = calc_tile(field['maxLngE6'] / 1E6, field['maxLatE6'] / 1E6, 14)
        tiles = []
        for xtile in range(minxtile, maxxtile + 1):
            for ytile in range(minytile, maxytile + 1):
                lat, lng = get_tile_center_lng_lat(xtile, ytile, 14)
                tiles.append({
                    'tile': '14_{}_{}_2_8_100'.format(xtile, ytile),
                    'centerLat': lat,
                    'centerLng': lng,
                    'bounds': getField(lat, lng, 14)
                })
        return tiles
