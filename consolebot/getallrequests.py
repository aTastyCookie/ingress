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
 
fr = flow.FlowReader(open("dump.0"))
reqpattern = r'^m-dot-betaspike.appspot.com'
for i in fr.stream():
#    print i.request.host
#    if re.match(reqpattern, i.request.host):
	print i.request.host		
	print i.request.path
	print decode_gzip(i.request.content);
	print decode_gzip(i.response.content);
