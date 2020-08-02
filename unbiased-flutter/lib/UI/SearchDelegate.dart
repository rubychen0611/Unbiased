import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unbiased/Common/Global.dart';
import 'package:unbiased/DataModel/NewsGroup.dart';
import 'package:unbiased/UI/SearchResultsPage.dart';

import 'ArticlePage.dart';

typedef SearchItemCall = void Function(String item);

class SearchBarDelegate extends SearchDelegate<String> {
  Future<List<NewsGroup>> result_groups;
  @override
  List<Widget> buildActions(BuildContext context) {
    //右侧显示内容 这里放清除按钮
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //左侧显示内容 这里放了返回按钮
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        if (query.isEmpty) {
          close(context, null);
        } else {
          query = "";
          showSuggestions(context);
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //显示搜索结果页面
    return SearchResultsPage(keywords:query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //点击了搜索窗显示的页面
    return SearchContentView();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: Colors.teal,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.white),
      primaryColorBrightness: Brightness.light,
      hintColor: Colors.white,
      textTheme: TextTheme(title: TextStyle( color: Colors.white, fontSize: 20,),),
      inputDecorationTheme: InputDecorationTheme(hintStyle: Theme.of(context).textTheme.title.copyWith(color: Colors.white),),
      primaryTextTheme: theme.primaryTextTheme.apply( bodyColor: Colors.white, displayColor: Colors.white,decorationColor:Colors.white)
    );
  }

}

class SearchContentView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
