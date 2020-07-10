/* 开屏页 */
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:unbiased/UI/IndexPage.dart';
import 'package:unbiased/Common/MyIcons.dart';

class SplashPage extends StatefulWidget{

  SplashPage({Key key}):super(key:key);
  @override
  _SplashPage createState()=> new _SplashPage();

}

class _SplashPage extends State<SplashPage>{

  bool isStartHomePage = false;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: goToHomePage,//设置页面点击事件
//      child:
        child: Container(
         color: Colors.white,
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Icon(MyIcons.balance, color: Colors.teal, size: 150),
                  new Text('Unbiased', style: TextStyle(
                    fontFamily: "Courier",
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color:Colors.black,
                    fontSize: 28.0,
                    height: 1.2,)),
                ]
                )
          )
    )
   // )
    );
  }
  //页面初始化状态的方法
  @override
  void initState() {
    super.initState();
    //开启倒计时
    countDown();
  }

  void countDown() {
    //设置倒计时三秒后执行跳转方法
    var duration = new Duration(seconds: 2);
    new Future.delayed(duration, goToHomePage);
  }

  void goToHomePage(){
    //如果页面还未跳转过则跳转页面
    if(!isStartHomePage){
      //跳转主页 且销毁当前页面
      Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context)=>new IndexPage()), (Route<dynamic> rout)=>false);
      isStartHomePage=true;
    }
  }
}
