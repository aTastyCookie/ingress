import os
import sys
import urllib
import urllib2
import cookielib

authdata = lines = [line.strip() for line in open('config.ini')]

users_email_address=authdata[0]
users_password=authdata[1]

target_authenticated_google_app_engine_uri = 'https://m-dot-betaspike.appspot.com'
my_app_name = "com.nianticproject.ingress"



# we use a cookie to authenticate with Google App Engine
#  by registering a cookie handler here, this will automatically store the 
#  cookie returned when we use urllib2 to open http://currentcost.appspot.com/_ah/login
cookiejar = cookielib.LWPCookieJar()

#proxy = urllib2.ProxyHandler({'http': '195.222.16.185:1488'})

if (len(sys.argv)<2):
        opener = urllib2.build_opener()
else:
        proxy  = urllib2.ProxyHandler({'https': sys.argv[1]})
        opener = urllib2.build_opener(proxy)

urllib2.install_opener(opener)

#
# get an AuthToken from Google accounts
#
auth_uri = 'https://www.google.com/accounts/ClientLogin'
authreq_data = urllib.urlencode({ "Email":   users_email_address,
                                  "Passwd":  users_password,
                                  "service": "ah",
                                  "source":  my_app_name,
                                  "accountType": "HOSTED_OR_GOOGLE" })
auth_req = urllib2.Request(auth_uri, data=authreq_data)
auth_resp = urllib2.urlopen(auth_req)
auth_resp_body = auth_resp.read()
# auth response includes several fields - we're interested in 
#  the bit after Auth= 
auth_resp_dict = dict(x.split("=")
                      for x in auth_resp_body.split("\n") if x)
authtoken = auth_resp_dict["Auth"]
f = open("authtoken.txt",'w')
f.write(authtoken)
f.close
