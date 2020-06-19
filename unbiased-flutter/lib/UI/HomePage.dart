// 主页：显示新闻组
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:unbiased/DataModel/NewsGroup.dart';
import 'package:unbiased/Common/Global.dart';
import 'package:unbiased/UI/ArticlePage.dart';


class HomePage extends StatefulWidget {  //有状态组件
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<NewsGroup>> future_news_group;
  @override
  void initState() {
    super.initState();
    future_news_group = getNewsGroupData(); // 获取新闻数据
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Unbiased"),
          centerTitle: true,
        ),
        body:SingleChildScrollView(
          child: Container(
            child: FutureBuilder<List<NewsGroup>>(
            future: future_news_group,
            builder:(context, snapshot)
            {
                if(snapshot.hasData)
                {
                  return buildNewsGroupPanel(snapshot.data);
                }
                else if (snapshot.hasError)
                {
                return Center(child: Text("${snapshot.error}"));      // 显示错误
                }
                return Center(child:CircularProgressIndicator());   // 显示进度条
            }
          ),
          )
          )
        );
  }

  // 新闻主面板
  Widget buildNewsGroupPanel(List<NewsGroup> news_group)
  {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          news_group[index].is_expanded = !isExpanded;      // 切换展开状态
        });
      },
      children: news_group.map<ExpansionPanel>((NewsGroup item) {
        // 可展开列表
        return ExpansionPanel(
          // 未展开时主标题内容
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Container(
              padding: EdgeInsets.all(5.0), //容器内留白
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 10,
                    child: Text(
                        item.rank.toString(), style: TextStyle(fontSize: 18),     // 排名/序号
                        textAlign: TextAlign.center
                    ),
                  ),
                  Expanded(
                    flex: 62,
                    child: Text(item.group_title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)), // 新闻组标题
                  ),
                  Expanded(
                    flex: 28,
                    child: Padding(
                      //左边添加补白
                        padding: const EdgeInsets.only(left: 3.0),
                        child: CachedNetworkImage(      // 新闻组代表图片（可缓存）
                            placeholder: (context, url) => CircularProgressIndicator(),
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
                  title: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(item.articles[index].media.name, style: TextStyle(fontSize: 20)), // 媒体名
                        SizedBox(width: 15),
                        Text(Global.getArticleTime(item.articles[index].date), style: TextStyle(color: Colors.grey))//// 时间
                    ]
                  ),
                  trailing: Global.getSentimentIcon(item.articles[index].score), // 情绪图标
                  onTap:  () {
                        //导航到新闻详情页
                        Navigator.push( context,
                            MaterialPageRoute(builder: (context) {
                              return ArticlePage(article:item.articles[index]);
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





