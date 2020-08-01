import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unbiased/Common/Global.dart';
import 'package:unbiased/Common/MyIcons.dart';
import 'package:unbiased/Common/Requests.dart';
import 'package:unbiased/DataModel/NewsGroup.dart';
import 'package:unbiased/UI/ArticlePage.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({Key key}) : super(key: key);
  @override
  _FavoritePageState createState() => new _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> with TickerProviderStateMixin {

  Future<List<Article>> future_favorites;
  @override
  void initState() {
    super.initState();
    future_favorites = getFavorites();
  }
  void _update()
  {
    setState(() {
      future_favorites = getFavorites();
    });
  }
//  @override
//  void deactivate() {
//    var bool = ModalRoute.of(context).isCurrent;
//
//    if (bool) {
//      future_favorites = getFavorites();
//    }
//
//  }

  @override
  Widget build(BuildContext context) {
    return  new Scaffold(
        appBar: AppBar(
        title: Text("My favorites"),
    ),
    body: SingleChildScrollView(
        child: Container(
          child: FutureBuilder<List<Article>>(
              future: future_favorites,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return buildFavoritesList(snapshot.data); // 显示收藏的新闻
                }
                else if (snapshot.hasError) {
                  return Center(child: Text("${snapshot.error}")); // 显示错误
                }
                return Center(child: CircularProgressIndicator()); // 显示进度条
              }
          ),
        )
    )
    );
  }

  Widget buildFavoritesList(List<Article> favorites) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      //禁用滑动事件
      shrinkWrap: true,
      itemCount: favorites.length,
      //item.articles.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: CachedNetworkImage(
            placeholder: (context, url) => CircularProgressIndicator(),
            imageUrl: favorites[index].media.logo_url,
            height: 32,
            errorWidget: (context, url, error) => Icon(Icons.error),
          ), // 媒体logo
          title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(favorites[index].title, style: TextStyle(fontSize: 16)), // 媒体名
                SizedBox(height: 7),
                Text("${favorites[index].media.name} · ${Global.getArticleTime(favorites[index].date)}", style: TextStyle(color: Colors.grey, fontSize:14))//// 时间
              ]
          ),
          trailing: Global.getSentimentIcon(favorites[index].score, 35), // 情绪图标
          onTap:  () {
            //导航到新闻详情页
            Navigator.push( context,
                MaterialPageRoute(builder: (context) {
                  return ArticlePage(article:favorites[index]);
                }
                )
            ).then((val)=>_update());
          }, // onTap: ,
        );
      },
      separatorBuilder: (BuildContext context,
          int index) => new Divider(),
    );
    }


}