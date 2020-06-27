import csv
import os
import time
import logging
import newspaper
import pickle
import datetime
import pytz
from media_list import media_list
from DataModel.Article import Article
media_list_file = './data/media.csv'
covid_19_keywords = ['covid-19', 'coronavirus','covid19' 'covid', '2019-ncov', 'corona', 'wuhan', 'pandemic','epidemic']


class Crawler:
    def __init__(self):
        # load media list
        self.media_list = []
        with open(media_list_file, "r") as f:
            reader = csv.DictReader(f)
            for row in reader:
                self.media_list.append(row)

        self.today = time.strftime("%Y%m%d", time.localtime())
        self.data_dir = os.path.join('./data/articles', self.today)
        if not os.path.exists(self.data_dir):
            os.mkdir(self.data_dir)

        self.logger = logging.getLogger('crawler')
        self.logger.setLevel(level=logging.DEBUG)
        ch = logging.StreamHandler()
        ch.setLevel(logging.DEBUG)  # 输出到console的log等级的开关
        formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
        ch.setFormatter(formatter)
        self.logger.addHandler(ch)
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


    def save_article(self, article, filename):
        f = open(filename, 'wb')
        pickle.dump(article, f)
        f.close()
    def crawl(self, last_date):
        '''
        爬新的文章（上次抓取时间之后发布的），存储到本地csv表格中，日期时间命名
        '''
        #article_lists_file =  open(os.path.join(self.data_dir, self.today + '.csv'), 'w')
        #fieldnames = ['No','URL','MediaName','Title','Date','Image','Keywords','Summary', 'TextFile'] # 可以先不分析summary和情绪分数，分组后再分析
        fieldnames = ['No', 'Filename']
        # csv_writer = csv.DictWriter(article_lists_file, fieldnames=fieldnames)
        #csv_writer.writeheader()
        #count_all = 1
        for media in media_list:
            self.logger.info("Start crawl %s  ..." % (media['Name']))
            media_dir =os.path.join(self.data_dir, media['Name'])
            if not os.path.exists(media_dir):
                os.mkdir(media_dir)
            media_website = newspaper.build(media['URL'],language='en', memoize_articles=False)
            self.logger.info("Found %d articles" % (len(media_website.articles)))
            count_media = 1
            for i, article in enumerate(media_website.articles):
                if self.if_url_satisfied(media, article.url):   # 网址前缀必须符合给定分类网址
                    continue
                # print(article.url)
                try:
                    article.download()
                    article.parse()
                except newspaper.article.ArticleException:
                    continue

                # 文章过老
                if article.publish_date == None:
                    article.publish_date = datetime.datetime.now()

                article.publish_date = article.publish_date.replace(tzinfo=pytz.utc)
                if article.publish_date < last_date:
                    continue

                # 文章与疫情无关
                if not (self.if_covid19_related(article.title) or self.if_covid19_related(article.text)):
                    continue

                # 保存文章
                article.nlp()
                article_obj = Article(media['Name'], article)
                save_filename = os.path.join(media_dir, '%d.pkl' % (count_media))
                self.save_article(article_obj, save_filename)
                # csv_writer.writerow({
                #     'No': count_all,
                #     'Filename': save_filename
                # })
                # count_all += 1
                count_media += 1
                self.logger.info("Successfuly download %dth article %s \n %s" % (i, article.url, article.title))

        #article_lists_file.close()

    def cluster(self):
        '''
        对本次爬取结果聚类，输出到文件
        '''
        pass

    def upload(self):
        '''
        先请求目前数据库已有组，
        比较并上传结果（符合要求的组）到数据库，保存剩余组到下一次的文件中
        '''



crawler = Crawler()
last_date = datetime.datetime(2020,1,1).replace(tzinfo=pytz.utc)
crawler.crawl(last_date)