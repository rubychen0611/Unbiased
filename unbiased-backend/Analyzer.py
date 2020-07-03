import logging

from MySQLConnector import MySQLConnector
from textblob import TextBlob
from nltk.tokenize import sent_tokenize
from newspaper.article import Article, ArticleDownloadState
import numpy as np
class Analyzer:
    def __init__(self, date):
        self.date = date
        self.connector = MySQLConnector()

        self.logger = logging.getLogger('analyzer')
        self.logger.setLevel(level=logging.DEBUG)
        ch = logging.StreamHandler()
        ch.setLevel(logging.DEBUG)
        formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
        ch.setFormatter(formatter)
        self.logger.addHandler(ch)
        self.logger.info("Finished initialization.")

    def get_sentiment_score(self,text):
        paragraphs = text.split('\n')
        scores = []
        for para_text in paragraphs:
            if len(para_text) == 0:
                continue
            para = TextBlob(para_text)
            # print (para_text)
            # print(len(sent_tokenize(para_text)))
            scores.append(para.sentiment.polarity)
        # print (scores)
        sentences_num = len(scores)
        scores.sort()
        if sentences_num < 4:
            max = np.max(scores)
            min = np.min(scores)
        else:
            min = np.mean(scores[:int(0.25 * sentences_num)])
            max = np.mean(scores[int(0.75 * sentences_num):])
        if max > abs(min):
            final_score = max
        else:
            final_score = min

        final_score = int(round((final_score + 1) * 50))
        return final_score

    def preprocess_text(self, text):
        text = text.replace("'", "''")
        return text

    def get_summary(self, title, text):
        article = Article(url='')
        article.title = title
        article.text = text
        article.download_state = ArticleDownloadState.SUCCESS
        article.is_parsed = True
        article.nlp()
        return self.preprocess_text(article.summary)


    def analyze(self):
        # load articles
        cursor = self.connector.connect()
        sql = "SELECT articleIndex, title, text FROM news.article WHERE downloadDate=%s and groupIndex is not null" % self.date
        try:
            cursor.execute(sql)
            self.articles = cursor.fetchall()
            # print(self.articles)
        except:
            self.logger.info("Error: unable to fecth data")


        for article in self.articles:
            # generate summary
            summary = self.get_summary(article[1], article[2])
            # sentiment analysis
            sentiment_score = self.get_sentiment_score(article[2])
            # upload to DB
            sql = "UPDATE news.article SET sentimentScore='%d',summary='%s' WHERE articleIndex = '%s'" % (sentiment_score, summary, article[0])
            # print(sql)
            try:
                cursor.execute(sql)
                self.connector.db.commit()
                self.logger.info("Successfully upload article %s with score=%d", article[0], sentiment_score)
            except:
                self.logger.info("Unable to update summary and score!")
                self.connector.db.rollback()
        self.connector.disconnect()

analyzer = Analyzer(date='20200629')
analyzer.analyze()