#-*- coding: utf-8 -*-
import sys
import json
import urllib
import urllib2
import random
import string
import base64

from antigate import AntiGate

def http_request(method='POST', header=None, host='android.clients.google.com', path='', security=True, data=''):
    if header is None:
        header = {
            'Content-Type': 'text/plain; charset=UTF-8',
            'Connection': 'Keep-Alive',
            'User-Agent': 'GoogleLoginService/1.2 (nia LUKASHENKO)',
        }

    if security:
        url = "https://%s%s" % (host, path, )
    else:
        url = "http://%s%s" % (host, path, )

    request = urllib2.Request(url, data, header)
    request.get_method = lambda: method
    proxy  = urllib2.ProxyHandler({'https': sys.argv[1]})
    opener = urllib2.build_opener(proxy)
    urllib2.install_opener(opener)
    response = urllib2.urlopen(request)
    data = response.read()

    print data
    return data


def _simple_request(path, user):
    status = False

    data = http_request(path=path, data=json.dumps(user))

    data = json.loads(data)

    if data.has_key('status'):
        status = data['status'] == 'SUCCESS'

    return status, data


def rate_password(user):
    status, data = _simple_request('/setup/ratepw', user)
    return status


def create_user(user):
    data = http_request(path='/setup/create', data=json.dumps(user))
    data = json.loads(data)

    return data


def check_avail(user):
    alt = None
    status = False

    data = http_request(path='/setup/checkavail', data=json.dumps(user))

    data = json.loads(data)

    if data.has_key('status'):
        status = data['status'] == 'SUCCESS'

    if data.has_key('suggestions'):
        alt = data['suggestions']

    return status, alt


if __name__ == '__main__':
    char_set = string.ascii_lowercase
    gname=''.join(random.sample(char_set*5,5))
    gsurname=''.join(random.sample(char_set*5,5))
    gpassword=''.join(random.sample(char_set*10,10))
    glogin=gname+gsurname
    print glogin+','+glogin+'@gmail.com'+','+gpassword
    char_set = 'abcdef' + string.digits
    gaid = ''.join(random.sample(char_set*16,16))
    print gaid

##    sys.exit (1)
#    if len (sys.argv) != 5 :
#          print "Usage: python "+sys.argv[0]+" username password firstname lastname"
#          sys.exit (1)
#    user = {
#        'username': sys.argv[1]+'@gmail.com',
#        'version': '3',
#        'firstName': sys.argv[3],
#        'lastName': sys.argv[4],
#    }
    user = {
        'username': glogin+'@gmail.com',
        'version': '3',
        'firstName': gname,
        'lastName': gsurname,
    }

    status, alt = check_avail(user)
    while not status:
        print 'name is not available'
        if alt is not None:
            print 'choose alternative: %s' % alt
        line = sys.stdin.readline()
        user['username'] = line.strip()
        status, alt = check_avail(user)

#    user['password'] = sys.argv[2]
    user['password'] = gpassword    
    status = rate_password(user)
    if not status:
        exit(1)

#    user['androidId'] = '348d98c834cd45fb'
    user['androidId'] = gaid
    user['securityAnswer'] = '2013'
    user['securityQuestion'] = 'First phone number?'
    user['secondaryEmail'] = ''
    user['agreeWebHistory'] = '1'
    user['locale'] = 'en_US'
    user['operatorCountry'] = 'by'
    user['simCountry'] = ''

    data = create_user(user)
    while data['status'] == 'CAPTCHA':

        with open('./img.html', 'w+') as file_:
            print >> file_, '<img src="data:%s;base64,%s">' % (data['captchaMime'], data['captchaData'],)
        with open('./captcha.png', 'w+') as file_captcha:
            print >> file_captcha, base64.b64decode(data['captchaData'])
        gate = AntiGate('9498efae30b9c0385ed1df4cb06f6cb2', 'captcha.png')
#        print 'enter captcha code:'
#        line = sys.stdin.readline()
        user['captchaToken'] = data['captchaToken'].strip()
