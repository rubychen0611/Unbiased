import logging

from MySQLConnector import MySQLConnector
from textblob import TextBlob
from afinn import Afinn
from nltk.tokenize import sent_tokenize
from nltk.tokenize import word_tokenize
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
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

    def get_sentiment_score(self,title, text):

        sent_analyzer = SentimentIntensityAnalyzer()
        title_score = sent_analyzer.polarity_scores(title)['compound']
        title_score = int(round((title_score + 1) * 10))
        sents = sent_tokenize(text)
        scores = []
        for sent in sents:
            if(len(word_tokenize(sent)) > 1):       # 句子中单词大于1个
                score = sent_analyzer.polarity_scores(sent)['compound']
                scores.append(score)
        text_score = np.mean(scores)
        text_score = int(round((text_score + 1) * 40))
        final_score = title_score + text_score
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
        # sql = "SELECT articleIndex, title, text FROM news.article WHERE groupIndex is not null"
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
            sentiment_score = self.get_sentiment_score(article[1], article[2])
            # print(article[0] + '\t' + article[1] +'\t'+ str(sentiment_score))
            # upload to DB
            sql = "UPDATE news.article SET sentimentScore='%d',summary='%s' WHERE articleIndex = '%s'" % (sentiment_score, summary, article[0])
            #sql = "UPDATE news.article SET sentimentScore='%d' WHERE articleIndex = '%s'" % (sentiment_score, article[0])

            try:
                cursor.execute(sql)
                self.connector.db.commit()
                self.logger.info("Successfully upload article %s with score=%d", article[0], sentiment_score)
            except:
                self.logger.info("Unable to update summary and score!")
                self.connector.db.rollback()
        self.connector.disconnect()

# analyzer = Analyzer(date='20200801')
# analyzer.analyze()