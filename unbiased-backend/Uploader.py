# 上传最新的新闻组至leancloud
from MySQLConnector import MySQLConnector
import leancloud
import logging
import numpy as np
class Uploader:
    def __init__(self, date):
        self.date = date
        self.articles = []
        self.connector = MySQLConnector()
        leancloud.init("U83hlMObhFRFRS4kX3lOxSlq-gzGzoHsz", "Jw2Y6KFFsjI5kEz1qYqQ62da")
        logging.basicConfig(level=logging.DEBUG)

    def upload_to_old_groups(self):
        '''如果新下载的新闻被分类到旧的新闻组，直接上传'''
        pass

    def upload_new_groups(self):
        '''上传新的新闻组'''
        cursor = self.connector.connect()
        sql = "SELECT articleIndex,groupIndex,title,publishDate,image,url,mediaObjId,sentimentScore,summary \
                FROM news.article INNER JOIN news.media ON article.mediaIndex = media.index     \
                where groupIndex is REGEXP '%s'"  % self.date
        try:
            cursor.execute(sql)
            articles = cursor.fetchall()
            # print(self.articles)
        except:
            print("Error: unable to fecth data")
        self.connector.disconnect()

        self.groups = {}
        for article in articles:
            groupIndex = article[1]
            if groupIndex not in self.groups:
                self.groups[groupIndex] = []
            self.groups[groupIndex].append(article)

        for groupIndex in self.groups:
            # upload articles
            article_obj_ids = []
            group_img = None
            for article in self.groups[groupIndex]:
                Article = leancloud.Object.extend('Article')
                Media = leancloud.Object.extend('Media')
                article_obj = Article()
                article_obj.set('ArticleIndex', article[0])
                article_obj.set('GroupIndex', article[1])
                article_obj.set('Title', article[2])
                article_obj.set('Date', article[3])
                if article[4] != '' :
                    article_obj.set('ImageURL', article[4])
                    group_img = article[4]
                article_obj.set('Link', article[5])
                article_obj.set('Media', Media.create_without_data(article[6])) # Pointer
                article_obj.set('SentimentScore', article[7])
                article_obj.set('Summary', article[8])
                article_obj.save()
                article_obj_ids.append(article_obj.id)
            # upload group info
            rank_score = self.cal_group_rank_score(self.groups[groupIndex])
            # print(groupIndex + '\t' + str(rank_score))
            # print(groupIndex, rank_score)
            NewsGroup = leancloud.Object.extend('NewsGroup')
            group_obj = NewsGroup()
            group_obj.set('Title', self.groups[groupIndex][0][2])       # 第一篇文章的title作为group title
            group_obj.set('GroupIndex', groupIndex)
            group_obj.set('RankScore', rank_score)
            if group_img is not None:
                group_obj.set('ImageURL', group_img)
            group_obj.set('Articles',(article_obj_ids))
            group_obj.save()

    def cal_group_rank_score(self, articles):
        article_num = len(articles)
        if article_num == 3:
            num_score = 2
        elif 4 <= article_num <= 8:
            num_score = 3
        else:
            num_score = 1

        senti_scores = []
        media_set = set()
        for article in articles:
            senti_scores.append(article[7])
            media_set.add(article[6])
        media_num = len(media_set)
        if media_num == 1:
            media_score = 0
        elif media_num == 2:
            media_score = 1
        elif media_num <= 4:
            media_score = 2
        else:
            media_score = 3

        senti_diff = int(np.max(senti_scores) - np.min(senti_scores))
        return num_score + media_score + senti_diff
        # return senti_diff




uploader = Uploader(date='20200725')
uploader.upload_new_groups()