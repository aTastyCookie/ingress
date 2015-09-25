import threading
import re
import http.cookiejar
from bs4 import BeautifulSoup
import urllib
from pymongo import MongoClient
from ingress.exceptions.Ingress import IngressException
from ingress.exceptions.AccountBanned import AccountBannedException
from ingress.api.intel import Intel
from ingress.api.utils import getField


class BaseWorker(threading.Thread):
    def __init__(self, config, tiles, account, notifier,
                 group=None, target=None, name=None, args=(), kwargs=None, *, daemon=None):
        self.config = config
        self.tiles = tiles
        self.notifier = notifier
        self.account = account
        client = MongoClient(
            host=config['db']['host'],
            port=int(config['db']['port'])
        )
        self.db = client.__getattr__(config['db']['db'])

        self.headers = [
            (
                'User-Agent',
                'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) ' +
                'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36'
            )
        ]
        self.ingress_url = 'http://www.ingress.com/intel'
        self.login_page_url = 'https://accounts.google.com/ServiceLogin?service=grandcentral'
        self.auth_url = 'https://accounts.google.com/ServiceLoginAuth'
        self.cookies = http.cookiejar.CookieJar()
        self.opener = self.buildOpener(self.cookies)
        self.accountCookies = None

        super().__init__(group, target, name, args, kwargs, daemon=daemon)

    def buildOpener(self, cookieJar):
        opener = urllib.request.build_opener()
        opener.addheaders = self.headers
        opener.add_handler(urllib.request.HTTPRedirectHandler())
        opener.add_handler(urllib.request.HTTPSHandler())
        opener.add_handler(urllib.request.HTTPCookieProcessor(cookieJar))
        return opener

    def getUrlContent(self, url):
        return str(self.opener.open(url).read())

    def getLoginCookies(self, email, password):
        print('Login %s ...' % email)
        login_url = re.findall('<a href="(.*?)" class="button_link"', self.getUrlContent(self.ingress_url), re.I)[0]
        ltmpl_shdf = re.findall('ltmpl=(.*?)&shdf=(.*)', login_url, re.I)

        parser = BeautifulSoup(self.getUrlContent(login_url), 'html.parser')
        galx_value = parser.find('input', {'name': 'GALX'})['value']
        params = urllib.parse.urlencode({
            'Email': email,
            'Passwd': password,
            'continue': 'https://appengine.google.com/_ah/conflogin?continue=https://www.ingress.com/intel',
            'GALX': galx_value,
            'signIn': 'Sign in',
            'service': 'ah',
            'shdf': ltmpl_shdf[0][1],
            'ltmpl': ltmpl_shdf[0][0]

        })
        self.opener.open(self.auth_url, params.encode('ascii')).read()
        cookies = ""
        banned = True
        for cookie in self.cookies:
            if cookie.domain == 'www.ingress.com':
                if cookie.name == 'csrftoken':
                    banned = False
                cookies += '%s=%s; ' % (cookie.name, cookie.value)
        if banned:
            raise AccountBannedException(email)
        return cookies

    def getAccountCookies(self):
        if self.accountCookies is None:
            self.accountCookies = self.getLoginCookies(
                self.account['email'], self.account['password']) + \
                                  "ingress.intelmap.shflt=viz; ingress.intelmap.lat=%s; ingress.intelmap.lng=%s; ingress.intelmap.zoom=%s" % (
                                      self.config['tilier']['base_lat'], self.config['tilier']['base_lng'], 16
                                  )
        return self.accountCookies

    def lockAccount(self):
        self.db.accounts.update_one(self.account, {'$set': {'status': 'BUSY'}})

    def unlockAccount(self):
        if self.account['status'] == 'BUSY':
            self.db.accounts.update_one(self.account, {'$set': {'status': 'OK'}})

    def buildApi(self):
        return Intel(self.getAccountCookies(),
                     getField(self.config['tilier']['base_lng'], self.config['tilier']['base_lat'], 16))

    def start(self):
        try:
            self.do()
        except IngressException as e:
            self.notifier.handleException(e)

    def do(self):
        pass
