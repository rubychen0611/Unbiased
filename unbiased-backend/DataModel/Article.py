class Article:
    def __init__(self, media_name, article):
        self.url = article.url
        self.media_name = media_name
        self.title = article.title
        self.date = article.publish_date
        self.image = article.top_image
        self.text = article.text
        self.keywords = article.keywords
        self.summary = article.summary


