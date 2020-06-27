// 新闻组、文章数据结构
import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';



// 媒体
class Media
{
  String name;            // 媒体名
  String logo_url;       // 媒体logo图片的url地址
  Media({this.name, this.logo_url}){}
}

// 文章
class Article{
  String title;   // 文章标题
  Media media;    // 发布媒体
  DateTime date;  // 发布时间
  String summary;       // 摘要概括
  String img_url;       // 代表图片url
  int score;          // 情绪分析得分（0-100）
  String link_url;      // 原文地址
  Article({this.title, this.media, this.date, this.summary, this.img_url, this.score, this.link_url}){}

}

// 新闻组
class NewsGroup{
  int rank;                 // 排名
  String group_title;       // 标题
  List<Article> articles;           // 文章列表
  String img_url;           // 代表图片url
  bool is_expanded;       // 面板是否展开
  NewsGroup({this.rank, this.group_title, this.img_url, this.articles})
  {
    this.is_expanded = false;     // 默认不展开
  }
}

// 从Firestore数据库获取新闻数据
Future<List<NewsGroup>> getNewsGroupData() async
{
  List<NewsGroup> news_groups = new List<NewsGroup>();   // 存储新闻组详细信息

  // 获取新闻组
  LCQuery<LCObject> query = LCQuery('NewsGroup');
  query.orderByDescending('RankScore');     // 按得分排序
  //query.limit(15);          // 最多显示前15条
  //query.include('Image.url');
  List<LCObject> group_objs = await query.find();

  //获取各新闻组详细信息
  for (int i = 0; i < group_objs.length; i++) {
    List<dynamic> article_ids = group_objs[i]['Articles'];
    List<Article> articles = [];
    // 获取组内各文章详细信息
    LCQuery<LCObject> query_article = LCQuery('Article');
    query_article.include('Media.Name');
    query_article.include('Media.Logo.url');
    query_article.whereContainedIn('objectId', article_ids);
    List<LCObject> article_objs = await query_article.find();
    for (LCObject article_obj in article_objs)
    {
      articles.add(Article(
          title: article_obj['Title'],
          media: Media(
            name: article_obj['Media']['Name'],
            logo_url: article_obj['Media']['Logo']['url'],
          ),
          date: article_obj['Date'],
          summary: article_obj['Summary'],
          img_url: article_obj['ImageURL'],
          score: article_obj['SentimentScore'],
          link_url: article_obj['Link']
      ));
    }

    news_groups.add(NewsGroup(
        rank: i + 1,
        group_title: group_objs[i]['Title'],
        img_url: group_objs[i]['ImageURL'],
        articles: articles)
    );
  }
  return news_groups;
}