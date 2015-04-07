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
 
fr = flow.FlowReader(open("iamtheone.dump.0"))
reqpattern = r'^m-dot-betaspike.appspot.com'
pathpattern = r'^/rpc/gameplay/rechargeResonatorsV2'
for i in fr.stream():
#    print i.request.host
    if re.match(reqpattern, i.request.host):
	if re.match(pathpattern, i.request.path):
#	    print "----------------------"
#	    print i.request.path
	    jsonarray = json.loads(decode_gzip(i.request.content))
#	    location = jsonarray["params"]["playerLocation"]
	    f = open("requests/rechargeResonatorsV2",'w')
	    f.write(decode_gzip(i.request.content))
#            print decode_gzip(i.response.content)
#	    print "----------------------"
