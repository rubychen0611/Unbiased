import datetime
import logging
import leancloud
import pytz

from MySQLConnector import MySQLConnector


class Cleaner:
    def __init__(self, date):
        self.date = datetime.datetime.strptime(date, '%Y%m%d')
        self.connector = MySQLConnector()
        leancloud.init("U83hlMObhFRFRS4kX3lOxSlq-gzGzoHsz", "Jw2Y6KFFsjI5kEz1qYqQ62da")
        logging.basicConfig(level=logging.DEBUG)
        self.logger = logging.getLogger('analyzer')
        self.logger.setLevel(level=logging.DEBUG)
        ch = logging.StreamHandler()
        ch.setLevel(logging.DEBUG)
        formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
        ch.setFormatter(formatter)
        self.logger.addHandler(ch)
        self.logger.info("Finished initialization.")

    def clean_group(self, groupObjectId):
        NewsGroup = leancloud.Object.extend('NewsGroup')
        query = NewsGroup.query
        Article = leancloud.Object.extend('Article')
        group = query.get(groupObjectId)
        articles = group.get('Articles')
        # print(articles)
        count = len(articles)
        for article_id in articles:
            article = Article.create_without_data(article_id)
            article.destroy()
        # 删除组
        group.destroy()
        self.logger.info("Successfully deleted %d articles " % count)

    def clean(self, days_num = 30, group_score_threshold=10):
        '''
        删除days_num天以前，以及分数低于group_score_threshold的新闻组及其文章
        '''
        NewsGroup = leancloud.Object.extend('NewsGroup')
        query1 = NewsGroup.query
        query1.less_than('RankScore', group_score_threshold)
        query2 = NewsGroup.query
        query2.less_than('createdAt', self.date + datetime.timedelta(days=-days_num))

        query = leancloud.Query.or_(query1, query2)
        group_list = query.find()
        # print(group_list)
        self.logger.info("Successfully deleted %d old groups" % len(group_list))
        count = 0
        Article = leancloud.Object.extend('Article')
        for group in group_list:
            # 删除组内文章
            articles = group.get('Articles')
            count += len(articles)
            for article_id in articles:
                article = Article.create_without_data(article_id)
                article.destroy()
            # 删除组
            group.destroy()
        self.logger.info("Successfully deleted %d articles" % count)


# cleaner = Cleaner(date='20200801')
# cleaner.clean()
# cleaner.clean_group('5f2546bf6eb9ae0006909666')
