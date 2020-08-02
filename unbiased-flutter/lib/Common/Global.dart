// 全局变量
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:unbiased/Common/State.dart';
class Global {

  static UserModel userModel;
  static Future init() async {

    userModel = UserModel();
    LCUser currentUser = await LCUser.getCurrent();
    userModel.setUser(currentUser);
  }

  // 将情绪得分转化为表情图标
  static Icon getSentimentIcon(int score, double size)
  {
    if (0 <= score && score < 40)
      return Icon(Icons.sentiment_very_dissatisfied, color: Colors.red, size:size,);
    else if (40 <= score && score < 45 )
      return Icon(Icons.sentiment_dissatisfied, color: Colors.orange, size:size,);
    else if (45 <= score && score < 55)
      return Icon(Icons.sentiment_neutral, color: Colors.amberAccent, size:size,);
    else if (55 <= score && score < 60)
      return Icon(Icons.sentiment_satisfied,  color: Colors.lime, size:size,);
    else
      return Icon(Icons.sentiment_very_satisfied, color: Colors.green, size:size,);
  }


  // 将文章发表时间转化为与当前时间差字符串
  static String getArticleTime(DateTime old) {
    String time_str;
    DateTime now = new DateTime.now();
    var difference = now.difference(old);
    if (difference.inDays > 1) {
      time_str = (difference.inDays).toString() + ' days ago';
    }
    else if (difference.inDays == 1) {
      time_str = '1 day ago';
    }
    else if (difference.inHours > 1 && difference.inHours < 24) {
      time_str = (difference.inHours).toString() + ' hrs ago';
    }
    else if (difference.inHours == 1) {
      time_str = '1 hour ago';
    }
    else if (difference.inMinutes > 5 && difference.inMinutes < 60) {
      time_str = (difference.inMinutes).toString() + ' mins ago';
    }
    else if (difference.inMinutes <= 5) {
      time_str = 'now';
    }
    return time_str;
  }
}