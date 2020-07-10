import logging
import time

from Analyzer import Analyzer
from Cleaner import Cleaner
from Cluster import Cluster
from Crawler import Crawler
from Uploader import Uploader


this_date = time.strftime("%Y%m%d", time.localtime())
# 爬取新闻
crawler = Crawler(this_date=this_date)
crawler.crawl()

# 聚类
cluster = Cluster(date=this_date)
cluster.remove_useless_articles()
cluster.load_articles()
cluster.cluster()

# 情绪分析
analyzer = Analyzer(date=this_date)
analyzer.analyze()

# 上传至LeanCloud
uploader = Uploader(date=this_date)
uploader.upload_new_groups()

# 删除过老或分数过低的新闻组
cleaner = Cleaner(date=this_date)
cleaner.clean()