
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unbiased/Common/Global.dart';
import 'package:unbiased/Common/HighlightText.dart';
import 'package:unbiased/Common/Requests.dart';
import 'package:unbiased/DataModel/NewsGroup.dart';

import 'ArticlePage.dart';

class SearchResultsPage extends StatefulWidget {
  SearchResultsPage({
    Key key,
    @required this.keywords, // 接收搜索关键字做参数
  }) : super(key: key);
  @override
  _SearchResultsState createState() => new _SearchResultsState();
  final String keywords;
}
class _SearchResultsState extends State<SearchResultsPage> {
  Future<List<NewsGroup>> future_result_groups;
  @override
  void initState() {
    super.initState();
    future_result_groups = getSearchResults(widget.keywords);
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
          child: FutureBuilder<List<NewsGroup>>(
              future: future_result_groups,
              builder:(context, snapshot)
              {
                if(snapshot.hasData)
                {
                  if(snapshot.data.length == 0)
                    return Center(child:Text("Not found."));        // 未找到
                  else return buildNewsGroupPanel(snapshot.data);        // 显示新闻组
                }
                else if (snapshot.hasError)
                {
                  return Center(child: Text("${snapshot.error}"));      // 显示错误
                }
                return Center(child:CircularProgressIndicator());// 显示进度条
              }
          ),
        )
    );
  }


  Widget buildNewsGroupPanel(List<NewsGroup> news_groups) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          news_groups[index].is_expanded = !isExpanded; // 切换展开状态
        });
      },
      children: news_groups.map<ExpansionPanel>((NewsGroup item) {
        // 可展开列表
        return ExpansionPanel(
          // 未展开时主标题内容
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Container(
              padding: EdgeInsets.all(5.0), //容器内留白
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Container()
                  ),
                  Expanded(
                    flex: 62,
                    child: HighlightText(text:item.group_title,style:TextStyle(fontSize: 20, fontWeight: FontWeight.w700), highlight: widget.keywords, highlightColor: Colors.red)
                  ),
                  Expanded(
                    flex: 28,
                    child: Padding(
                      //左边添加补白
                      padding: const EdgeInsets.only(left: 5.0),
                      child: CachedNetworkImage( // 新闻组代表图片（可缓存）
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        imageUrl: item.img_url,
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                ],
              ),
              //
            );
          },
          //展开后内容
          body: Container(
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              //禁用滑动事件
              shrinkWrap: true,
              itemCount: item.articles.length,
              //item.articles.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CachedNetworkImage(
                    placeholder: (context, url) => CircularProgressIndicator(),
                    imageUrl: item.articles[index].media.logo_url,
                    height: 32,
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ), // 媒体logo
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(item.articles[index].title,
                            style: TextStyle(fontSize: 16)),
                        // 媒体名
                        SizedBox(height: 7),
                        Text("${item.articles[index].media.name} · ${Global
                            .getArticleTime(item.articles[index].date)}",
                            style: TextStyle(color: Colors.grey, fontSize: 14))
                        //// 时间
                      ]
                  ),
                  trailing: Global.getSentimentIcon(
                      item.articles[index].score, 35), // 情绪图标
                  onTap: () {
                    //导航到新闻详情页
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return ArticlePage(article: item.articles[index]);
                        }
                        )
                    );
                  }, // onTap: ,
                );
              },
              separatorBuilder: (BuildContext context,
                  int index) => new Divider(),
            ),
          ),

          isExpanded: item.is_expanded,
        );
      }).toList(),
    );
  }
}
