import 'package:flutter/material.dart';
import 'package:unbiased/Common/MyIcons.dart';
import 'package:unbiased/UI/LoginPage.dart';
import 'package:provider/provider.dart';
import 'package:unbiased/Common/State.dart';
class MinePage extends StatefulWidget {
  MinePage({Key key}) : super(key: key);
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String _userInfo;
//
//  void _requestData() async {
//    UserInfo userInfo = await PXRequest.px_getuser();
//    print(userInfo.userName);
//    setState(() {
//      _userInfo = userInfo;
//    });
//  }

//  @override
//  void initState() {
//    super.initState();
//    _requestData();
//  }

  Widget _cell(int row, IconData iconData, String title, bool ifJump, bool isShowBottomLine) {
    return Consumer<UserModel>(
        builder: (BuildContext context, UserModel userModel, Widget child) {
        return GestureDetector(
        onTap: () {
          switch (row) {
            case 0:
              print("$row -- $title");
              break;
            case 1:
              print("$row -- $title");
              break;
            case 2:
              print("$row -- $title");
              break;
            case 3:
              print("$row -- $title");
              break;
            case 4:
              print("$row -- $title");
              break;
            case 5:
              showDialog(
                context: context,
                builder: (ctx) {
                  //退出账号前先弹二次确认窗
                  return AlertDialog(
                    content: Text("Sure to log out?"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Cancel"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      FlatButton(
                        child: Text("Yes"),
                        onPressed: () {
                          //该赋值语句会触发MaterialApp rebuild
                          userModel.user = null;
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
              break;
          }
        },
        child: new Container(
          color: Colors.white,
          height: 50.0,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                  margin: new EdgeInsets.all(0.0),
                  height: (isShowBottomLine ? 49.0 : 50.0),
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Container(
                          margin: new EdgeInsets.only(left: 15.0),
                          child: new Row(
                            children: <Widget>[
                              new Icon(iconData, color: Colors.teal),
                              new Container(
                                margin: new EdgeInsets.only(left: 15.0),
                                child: new Text(title, style: TextStyle(color: Color(0xFF777777), fontSize: 16.0)),
                              )
                            ],
                          ),
                        ),
                        ifJump? new Icon(Icons.keyboard_arrow_right, color: Color(0xFF777777)):Container(),
                      ]
                  )
              ),

              _bottomLine(isShowBottomLine),

            ],
          ),
        ),
      );
    }
    );
  }

  Widget _bottomLine(bool isShowBottomLine) {
    if (isShowBottomLine) {
      return new Container(
          margin: new EdgeInsets.all(0.0),
          child: new Divider(
              height: 1.0,
              color: Colors.grey
          ),
          padding: EdgeInsets.only(left: 15.0, right: 15.0)
      );
    }
    return Container();
  }

  Widget _spaceView() {
    return Container(
      height: 10.0,
      color: Colors.black12,
    );
  }

  Widget _topView() {
    return Consumer<UserModel>(
        builder: (BuildContext context, UserModel value, Widget child) {
        return GestureDetector(
        onTap: () {
          if (!value.isLogin) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }
                ));
          }
        },
        child: new Container(
          height: 120.0,
          color: Colors.white,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              new Container(
                height: 90.0,
                margin: new EdgeInsets.only(top: 20.0),
//              color: Colors.yellow,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                        padding: new EdgeInsets.only(left: 15.0),
                        child: new Card(
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(new Radius.circular(35.0))
                          ),
                          child:Icon(MyIcons.avatar, color: Colors.grey, size:70.0),
                        )
                    ),

                    new Container(
                      margin: new EdgeInsets.only(left: 8.0, top: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(value.isLogin
                              ? value.user.username
                              : "Sign in", style: TextStyle(color: Color(0xFF777777), fontSize: 22.0), textAlign: TextAlign.left),
                        ],
                      ),
                    ),
//                  new Container(
//                    child: new Icon(Icons.keyboard_arrow_right, color: Color(0xFF777777)),
//                    margin: new EdgeInsets.only(left: MediaQuery.of(context).size.width/ 2 - 15.0),
//                  )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        child: new ListView.builder(
          physics: new AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _topView();
            } else if (index == 1) {
              return _spaceView();
            }else if (index == 2) {
              return _cell(index, Icons.star, "My favorite", true, true);
            } else if (index == 3) {
              return _cell(index, Icons.help, "Help", true, true);
            }  else if (index == 4) {
              return _cell(index, Icons.settings, "Settings",  true, true);
            } else if (index == 5) {
              return _cell(index, Icons.power_settings_new, "Log out", false, false);
            }
            else {
              return new Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
              );
            }
          },
          itemCount: 6 + 1,
        ),
      ),
    );
  }
}
