import jieba.posseg as pseg
import MySQLdb
import re
from nltk.corpus import stopwords
from nltk import word_tokenize
from nltk.stem.porter import PorterStemmer
from nltk.stem import WordNetLemmatizer

from sklearn.feature_extraction.text import TfidfVectorizer,CountVectorizer
from sklearn.metrics import jaccard_similarity_score
import numpy as np
from sklearn.cluster import DBSCAN
from langdetect import detect
from langdetect import detect_langs
from MySQLConnector import MySQLConnector
from sklearn import preprocessing
punctuation = '!,;:?"\'.()'
porter_stemmer = PorterStemmer()
wordnet_lemmatizer = WordNetLemmatizer()

def myTokenizer(text):
    # 重写sklearn中CountVectorizer的分词方法
    # 分词
    token_pattern = re.compile(r"(?u)\b\w\w+\b")
    words = token_pattern.findall(text)

    for i in range(len(words)):
        words[i] = porter_stemmer.stem(words[i])            # 词根化
        words[i] = wordnet_lemmatizer.lemmatize(words[i])   # 词形化
    return words

class Cluster():
    def __init__(self, date):
        self.date='20200620'
        self.connector = MySQLConnector()

    def remove_punctuation(self,text):
        text = re.sub(r'[{}]+'.format(punctuation), '', text)
        return text.strip().lower()

    def load_articles(self):
        '''从数据库中获取未分类的数据'''
        cursor = self.connector.connect()
        sql = "SELECT idArticle, title, text, media, summary FROM news.article WHERE idGroup is NULL"
        try:
            cursor.execute(sql)
            self.articles = cursor.fetchall()
            # print(self.articles)
        except:
           print ("Error: unable to fecth data")
        self.connector.disconnect()


    def remove_useless_articles(self):
        self.load_articles()
        useless_articles = []
        media_articles = {}
        for article in self.articles:
            media = article[3]
            if media not in media_articles:
                media_articles[media] = set()
            title = article[1]
            if title in media_articles[media]:
                useless_articles.append(article[0])
                continue
            else:
                media_articles[media].add(title)
            media_articles[article[3]].add(article[1])
            if detect(article[1]) != 'en':
                # print(article[1])
                useless_articles.append(article[0])
            else:
                list_words = word_tokenize(self.remove_punctuation(article[2]))
                if len(list_words) < 30:
                    useless_articles.append(article[0])

        # print(useless_articles)
        cursor = self.connector.connect()
        for articleID in useless_articles:
            sql="DELETE FROM `news`.`article` WHERE(`idArticle` = %s)" % (articleID)
            try:
                cursor.execute(sql)
                self.connector.db.commit()
            except:
                self.connector.db.rollback()
                print("Unable to delete useless articles")
        self.connector.disconnect()
        print("Successfully removed %d articles" % len(useless_articles))

    def encode_text(self, encode_obj='title', vector='tf-idf'):
        '''
        多种方式编码文本
        '''
        if vector == 'count':
            vectorizer = CountVectorizer(stop_words='english', lowercase=True, binary=True, tokenizer=myTokenizer)
        elif vector == 'tf-idf':
            vectorizer = TfidfVectorizer(stop_words='english', lowercase=True, tokenizer=myTokenizer)
        corpus = []
        if encode_obj == 'title':       # 标题
            idx = 1
        elif encode_obj == 'summary':   # 摘要
            idx = 4
        elif encode_obj == 'text':      # 全文
            idx = 2

        for article in self.articles:
            corpus.append(article[idx])

        X = vectorizer.fit_transform(corpus)
        #print(len(vectorizer.get_feature_names()))
        # print (vectorizer.get_feature_names())
        return X


    def cluster(self):
        X = self.encode_text(encode_obj='text', vector='tf-idf')
        db_model = DBSCAN(eps=0.55, min_samples=3, metric='cosine').fit(X)
        self.group_list = db_model.labels_

        # 打印分组结果
        print(np.max(self.group_list))
        group_result = {}
        for i,label in enumerate(self.group_list):
            if label not in group_result:
                group_result[label] = []
            group_result[label].append(self.articles[i][1])
        for i in range(0, np.max(self.group_list) + 1):
            print (i)
            print(group_result[i])

    def upload_groups_to_DB(self):
        cursor = self.connector.connect()
        for i, label in enumerate(self.group_list):
            if label == -1:
                continue
            sql = "UPDATE news.article SET idGroup='%s%03d' WHERE idArticle = '%s'" % (self.date, label, self.articles[i][0])
            #print(sql)
            try:
                cursor.execute(sql)
                self.connector.db.commit()
            except:
                # 发生错误时回滚
                self.connector.db.rollback()
        self.connector.disconnect()

cluster = Cluster(date='20200620')
# cluster.remove_useless_articles() # 执行一次即可
cluster.load_articles()
cluster.cluster()
cluster.upload_groups_to_DB()


