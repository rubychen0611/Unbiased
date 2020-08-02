import time
import logging
import MySQLdb
import newspaper
import datetime
import pytz
from MySQLConnector import MySQLConnector
from media_list import media_list

covid_19_keywords = ['covid-19', 'coronavirus','covid19' 'covid', '2019-ncov', 'corona', 'wuhan', 'pandemic','epidemic']

class Crawler:
    def __init__(self, last_date=None, this_date=None):
        self.connector = MySQLConnector()
        self.logger = logging.getLogger('crawler')
        self.logger.setLevel(level=logging.DEBUG)
        ch = logging.StreamHandler()
        ch.setLevel(logging.DEBUG)  # 输出到console的log等级的开关
        formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
        ch.setFormatter(formatter)
        self.logger.addHandler(ch)

        # load media list
        if last_date == None:
            last_date = self.get_last_date()
        self.last_date = datetime.datetime.strptime(last_date, '%Y%m%d').replace(tzinfo=pytz.utc)


        if this_date != None:
            self.today = this_date
        else:
            self.today = time.strftime("%Y%m%d", time.localtime())

        self.logger.info("Finished initialization.")



    def if_covid19_related(self, text):
        '''
        判断文章是否包含疫情关键词
        '''
        text_lower = text.lower()
        for kw in covid_19_keywords:
            if kw in text_lower:
                return True
        return False

    def if_url_satisfied(self, media, url):
        flag = False
        for must in media['Must']:
            if must in url:
                flag = True
        if not flag:
            return False

        if media['MustNot'] != None:
            for mustnot in media['MustNot']:
                if mustnot in url:
                    return False
        return True

    def preprocess_text(self, text):
        text = text.replace("'", "''")
        return text

    def crawl(self):
        '''
        爬新的文章（上次抓取时间之后发布的）
        '''
        self.cursor = self.connector.connect()
        cur_count = self.get_cur_count()
        for media in media_list:
            urls = media['URL']
            for idx, url in enumerate(urls):
                self.logger.info("Start crawl %s - %d  ..." % (media['Name'], idx))
                media_website = newspaper.build(url,language='en', memoize_articles=True)
                sum = len(media_website.articles)
                self.logger.info("Found %d articles" % sum )
                for i, article in enumerate(media_website.articles):
                    print(i, article.url)
                    if not self.if_url_satisfied(media, article.url):   # 网址前缀必须符合给定分类网址
                        continue
                    # print(article.url)
                    try:
                        article.download()
                        print("...download")
                        article.parse()
                        print("...parsed")
                    except:
                        continue

                    # 文章过老
                    if article.publish_date == None:
                        article.publish_date = datetime.datetime.now()

                    article.publish_date = article.publish_date.replace(tzinfo=pytz.utc)
                    if article.publish_date < self.last_date:
                        continue

                    # 文章与疫情无关
                    if not (self.if_covid19_related(article.title) or self.if_covid19_related(article.text)):
                        continue

                    # 上传到MySQL数据库
                    # article.nlp()

                    self.upload_article(cur_count, media['Index'], article)
                    self.logger.info("Successfuly download %d / %d th article %s \n %s" % (i, sum, article.url, article.title))
                    cur_count += 1

        self.connector.disconnect()

    def upload_article(self, count, media_index, article):
        #self.cursor = self.connector.connect()
        idArticle = '%s%05d' % (self.today, count)
        title = self.preprocess_text(article.title)
        url = self.preprocess_text(article.url)
        # keywords = str(article.keywords).replace("'", '"')
        # summary = self.preprocess_text(article.summary)
        text = self.preprocess_text(article.text)
        sql = """INSERT INTO `news`.`article` (`articleIndex`, `title`, `mediaIndex`, `publishDate`, `downloadDate`, `image`,`url`, `text`) 
                VALUES ('%s', '%s', '%d', '%s','%s','%s', '%s', '%s');
                """ % (
        idArticle, title, media_index, article.publish_date.strftime("%Y-%m-%d %H:%M:%S"), self.today, article.top_image,  url, text)
        try:
            self.cursor.execute(sql)
            self.connector.db.commit()

        except MySQLdb._exceptions.OperationalError:
            self.connector.db.rollback()
            self.logger.info("Unable to upload article to DB!")
        # self.connector.disconnect()


    def get_cur_count(self):
        # self.cursor = self.connector.connect()
        sql = '''select MAX(articleIndex) 
                from news.article 
              where articleIndex REGEXP '%s';''' % (self.today)
        try:
            self.cursor.execute(sql)
            max_idx = self.cursor.fetchall()
        except:
            self.logger.info("Unable to get current count!")
        #print(max_idx)
        #self.connector.disconnect()
        if max_idx[0][0] is None:
            count = 0
        else:
            count = int(max_idx[0][0][-5:]) + 1
        self.logger.info("Successfully get current count = %d ." % count)
        return count

    def get_last_date(self):
        self.cursor = self.connector.connect()
        sql = '''SELECT max(downloadDate) FROM news.article'''
        try:
            self.cursor.execute(sql)
            fetch_result = self.cursor.fetchall()
        except:
            self.logger.info("Unable to get last date!")
        self.connector.disconnect()
        if fetch_result[0][0] is None:
            last_date = "20200101"
        else:
            last_date = datetime.date.strftime(fetch_result[0][0],'%Y%m%d')
        print(last_date)
        self.logger.info("Successfully get lastdate '%s'." % last_date)
        return last_date

# crawler = Crawler(last_date = '20200708', this_date='20200709')
# crawler = Crawler()
#crawler.crawl()