from datetime import datetime, timedelta


class Message(object):
    @staticmethod
    def parse(dict):
        seconds, millis = divmod(dict[1], 1000)
        time = datetime.fromtimestamp(seconds) + timedelta(milliseconds=millis)
        return {
            'guid': dict[0],
            'time': time.strftime('%Y/%m/%d %H:%M:%S:%f')[:-3],
            'text': dict[2]['plext']['text'],
            'type': dict[2]['plext']['plextType'],
            'team': dict[2]['plext']['team']
        }
