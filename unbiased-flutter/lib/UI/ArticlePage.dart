// 新闻详情页
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:provider/provider.dart';
import 'package:unbiased/Common/Global.dart';
import 'package:unbiased/Common/Requests.dart';
import 'package:unbiased/Common/State.dart';
import 'package:unbiased/DataModel/NewsGroup.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticlePage extends StatefulWidget {
  ArticlePage({
    Key key,
    @required this.article, // 接收一个Article参数
  }) : super(key: key);

  @override
  _ArticlePageState createState() => new _ArticlePageState();
  final Article article;
}



class _ArticlePageState extends State<ArticlePage> with TickerProviderStateMixin {
  bool _ifFavorite = false;

  @override
  void initState() {
    super.initState();
    initFavoriteState();
  }

  Future initFavoriteState() async {
    bool value = await getIfFavorite(widget.article.objectId);
    setState(() {
      _ifFavorite = value;
    });
  }

  void handleFavoriteChanges(bool isLogin) async
  {
    if (!isLogin) {
      Fluttertoast.showToast(msg: 'Please sign in/up first.');
      return;
    }

    try {
      bool succ = await addArticleToFavorites(widget.article.objectId);
      if (succ) {
        Fluttertoast.showToast(msg: 'Successfully added to favorites.');
        setState(() {
          _ifFavorite = true;
        });
      }
      else {
        Fluttertoast.showToast(msg: 'Removed from favorites.');
        setState(() {
          _ifFavorite = false;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error.');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Comment> commentsList = widget.article.comments;
    //print("article page: ");
    //print(commentsList[0].date);
//    print(Global.getArticleTime(commentsList[0].date));

    //print(commentsList[0].username);


    TextEditingController _userEtController = TextEditingController();
    return Scaffold(
        appBar: new AppBar(
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
            actions: <Widget>[ //增加收藏按钮
              Consumer<UserModel>(
                  builder: (BuildContext context, UserModel userModel,
                      Widget child) {
                    return new FavoriteButton(ifFavorite: _ifFavorite,
                        isLogin: userModel.isLogin(),
                        onChanged: handleFavoriteChanges);
                  }
              )
            ]
        ),
        body: new ListView(
          children: <Widget>[
            widget.article.img_url != null ? CachedNetworkImage( // 新闻图片（可缓存）
              placeholder: (context, url) =>
                  CircularProgressIndicator(),
              imageUrl: widget.article.img_url,
              errorWidget: (context, url, error) => Icon(Icons.error),
              height: 180.0,
              fit: BoxFit.cover,
            ) : Container(),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 5.0),
              child: new Text(
                widget.article.title,
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
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              imageUrl: widget.article.media.logo_url,
                              height: 32,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ],
                        )),
                  ),
                  Expanded(
                      flex: 7,
                      child: new Container(
                        child: new Text(
                          widget.article.media.name +
                              ' · ' +
                              Global.getArticleTime(widget.article.date),
//                    'Quartz' + ' · ' + '5 hrs',
                          style: new TextStyle(fontSize: 18),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: new Container(
                        alignment: Alignment.topRight,
                        child:
                        Global.getSentimentIcon(widget.article.score, 40),
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
                widget.article.summary,
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
                    onPressed: () {
                      // WebView跳转
                      //print(widget.article.link_url);
                      Navigator.of(context)
                          .push(new MaterialPageRoute(builder: (_) {
                        return new WebViewPage(
                          url: widget.article.link_url,
                        );
                      }));
//                      Navigator.push(context, MaterialPageRoute(builder: (cx) => WebViewPage(article.link_url)));
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
                          onPressed: () {
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 5.0, vertical: 10.0),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: new ListView.builder(
                        shrinkWrap: true,
                        itemCount: commentsList.length,
                        itemBuilder: (context, index) {
                          return new ListTile(
                            title: new Text(commentsList[index].content),
                            subtitle: new Text(
                                commentsList[index].username +
                                '   -   ' + commentsList[index].date.toString()),
                            leading: Icon(
                              Icons.account_circle,
                              size: 40,
                            ),
                          );
                        },
                      ),

                    )
                  ],
                )),
            Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: new Row(children: <Widget>[
                  new Container(
                    child: TextField(
                      controller: _userEtController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Type a new comment...',
                        icon: Icon(
                          Icons.account_circle,
                          size: 40,
                        ),
                      ),
                      autofocus: false,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (val) async{
                        print('输入了${val}');
                        try {
                          bool succ = await addCommentToArticle(widget.article.objectId, val);
                        }
                        catch (e) {
                          Fluttertoast.showToast(msg: 'Comment Error.');
                        }

                        _userEtController.text = "";
                        Fluttertoast.showToast(
                          msg: 'Successfully make comment.',
                          toastLength: Toast.LENGTH_LONG,
                          textColor: Colors.deepOrange,
                          gravity: ToastGravity.BOTTOM,
                        );
                        return EasyRefresh;
                      },
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
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSite'),
//        actions: <Widget>[
//          BlogMenu(_controller.future),
//        ],
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController controller) {
              _controller = controller;
            },
            navigationDelegate: (NavigationRequest request) {
              var url = request.url;
              print("visit $url");
              setState(() {
                isLoading = true; // 开始访问页面，更新状态
              });

              return NavigationDecision.navigate;
            },
            onPageFinished: (String url) {
              setState(() {
                isLoading = false; // 页面加载完成，更新状态
              });
            },
          ),
          isLoading
              ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
              : Container(),
        ],
      ),
//      body: SafeArea(
//        child: WebView(
//          initialUrl: url,
//          javascriptMode: JavascriptMode.unrestricted,
//          onWebViewCreated: (WebViewController controller) {
//            _controller = controller;
//          },
//        ),
//      ),
    );
  }

}

class FavoriteButton extends StatelessWidget {
  FavoriteButton(
      {Key key, this.ifFavorite: false, this.isLogin, this.onChanged})
      : super(key: key);
  final bool ifFavorite;
  final bool isLogin;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return new IconButton(
        icon: new Icon(
          isLogin && ifFavorite ? Icons.star : Icons.star_border, size: 32,),
        onPressed: () async {
          // 添加到收藏夹
          onChanged(isLogin);
        }
    );
  }
}