#        user['captchaAnswer'] = line.strip()
#        print gate
        user['captchaAnswer'] = str(gate)

        data = create_user(user)

    print data['SID']
    with open('pool.csv', 'a') as file_pool:
        file_pool.write(glogin+','+glogin+'@gmail.com'+','+gpassword+'\n')
    print glogin+','+glogin+'@gmail.com'+','+gpassword


        # print "check: %s, alternative: %s" % (status, alt, )

        # HTTPS   POST /setup/checkavail HTTP/1.1
        # {"username":"jane.dou2013@gmail.com","version":"3","firstName":"Jane","lastName":"Dou"}
        # > {"detail":"ADDRESS_NOT_AVAILABLE","status":"USERNAME_UNAVAILABLE","suggestions":["jane.dou201398@gmail.com","JaneDou33@gmail.com","JDou43@gmail.com","jane.dou2013.JD@gmail.com"]}

        # HTTPS   POST /setup/checkavail HTTP/1.1
        # {"username":"dou.jane2013@gmail.com","version":"3","firstName":"Jane","lastName":"Dou"}
        # > {"status":"SUCCESS"}

        # HTTPS   POST /setup/ratepw HTTP/1.1
        # {"username":"dou.jane2013@gmail.com","version":"3","password":"doujane2013","firstName":"Jane","lastName":"Dou"}
        # > {"detail":"fair","status":"SUCCESS","strength":3}

        # HTTPS  POST /setup/create HTTP/1.1 -- Р—РґРµСЃСЊ СЏРІРЅРѕ РІРѕР·СЂР°С‰Р°РµС‚СЃСЏ СЃР°РјР° РєР°РїС‡Р°
        # {"androidId":"348d98c834cd45f5","username":"dou.jane2013@gmail.com","securityAnswer":"2013","securityQuestion":"First phone number?","secondaryEmail":"","version":"3","password":"doujane2013","firstName":"Jane","lastName":"Dou","agreeWebHistory":"1","locale":"en_US","operatorCountry":"by","simCountry":""}
        # > {"status":"CAPTCHA","captchaData":"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\u003d","captchaMime":"image/jpeg","captchaToken":"ALXfmJqppsUZi0CRVp1lEEb6bs04_0CdoMhPi5RBNe-W0MvDD3Nwtt1D_YADYQOG-SF6zig0BiY3ASHc0BfBkCi1mLaxTUls7DZyvuy-kqzhigN9QWuvC7blB32Lop7-tCgQtpjFJpkKml6nVBwsHFtmlbfvSyz3Rg"}

        # HTTPS  POST /setup/create HTTP/1.1
        # {"androidId":"348d98c834cd45f5","username":"dou.jane2013@gmail.com","securityAnswer":"2013","securityQuestion":"First phone number?","secondaryEmail":"","version":"3","password":"doujane2013","firstName":"Jane","lastName":"Dou","captchaToken":"ALXfmJqppsUZi0CRVp1lEEb6bs04_0CdoMhPi5RBNe-W0MvDD3Nwtt1D_YADYQOG-SF6zig0BiY3ASHc0BfBkCi1mLaxTUls7DZyvuy-kqzhigN9QWuvC7blB32Lop7-tCgQtpjFJpkKml6nVBwsHFtmlbfvSyz3Rg","captchaAnswer":"etsubb","agreeWebHistory":"1","locale":"en_US","operatorCountry":"by","simCountry":""}
        # > {"SID":"DQAAAHIAAAAifQjbUVLDMOoNoyiuflPBycSIZyPwZIWp41Dt9ijQZ_KTHPdr3aQkJMP8ToO6TdVIcInxFpLmp9uHNcVzOuBIrTVNVpScAhSPbakugLvvIivg4bHGMZX0NVQi_ibJ6SHFZ-g0SX1ZqllxqBJXPvksuYpaj21BFhXmdlcMTbyseA","status":"SUCCESS"}
