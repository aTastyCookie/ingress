from spy.BaseWorker import BaseWorker
from time import sleep, time
from random import randint
import math


class Worker(BaseWorker):
    def run(self):
        portals = []
        portalsDetail = {}

        def findPortals(entities):
            for entity in entities:
                if isinstance(entity, list):
                    findPortals(entity)
                elif isinstance(entity, str):
                    if entity.endswith('.16') and entity not in portals:
                        portals.append(entity)

        def lat_to_tile(lat):
            lat = lat / 1E6
            return math.floor(
                (1 - math.log(math.tan(lat * math.pi / 180) +
                              1 / math.cos(lat * math.pi / 180)) / math.pi
                 ) / 2 * 32000
            )

        def get_tile(lat, lng):
            s = '16_{}_{}_0_8_100'
            k_lat = lat_to_tile(lat)
            k_lng = math.floor((lng / 1E6 + 180) / 360 * 32000)
            return {
                'centerLng': lng,
                'centerLat': lat,
                'tile': s.format(k_lng, k_lat)
            }

        self.lockAccount()

        chunkSize = 3
        chunks = [self.tiles[x:x + chunkSize] for x in range(0, len(self.tiles), chunkSize)]
        while True:
            self.logger.info('[%s] Fetch entities' % self.name)
            api = self.buildApi(self.tiles[0])
            for chunk in chunks:
                fetched = api.fetch_map([x['tile'] for x in chunk])
                for tile, entities in fetched['map'].items():
                    findPortals(entities['gameEntities'])
            self.logger.info('[%s] Fetch portals' % self.name)

            tiles = []
            tilePortals = {}

            for portal in portals:
                guid = portal.replace('.', '_')
                portalsDetail[guid] = api.fetch_portal(portal)
                tile = get_tile(portalsDetail[guid][2], portalsDetail[guid][3])
                if tile not in tiles:
                    tiles.append(tile)
                if tile['tile'] not in tilePortals.keys():
                    tilePortals[tile['tile']] = {guid : portalsDetail[guid]}
                else:
                    tilePortals[tile['tile']][guid] = portalsDetail[guid]
                sleep(0.1)

            for tile in tiles:
                data = self.handleTile(tile)
                data['portals'] = tilePortals[tile['tile']]
                self.emit(data)
                sleep(0.1)
            sleeptime = randint(300, 600)
            self.logger.info('[%s] Sleep %s' % (self.name, sleeptime))
            sleep(sleeptime)

    def handleTile(self, tile):
        api = self.buildApi(tile)
        entities = api.fetch_map([tile['tile']])
        self.logger.info('[%s] Fetch score' % self.name)
        score = api.fetch_score()
        self.logger.info('[%s] Fetch region' % self.name)
        region = api.fetch_region()
        self.logger.info('[%s] Fetch comm' % self.name)
        ts = int(time()) - 30000
        comm = {
            'faction': api.fetch_msg(tab='faction', mints=ts, maxts=int(time())),
            'alerts': api.fetch_msg(tab='alerts', mints=ts, maxts=int(time())),
            'all': api.fetch_msg(tab='all', mints=ts, maxts=int(time())),
        }
        return {
            'tile': tile,
            'entities': entities['map'][tile['tile']]['gameEntities'],
            'region': region,
            'score': score,
            'comm': comm,
        }
