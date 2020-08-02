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

// 评论
class Comment
{
  String content;     // 评论内容
  DateTime date;      // 评论时间
  LCUser user;    // 评论人
  Comment({this.content, this.date, this.user}){}

}

// 文章
class Article{
  String objectId;  // LeanCloud ObjectID
  String title;   // 文章标题
  Media media;    // 发布媒体
  DateTime date;  // 发布时间
  String summary;       // 摘要概括
  String img_url;       // 代表图片url
  int score;          // 情绪分析得分（0-100）
  String link_url;      // 原文地址
  List<Comment> comments;   // 评论
  Article({this.objectId, this.title, this.media, this.date, this.summary, this.img_url, this.score, this.link_url, this.comments}){}

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

