media_list = [
    {
        'Index':1,
        'Name': 'CCTV',
        'URL': 'https://english.cctv.com/',
        'Must': ['https://english.cctv.com/'],
        'MustNot': None
    },
    {
        'Index':2,
        'Name': 'Global Times',
        'URL': 'http://globaltimes.cn/',
        'Must': ['https://www.globaltimes.cn/content/'],
        'MustNot': None
    },
    {
        'Index': 3 ,
        'Name': 'China Daily',
        'URL': 'http://www.chinadaily.com.cn/',
        'Must': ['http://www.chinadaily.com.cn/'],
        'MustNot': None
    },
    {
        'Index': 4 ,
        'Name': 'Xinhua',
        'URL': 'http://www.xinhuanet.com/english/',
        'Must': ['http://www.xinhuanet.com/english/'],
        'MustNot': None
    },
    {
        'Index': 5 ,
        'Name': "People's Daily",
        'URL': 'http://english.peopledaily.com.cn/',
        'Must': ['http://en.people.cn/'],
        'MustNot': None
    },
    {
        'Index': 6 ,
        'Name': "BBC",
        'URL': 'https://www.bbc.com/news/coronavirus/',
        'Must': ['https://www.bbc.com/news/'],
        'MustNot': ['sport','reel']
    },
    {
        'Index': 7 ,
        'Name': "Daily Mail",
        'URL': 'http://www.dailymail.co.uk/news/coronavirus',
        'Must': ['http://www.dailymail.co.uk/news/'],
        'MustNot': None
    },
    {
        'Index': 8 ,
        'Name': "The Guardian",
        'URL': 'https://www.theguardian.com/world/coronavirus-outbreak/',
        'Must': ['https://www.theguardian.com/world/'],
        'MustNot': None
    },
    {
        'Index': 9 ,
        'Name': "The Times",
        'URL': 'https://www.thetimes.co.uk/',
        'Must': ['https://www.thetimes.co.uk/edition/news/'],
        'MustNot': None
    },
    {
        'Index': 10 ,
        'Name': "The Huffington Post",
        'URL': 'https://www.huffpost.com/feature/coronavirus',
        'Must': ['https://www.huffpost.com/entry/'],
        'MustNot': None
    },
    {
        'Index': 11 ,
        'Name': "CNN",
        'URL': 'https://edition.cnn.com/specials/world/coronavirus-outbreak-intl-hnk',
        'Must': ['https://edition.cnn.com/'],
        'MustNot': ['/football/', '/tennis/','/entertainment/','/videos/', '/sport/', '/travel/', '/style/']
    },
    {
        'Index': 12,
        'Name': "The New York Times",
        'URL': 'http://www.nytimes.com/',
        'Must': ['http://www.nytimes.com/'],
        'MustNot': ['/sports/','/entertainment/', '/travel/', '/video/']
    },
    {
        'Index': 13,
        'Name': "Fox News",
        'URL': 'https://www.foxnews.com/category/health/infectious-disease/coronavirus',
        'Must': [ 'https://www.foxnews.com/',],
        'MustNot': ['/sports/','/entertainment/','/auto/']
    },

    {
        'Index': 14,
        'Name': 'Focus Taiwan',
         'URL': 'https://focustaiwan.tw/',
         'Must': ['https://focustaiwan.tw/'],
         'MustNot': ['/sports/','/video/']
    },

    {
        'Index': 15,
        'Name': 'The Globe And Mail',
         'URL': 'https://www.theglobeandmail.com/topics/coronavirus/',
         'Must': ['https://www.theglobeandmail.com/'],
         'MustNot': ['/sports/','/arts/','/drive/','/life/']
    },

    {
        'Index': 16,
        'Name':'The Japan Times',
        'URL':'https://www.japantimes.co.jp/',
        'Must':['https://www.japantimes.co.jp/news/', 'https://www.japantimes.co.jp/opinion/'],
        'MustNot':None
    },

    {
        'Index': 17,
        'Name':'Euronews',
        'URL':'https://www.euronews.com/',
        'Must':['https://www.euronews.com/'],
        'MustNot':['/sport/','/travel/','/video/']
    },
    {
        'Index': 18,
        'Name': 'Russia Today',
        'URL': 'https://www.rt.com/',
        'Must': ['https://www.rt.com/'],
        'MustNot': ['/sport/', '/shows/', ]
    },
    {
        'Index': 19,
        'Name': 'South China Morning Post',
         'URL': 'https://www.scmp.com/',
         'Must': ['https://www.scmp.com/'],
         'MustNot': None
     },
    {
        'Index': 20,
        'Name': 'The Hindu',
         'URL': 'https://www.thehindu.com/topic/coronavirus/',
         'Must': ['https://www.thehindu.com/'],
         'MustNot': ['/sport/','/entertainment/']
    },
    {
        'Index': 21,
        'Name': 'Folha',
         'URL': 'https://www1.folha.uol.com.br/internacional/en/',
         'Must': ['https://www1.folha.uol.com.br/internacional/en/'],
         'MustNot': ['/sports/','/culture/','/travel/']
    },
    {
        'Index': 22,
        'Name': 'Tehran Times',
        'URL': 'https://www.tehrantimes.com/',
        'Must': ['https://www.tehrantimes.com/news/'],
        'MustNot': None
    },
    {
        'Index': 23,
        'Name': 'ASNA',
        'URL': 'https://www.ansa.it/english/',
        'Must': ['https://www.ansa.it/english/news/'],
        'MustNot': ['/sports/','/lifestyle/','/vatican/']
    },
    {
        'Index': 24,
        'Name': 'Yonhap',
        'URL': 'https://en.yna.co.kr/index?site=header_site_en',
        'Must': ['https://en.yna.co.kr/'],
        'MustNot': ['section=sports', 'section=culture', 'section=video','section=image']
    },
    {
        'Index': 25,
        'Name': 'Hong Kong News',
        'URL': 'https://www.hongkongnews.net/',
        'Must': ['https://www.hongkongnews.net/news/'],
        'MustNot': None
    },
    {
        'Index': 26,
        'Name': 'The Standard',
        'URL': 'https://www.thestandard.com.hk/',
        'Must': ['https://www.thestandard.com.hk/section-news/'],
        'MustNot': None
    },
    {
        'Index': 27,
        'Name': 'Taiwan News',
        'URL': 'https://www.taiwannews.com.tw/en/',
        'Must': ['https://www.taiwannews.com.tw/en/news/'],
        'MustNot': None
    },
    {
        'Index': 28,
        'Name': 'The Moscow Times',
        'URL': 'https://www.themoscowtimes.com/',
        'Must': ['https://www.themoscowtimes.com/'],
        'MustNot': None
    },
    {
        'Index': 29,
        'Name': 'Anadolu Agency',
        'URL': 'https://www.aa.com.tr/en',
        'Must': ['https://www.aa.com.tr/en/'],
        'MustNot': ['/sports/', '/video-gallery/', '/photo-gallery/']
    },
    {
        'Index': 30,
        'Name': 'The Local Germany',
        'URL': 'https://www.thelocal.de/',
        'Must': ['https://www.thelocal.de/'],
        'MustNot': None
    },
    {
        'Index': 31,
        'Name': 'SBS News',
        'URL': 'https://www.sbs.com.au/news/topic/coronavirus-covid-19',
        'Must': ['https://www.sbs.com.au/news/'],
        'MustNot': None
    },
    {
        'Index': 32,
        'Name': 'The Times of Israel',
        'URL': 'https://www.timesofisrael.com/',
        'Must': ['https://www.timesofisrael.com/'],
        'MustNot': None
    },
    {
        'Index': 33,
        'Name': 'The Indian Express',
        'URL': 'https://indianexpress.com/',
        'Must': ['https://indianexpress.com/'],
        'MustNot': ['/videos/','/sports/','/entertainment/','/lifestyle/']
    },
    {
        'Index': 34,
        'Name': 'New Straits Times',
        'URL': 'https://www.nst.com.my/',
        'Must': ['https://www.nst.com.my/'],
        'MustNot': ['videos','/sports/','/entertainment/','/lifestyle/']
    },
    {
        'Index': 35,
        'Name': 'Swissinfo',
        'URL': 'https://www.swissinfo.ch/eng/',
        'Must': ['https://www.swissinfo.ch/eng/'],
        'MustNot': None
    },
    {
        'Index': 36,
        'Name': 'Reuters',
        'URL': 'https://www.reuters.com/',
        'Must': ['https://www.reuters.com/article/'],
        'MustNot': ['/picture/','/video/']
    },
    {
        'Index': 37,
        'Name': 'Express',
        'URL': 'https://www.express.co.uk/',
        'Must': ['https://www.express.co.uk/'],
        'MustNot': ['/sport/', '/showbiz/','/travel/', '/entertainment/', '/life-style/']
    },
    {
        'Index': 38,
        'Name': 'USA Today',
        'URL': 'http://www.usatoday.com/',
        'Must': ['http://www.usatoday.com/'],
        'MustNot': ['/sports/','/entertainment/','/videos/','/travel/', '/life/']
    },
    {
        'Index': 39,
        'Name': 'Nbc News',
        'URL': 'https://www.nbcnews.com/health/coronavirus',
        'Must': ['https://www.nbcnews.com/'],
        'MustNot': None
    },
    {
        'Index': 40,
        'Name': 'ABC News',
        'URL': 'https://abcnews.go.com/Health/Coronavirus',
        'Must': ['https://abcnews.go.com/'],
        'MustNot': None
    },
    {
        'Index': 41,
        'Name': 'Wall Street Journal',
        'URL': 'http://www.wsj.com/',
        'Must': ['http://www.wsj.com/'],
        'MustNot': ['/video/']
    },
    {
        'Index': 42,
        'Name': 'Belarus News',
        'URL': 'https://eng.belta.by/',
        'Must': ['https://eng.belta.by/'],
        'MustNot': ['/sport/','/video/']
    },
    {
        'Index': 43,
        'Name': 'CGTN',
        'URL': 'https://www.cgtn.com/',
        'Must': ['https://news.cgtn.com/'],
        'MustNot': None
    },
    {
        'Index': 44,
        'Name': 'Ecuador Times',
        'URL': 'https://www.ecuadortimes.net/',
        'Must': ['https://www.ecuadortimes.net/'],
        'MustNot': None
    },
    {
        'Index': 45,
        'Name': 'The Local France',
        'URL': 'https://www.thelocal.fr/',
        'Must': ['https://www.thelocal.fr/'],
        'MustNot': None
    },
    {
        'Index': 46,
        'Name': 'The Irish Times',
        'URL': 'https://www.irishtimes.com/news/health/coronavirus',
        'Must': ['https://www.irishtimes.com/'],
        'MustNot': ['/sport/']
    },
    {
        'Index': 47,
        'Name': 'The Asahi Shimbun',
        'URL': 'http://www.asahi.com/ajw/',
        'Must': ['http://www.asahi.com/ajw/'],
        'MustNot': ['/sport/']
    },
    {
        'Index': 48,
        'Name': 'Mexico News Daily',
        'URL': 'https://mexiconewsdaily.com/category/news/coronavirus/',
        'Must': ['https://mexiconewsdaily.com/news/'],
        'MustNot': None
    },
    {
        'Index': 49,
        'Name': 'NL Times',
        'URL': 'https://nltimes.nl/',
        'Must': ['https://nltimes.nl/'],
        'MustNot': None
    },
    {
        'Index': 50,
        'Name': 'Peruvian Times',
        'URL': 'https://www.peruviantimes.com/',
        'Must': ['https://www.peruviantimes.com/'],
        'MustNot': None
    },
    {
        'Index': 51,
        'Name': 'Khaleej Times',
        'URL': 'https://www.khaleejtimes.com/coronavirus-pandemic',
        'Must': ['https://www.khaleejtimes.com/'],
        'MustNot': ['/videos/']
    },
]
