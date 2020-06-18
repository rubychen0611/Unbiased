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
  List<NewsGroup> news_groups = new List<NewsGroup>();   // 新闻组详细信息
  List<LCObject> group_ranks;     // 新闻组排名索引（从rank文档中获得）

  // 获取新闻组排名
  LCQuery<LCObject> query_rank = LCQuery('Rank');
  query_rank.orderByAscending('rank');
  group_ranks = await query_rank.find();

  //获取各新闻组详细信息
  LCQuery<LCObject> query_group = LCQuery('NewsGroup'),
      query_file = LCQuery('_File'),
      query_article = LCQuery('Article'),
      query_media = LCQuery('Media');
  for (LCObject rank_obj in group_ranks)
  {
    LCObject group_obj = await query_group.get(rank_obj['group'].objectId);   // 获得NewsGroup对象
    LCObject img_file_obj = await query_file.get(group_obj['Image'].objectId); // 获得图片文件对象
    List<dynamic> article_ids = group_obj['Articles'];
    List<Article> articles = [];
    // 获取各文章详细信息
    for(String article_id in article_ids)
    {
      LCObject article_obj = await query_article.get(article_id);
      LCObject media_obj = await query_media.get(article_obj['Media'].objectId);    // 获取媒体对象
      articles.add(Article(
        title: article_obj['Title'],
        media: Media(
            name: media_obj['Name'],
            logo_url: media_obj['Logo']['url']
        ),
        date: article_obj['Date'],
        summary: article_obj['Summary'],
        img_url: article_obj['Image']['url'],
        score: article_obj['SentimentScore'],
        link_url: article_obj['Link']
      ));
    }
    news_groups.add(NewsGroup(
        rank:rank_obj['rank'],
        group_title: group_obj['Title'],
        img_url: img_file_obj['url'],
        articles: articles)
    );
  }
  return news_groups;
}