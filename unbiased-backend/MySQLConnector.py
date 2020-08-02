import MySQLdb

class MySQLConnector:
    def connect(self):
        #print("连接数据库")
        self.db = MySQLdb.connect(host="localhost", port=3306, user="root", passwd="8848", db="news", charset='utf8')
        cursor = self.db.cursor()
        return cursor

    def disconnect(self):
        #print("关闭数据库连接")
        self.db.close()