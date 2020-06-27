from MySQLConnector import MySQLConnector
from textblob import TextBlob
from nltk.tokenize import sent_tokenize
import numpy as np
class Analyzer:
    def __init__(self, date):
        self.date = date
        self.connector = MySQLConnector()

    def sentiment_analyze(self):
        # load articles
        cursor = self.connector.connect()
        sql = "SELECT idArticle, text FROM news.article WHERE downloadDate=%s and idGroup is not null" % self.date
        try:
            cursor.execute(sql)
            self.articles = cursor.fetchall()
            # print(self.articles)
        except:
            print("Error: unable to fecth data")


        # sentiment analysis

        for article in self.articles:
            paragraphs = article[1].split('\n')
            scores = []
            for para_text in paragraphs:
                if len(para_text) == 0:
                    continue
                para = TextBlob(para_text)
                #print (para_text)
                #print(len(sent_tokenize(para_text)))
                scores.append(para.sentiment.polarity)
            # print (scores)
            sentences_num = len(scores)
            scores.sort()
            if sentences_num < 4:
                max = np.max(scores)
                min = np.min(scores)
            else:
                min= np.mean(scores[:int(0.25 * sentences_num)])
                max= np.mean(scores[int(0.75 * sentences_num):])
            if max > abs(min):
                final_score = max
            else:
                final_score = min

            final_score = int(round((final_score+1)*50))
            sql = "UPDATE news.article SET sentimentScore='%d' WHERE idArticle = '%s'" % (final_score, article[0])
            # print(sql)
            try:
                cursor.execute(sql)
                self.connector.db.commit()
            except:
                print("Unable to update score!")
                self.connector.db.rollback()
        self.connector.disconnect()

analyzer = Analyzer(date='20200620')
analyzer.sentiment_analyze()