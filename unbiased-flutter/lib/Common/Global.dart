// 全局变量及共享状态
import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:leancloud_storage/leancloud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unbiased/DataModel/Profile.dart';
class Global {
  static SharedPreferences _prefs;
  static Profile profile = Profile();
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    }
  }
  static saveProfile() {
    if (profile.user != null)
      _prefs.setString("profile", jsonEncode(profile.toJson ()));
    else
      _prefs.remove("profile");
  }

  // 将情绪得分转化为表情图标
  static Icon getSentimentIcon(int score)
  {
    if (0 <= score && score < 20)
      return Icon(Icons.sentiment_very_dissatisfied, color: Colors.red, size:40,);
    else if (20 <= score && score < 40 )
      return Icon(Icons.sentiment_dissatisfied, color: Colors.orange, size:40,);
    else if (40 <= score && score < 60)
      return Icon(Icons.sentiment_neutral, color: Colors.amberAccent, size:40,);
    else if (60 <= score && score <80)
      return Icon(Icons.sentiment_satisfied,  color: Colors.lime, size:40,);
    else
      return Icon(Icons.sentiment_very_satisfied, color: Colors.green, size:40,);
  }


  // 将文章发表时间转化为与当前时间差字符串
  static String getArticleTime(DateTime old)
  {
    String time_str;
    DateTime now = new DateTime.now();
    var difference = now.difference(old);
    if(difference.inDays > 1)
    {
      time_str = (difference.inDays).toString() + ' days ago';
    }
    else if(difference.inDays == 1)
    {
      time_str = '1 day ago';
    }
    else if(difference.inHours > 1 && difference.inHours < 24)
    {
      time_str = (difference.inHours).toString() + ' hrs ago';
    }
    else if(difference.inHours == 1)
    {
      time_str = '1 hour ago';
    }
    else if(difference.inMinutes > 5 && difference.inMinutes < 60)
    {
      time_str = (difference.inMinutes).toString() + ' mins ago';
    }
    else if(difference.inMinutes <= 5)
    {
      time_str =  'now';
    }
    return time_str;
  }
}