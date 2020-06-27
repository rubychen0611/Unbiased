import MySQLdb
import os
import chardet
import pickle
import json
dir = './data/articles/20200620/'

media_dict = {'CCTV':1, 'Global Times':2, 'China Daliy':3,'Xinhua':4, "People's Daily":5,
              'BBC': 6, 'Daily Mail':7, 'The Guardian':8, 'The Times':9, 'The Huffington Post': 10,
              'CNN':11, 'The New York Times':12, 'Fox News':13, 'Focus Taiwan':14, 'The Globe And Mail':15,
              'The Japan Times':16, 'Euronews':17, 'Russia Today': 18}

db = MySQLdb.connect(host="localhost",port=3306,user= "root", passwd="8848", db="news", charset='utf8' )
cursor = db.cursor()

count = 1

def preprocess_text(text):
    text = text.replace("'", "''")
    return text


for media_name, media_no in media_dict.items():
    media_dir = os.path.join(dir,media_name)
    article_files = os.listdir(media_dir)
    for filename in article_files:
        f = open(os.path.join(media_dir, filename), 'rb')
        article = pickle.load(f)
        f.close()
        idArticle = '20200620%05d' %(count)
        title = preprocess_text(article.title)
        downloadDate='20200620'
        keywords = str(article.keywords).replace("'", '"')
        summary = preprocess_text(article.summary)
        text =preprocess_text(article.text)
        sql = """INSERT INTO `news`.`article` (`idArticle`, `title`, `media`, `date`, `downloadDate`, `image`,`url`,`keywords`, `summary`, `text`) 
        VALUES ('%s', '%s', '%d', '%s','20200620','%s', '%s', '%s', '%s', '%s');
        """ % (idArticle, title, media_no,article.date.strftime("%Y-%m-%d %H:%M:%S"), article.image, article.url,keywords, summary, text)
        # print(sql)

        try:
            cursor.execute(sql)
            db.commit()
        except MySQLdb._exceptions.OperationalError:
            db.rollback()
        count += 1


db.commit()
db.close()