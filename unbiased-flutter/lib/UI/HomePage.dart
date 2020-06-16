// 主页：显示新闻组
import 'package:flutter/material.dart';
import 'package:unbiased/DataModel/NewsGroup.dart';

class HomePage extends StatefulWidget {  //有状态组件
  HomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<NewsGroup>> future_news_group;
  @override
  void initState() {
    super.initState();
    future_news_group = getNewsGroupData(); // 获取数据
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Unbiased"),
          centerTitle: true,
        ),
        body:
        SingleChildScrollView(
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
                return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();   // 显示进度条
            }
          ),
          )
          )
        );
  }

  // 新闻主面板
//  Widget buildNewsGroupPanel(BuildContext context) {
//    getNewsGroupData().then((data)
//    {
//      // 成功获取数据，返回可展开列表
//      news_group = data;
//      //print(news_group[0].group_title);
//      return buildNewsGroupPanelList();
//    }).catchError((e) {
//      // 否则返回进度条
//      return Text("error!");
//    }).whenComplete(() => null)
//    return LinearProgressIndicator();
//  }

  Widget buildNewsGroupPanel(List<NewsGroup> news_group)
  {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          news_group[index].is_expanded = !isExpanded;
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
                        item.rank.toString(), style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center),
                  ),
                  Expanded(
                    flex: 62,
                    child: Text(item.group_title, style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w700)),
                  ),
                  Expanded(
                    flex: 28,
                    child: Padding(
                      //左边添加8像素补白
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Image.asset("images/blank.png")
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
              itemCount: 3,
              //item.articles.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(Icons.ac_unit), // 媒体logo
                  title: Text('media name'), // 媒体名 时间
                  trailing: Icon(Icons.sentiment_satisfied), // 情绪图标
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