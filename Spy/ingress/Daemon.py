from pymongo import MongoClient
from ingress.Notifier import MailNotifier
from ingress.Tilier import Tilier
from ingress.Worker import Worker


class Daemon:
    def __init__(self, config):
        self.config = config
        self.notifier = self.loadNotifier(config['notifier'])
        self.db = self.loadDb(config['db'])
        self.workers = []

    @staticmethod
    def loadNotifier(config):
        return MailNotifier(
            config['alert_email'],
            config['sandbox'],
            config['apikey']
        )

    @staticmethod
    def loadDb(config):
        client = MongoClient(
            host=config['host'],
            port=int(config['port'])
        )
        return client.__getattr__(config['db'])

    def start(self):
        tiles = Tilier(self.config['tilier']).getTiles()
        accounts = self.db.accounts.find({'status': 'OK'})
        if accounts.count() < 1:
            raise Exception('0 accounts available')
        chunkSize = min(int(len(tiles) / accounts.count()), self.config['daemon']['max_tiles_per_worker'])
        chunks = [tiles[x:x + chunkSize] for x in range(0, len(tiles), chunkSize)]
        for chunk in chunks:
            try:
                worker = Worker(self.config, chunk, accounts.next(), self.notifier)
                self.workers.append(worker)
                worker.start()
            except StopIteration:
                self.notifier.send(
                    'Not enough accounts',
                    'Not enough accounts to work in full power. %s need.' % (len(chunks) - len(self.workers))
                )
