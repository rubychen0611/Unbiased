
import 'dart:convert';

import 'package:leancloud_storage/leancloud.dart';
import 'package:unbiased/Common/State.dart';
import 'package:unbiased/DataModel/NewsGroup.dart';


// 从LeanCloud数据库获取新闻数据
Future<List<NewsGroup>> getNewsGroupData(int cur_count, bool loadMore) async
{
  List<NewsGroup> news_groups = new List<NewsGroup>();   // 存储新闻组详细信
  // 获取新闻组
  LCQuery<LCObject> query = LCQuery('NewsGroup');
  query.orderByDescending('RankScore');     // 按得分排序
  query.limit(15);          // 最多显示前15条
  if (loadMore==true)
    query.skip(cur_count);
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
      List<Comment> comments;
      for (LCObject comment in article_obj['Comments'])
      {
//        // 获取文章评论
//        comments.add(Comment(
//            content: comment['Content'],
//            date: comment['createdAt'],
//            user: LCUser(
//
//            )
//        ));
      }

      articles.add(Article(
          objectId: article_obj.objectId,
          title: article_obj['Title'],
          media: Media(
            name: article_obj['Media']['Name'],
            logo_url: article_obj['Media']['Logo']['url'],
          ),
          date: article_obj['Date'],
          summary: article_obj['Summary'],
          img_url: article_obj['ImageURL'],
          score: article_obj['SentimentScore'],
          link_url: article_obj['Link'],
          comments: comments
      ));
    }

    news_groups.add(NewsGroup(
        rank: cur_count + i + 1,
        group_title: group_objs[i]['Title'],
        img_url: group_objs[i]['ImageURL'],
        articles: articles)
    );
  }
  return news_groups;
}


// 获取我的收藏列表文章（用于显示my favorites页面）
Future<List<Article>> getFavorites() async
{
  LCUser user_obj = await LCUser.getCurrent();
  List<Article> favorites = new List<Article>();

  List<dynamic> article_ids = user_obj['Favorites'];
  LCQuery<LCObject> query_article = LCQuery('Article');
  query_article.include('Media.Name');
  query_article.include('Media.Logo.url');
  query_article.whereContainedIn('objectId', article_ids);
  List<LCObject> article_objs = await query_article.find();
  for (LCObject article_obj in article_objs)
  {
    favorites.add(Article(
        objectId: article_obj.objectId,
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
  return favorites;

}

Future <bool> getIfFavorite(String articleId) async     // 判断是否已收藏（用于显示星星图标）
{
  LCUser user_obj = await LCUser.getCurrent();
  if (user_obj == null)
    return false;
  List<dynamic> favoriteIds = user_obj['Favorites'];
  if (favoriteIds.indexOf(articleId) != -1)
    return true;
  return false;
}


Future<bool> addArticleToFavorites(String articleId) async    // 添加/移除收藏
{
  LCUser user_obj = await LCUser.getCurrent();
  List<dynamic> favoriteIds = user_obj['Favorites'];
  int index = favoriteIds.indexOf(articleId);

  if (index == -1)   // 不在列表里,添加
  {
    favoriteIds.add(articleId);
    user_obj['Favorites'] = favoriteIds;
    await user_obj.save();
    return true;
  }
  else    // 已经在列表里，删除
  {
    favoriteIds.removeAt(index);
    user_obj['Favorites'] = favoriteIds;
    await user_obj.save();
    return false;
  }
}