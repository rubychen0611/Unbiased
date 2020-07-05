// 新闻详情页
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:unbiased/Common/Global.dart';
import 'package:unbiased/DataModel/NewsGroup.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticlePage extends StatelessWidget {
  ArticlePage({
    Key key,
    @required this.article, // 接收一个Article参数
  }) : super(key: key);
  final Article article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text(''),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                    Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
        body: new ListView(
          children: <Widget>[
            article.img_url!=null? CachedNetworkImage( // 新闻图片（可缓存）
              placeholder: (context, url) =>
                  CircularProgressIndicator(),
              imageUrl: article.img_url,
              errorWidget: (context, url, error) => Icon(Icons.error),
              height: 180.0,
              fit: BoxFit.cover,
            ) : Container(),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 5.0),
              child: new Text(
//                '\'Once Upon a Virus\': China mocks U.S. coronavirus response in Lego-like animation',
                article.title,
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
//                height: 1.5
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 10.0),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: new Container(
                        child: new Row(
                          children: <Widget>[
                            CachedNetworkImage(
                              placeholder: (context, url) => CircularProgressIndicator(),
                              imageUrl: article.media.logo_url,
                              height: 32,
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ],
                        )),
                  ),
                  Expanded(
                      flex: 7,
                      child: new Container(
                        child: new Text(
                          article.media.name +
                              ' · ' +
                              Global.getArticleTime(article.date),
//                    'Quartz' + ' · ' + '5 hrs',
                          style: new TextStyle(fontSize: 18),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: new Container(
                        alignment: Alignment.topRight,
                        child:
                          Global.getSentimentIcon(article.score, 40),
                      ))
                ],
              ),
            ),
            Divider(
              height: 5.0,
              indent: 10.0,
              endIndent: 10.0,
              thickness: 1,
              color: Colors.grey,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 10.0),
              child: new Text(
                article.summary,
                style: new TextStyle(fontSize: 18.0, height: 1.5),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 10.0),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: new Container(
                        child: new Row(
                          children: <Widget>[
                            new Icon(Icons.link, color: Colors.teal),
                          ],
                        )),
                  ),
                  new Text(
                    'Visit Website',
                    style: new TextStyle(fontSize: 18),
                  ),
                  new IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    color: Colors.teal,
                    onPressed:(){
                      // WebView跳转
                      Navigator.push(context, MaterialPageRoute(builder: (cx) => WebViewPage()));
                    },

                  ),
                  Expanded(
                      flex: 7,
                      child: new Container(
                        alignment: Alignment.topRight,
                        child: new IconButton(
                          icon: Icon(Icons.error_outline),
                          color: Colors.red,
                          iconSize: 30,
                          onPressed:(){
                            Fluttertoast.showToast(
                              msg: 'Successfully sent report.',
                              toastLength: Toast.LENGTH_LONG,
                              textColor: Colors.deepOrange,
                              gravity: ToastGravity.BOTTOM,
                            );
                          },
                        ),
                      ))
                ],
              ),
            ),
            Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: new Row(children: <Widget>[
                  new Container(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Type a new comment...',
                        icon: Icon(
                          Icons.account_circle,
                          size: 40,
                        ),
                      ),
                      autofocus: false,
                    ),
                    width: 350,
                  ),
                ])),
          ],
        )
    );
  }
}
class WebViewPage extends StatefulWidget {
  String url;
  WebViewPage({this.url});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WebViewPageState(url: url);
  }
}

class WebViewPageState extends State<WebViewPage> {
  String url;
  WebViewPageState({this.url});
  WebViewController _controller;
  double _height = 700;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSite'),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: _height,
            child: Card(
              child: WebView(
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
//                onWebViewCreated: (WebViewController webViewController) {
//                  _controller.complete(webViewController);
//                },
                onPageFinished: (url) {
                  //调用JS得到实际高度
                  _controller.evaluateJavascript("document.documentElement.clientHeight;").then((result){
                    setState(() {
                      _height = double.parse(result);
                      print("高度$_height");
                    });
                  }
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

}
