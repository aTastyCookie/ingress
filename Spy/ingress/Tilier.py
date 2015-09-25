from ingress.api.utils import calc_tile, getField, get_tile_center_lng_lat


class Tilier:
    def __init__(self, config):
        self.config = config

    def getTiles(self):
        field = getField(self.config['base_lat'], self.config['base_lng'], 10)
        minxtile, maxytile = calc_tile(field['minLngE6'] / 1E6, field['minLatE6'] / 1E6, 16)
        maxxtile, minytile = calc_tile(field['maxLngE6'] / 1E6, field['maxLatE6'] / 1E6, 16)
        tiles = []
        for xtile in range(minxtile, maxxtile + 1):
            for ytile in range(minytile, maxytile + 1):
                lat, lon = get_tile_center_lng_lat(xtile, ytile, 16)
                tiles.append({
                    'tile': '16_{}_{}_0_8_100'.format(xtile, ytile),
                    'lat': lat,
                    'lon': lon
                })
        return tiles
