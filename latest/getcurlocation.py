import re
import gzip
import cStringIO
import json
from libmproxy import encoding
from libmproxy import flow
def decode_gzip(content):
    gfile = gzip.GzipFile(fileobj=cStringIO.StringIO(content))
    try:
        return gfile.read()
    except IOError:
        return None
 
fr = flow.FlowReader(open("sukaslayer.dump.0"))
reqpattern = r'^m-dot-betaspike.appspot.com'
pathpattern = r'^/rpc/gameplay/dropItem'
for i in fr.stream():
#    print i.request.host
    if re.match(reqpattern, i.request.host):
	if re.match(pathpattern, i.request.path):
	    jsonreqarray = json.loads(decode_gzip(i.request.content))
	    date = i.response.headers["Date"][0]
	    location = jsonreqarray["params"]["playerLocation"]
	    locations = location.split(',')
	    lat = int(locations[0], 16)/float(1000000)
	    lon = int(locations[1], 16)/float(1000000)
	    latlon="%s,%s" %(lat, lon)
	    print latlon
	    print date
	    f = open("curloc.txt",'w')
	    f.write(latlon)
	    f.close
	    d = open("curdate.txt",'w')
	    d.write(date)
	    d.close
