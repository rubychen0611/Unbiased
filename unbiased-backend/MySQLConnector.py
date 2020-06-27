import MySQLdb

class MySQLConnector:
    def connect(self):
        self.db = MySQLdb.connect(host="localhost", port=3306, user="root", passwd="8848", db="news", charset='utf8')
        cursor = self.db.cursor()
        return cursor

    def disconnect(self):
        self.db.close()