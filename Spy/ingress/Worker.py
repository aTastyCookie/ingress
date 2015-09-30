from ingress.BaseWorker import BaseWorker
from time import sleep
from random import randint


class Worker(BaseWorker):
    def run(self):
        portals = []

        def findPortals(entities):
            for entity in entities:
                if isinstance(entity, list):
                    findPortals(entity)
                elif isinstance(entity, str):
                    if entity.endswith('.16') and entity not in portals:
                        portals.append(entity)

        self.lockAccount()
        while True:
            for tile in self.tiles:
                api = self.buildApi(tile)
                sleep(3)
                self.logger.info('[%s] Fetch score' % self.name)
                score = api.fetch_score()
                sleep(3)
                self.logger.info('[%s] Fetch region' % self.name)
                region = api.fetch_region()
                sleep(3)
                self.logger.info('[%s] Fetch comm' % self.name)
                comm = api.fetch_msg()
                sleep(3)
                self.logger.info('[%s] Fetch entities' % self.name)
                entities = api.fetch_map([tile['tile']])['map'][tile['tile']]['gameEntities']
                dump = {
                    'tile': tile,
                    'entities': entities,
                    'region': region,
                    'score': score,
                    'comm': comm,
                    'portals': {}
                }
                findPortals(entities)
                self.logger.info('[%s] Fetch portals (%s)' % (self.name, len(portals)))
                for portal in portals:
                    dump['portals'][portal.replace('.', '_')] = api.fetch_portal(portal)
                    sleep(0.5)
                self.logger.info('[%s] Emit data to HQ' % self.name)
                self.emit(dump)
            sleepTime = randint(300, 600)
            self.logger.info('[%s] sleep %s' % (self.name, sleepTime))
            sleep(sleepTime)
