// 新闻详情页
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:unbiased/DataModel/NewsGroup.dart';

class ArticlePage extends StatelessWidget {
  ArticlePage({
    Key key,
    @required this.article,  // 接收一个Article参数
  }) : super(key: key);
  final Article article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text("New route"),
      ),
      body: Center(     // TODO: 完整显示新闻标题、摘要、图片、媒体、时间、原网址链接等详细信息
        child: CachedNetworkImage(      // 新闻图片（可缓存）
          placeholder: (context, url) => CircularProgressIndicator(),
          imageUrl: article.img_url,
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}