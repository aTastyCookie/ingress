from ingress.BaseWorker import BaseWorker
from time import sleep

class Worker(BaseWorker):
    def do(self):
        self.lockAccount()
        tilesPerRequest = 15
        chunks = [self.tiles[x:x + tilesPerRequest] for x in range(0, len(self.tiles), tilesPerRequest)]
        api = self.buildApi()
        for chunk in chunks:
            entities = api.fetch_map([x['tile'] for x in chunk])
            sleep(3)

