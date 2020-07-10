/* 登录/注册页面*/

import 'package:flutter/material.dart';
import 'package:unbiased/Common/MyIcons.dart';
import 'package:unbiased/UI/SignInPage.dart';
import 'package:unbiased/UI/SignUpPage.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  PageController _pageController;
  PageView _pageView;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
    _pageView = new PageView(
      controller: _pageController,
      children: <Widget>[
        new SignInPage(),
        new SignUpPage(),
      ],
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          //title: Text("New route"),
        ),
        body: new SafeArea( //SafeArea，让内容显示在安全的可见区域，可以避免一些屏幕有刘海或者凹槽的问题
          child: new SingleChildScrollView(
            /**
             * 用SingleChildScrollView+Column，避免弹出键盘的时候，出现overFlow现象
             */
              child: new Container(
                  height: MediaQuery.of(context).size.height, //利用MediaQuery可以获取到跟屏幕信息有关的数据
                  width: MediaQuery.of(context).size.width,
                  child: new Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new SizedBox(
                        height: 30,
                      ),

                      //顶部Logo
                      new Icon(MyIcons.balance,color:Colors.teal, size:100),
                      new Text('Unbiased',style: TextStyle(
                        fontFamily: "Courier",
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        height: 1.2,)),
                      new SizedBox(
                        height: 20,
                      ),

                      //中间的Indicator指示器
                      new Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Color(0x552B2B2B),
                        ),
                        child: new Row(
                          children: <Widget>[
                            Expanded(
                                child: new Container(
                                  decoration: _currentPage == 0
                                      ? BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(25),
                                    ),
                                    color: Colors.white,
                                  )
                                      : null,
                                  child: new Center(
                                    child: new FlatButton(
                                      onPressed: () {
                                        _pageController.animateToPage(0,
                                            duration: Duration(milliseconds: 500),
                                            curve: Curves.decelerate);
                                      },
                                      child: new Text(
                                        "Existing",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                )),
                            Expanded(
                                child: new Container(
                                  decoration: _currentPage == 1
                                      ? BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(25),
                                    ),
                                    color: Colors.white,
                                  )
                                      : null,
                                  child: new Center(
                                    child: new FlatButton(
                                      onPressed: () {
                                        _pageController.animateToPage(1,
                                            duration: Duration(milliseconds: 500),
                                            curve: Curves.decelerate);
                                      },
                                      child: new Text(
                                        "New",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      new Expanded(child: _pageView),
                    ],
                  ))),
        ));
  }
}