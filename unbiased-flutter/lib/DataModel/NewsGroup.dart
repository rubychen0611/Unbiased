// 新闻组、文章数据结构
import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';

class Article{
  String _title;   // 文章标题
//  String media_name;
//  String time;
//  String main_text;
//  Image main_image;
  Article(this._title);

//  String get article_title => _title;
//
//  Article.fromSnapshot(DocumentSnapshot doc) {
//    _title = doc['Title'];
//  }

}
class NewsGroup{
  int rank;
  String group_title;
  // List<Article> articles;
  //String image_url;
  bool is_expanded;
  NewsGroup(int rank, LCObject group_obj)
  {
    this.is_expanded = false;
    this.rank = rank;
    this.group_title = group_obj['Title'];
  }
}

// 从Firestore数据库获取新闻数据
Future<List<NewsGroup>> getNewsGroupData() async
{
  List<NewsGroup> news_groups = new List<NewsGroup>();   // 新闻组详细信息
  List<LCObject> group_ranks;     // 新闻组排名索引（从rank文档中获得）

  // 获取新闻组排名
  LCQuery<LCObject> query = LCQuery('Rank');
  query.orderByAscending('rank');
  group_ranks = await query.find();

  //获取各新闻组详细信息
  query= LCQuery('NewsGroup');
  for (LCObject rank_obj in group_ranks)
  {
    //print(rank_obj);
    LCObject group = await query.get(rank_obj['group'].objectId);
    news_groups.add(NewsGroup(rank_obj['rank'], group));
  }
  return news_groups;
}