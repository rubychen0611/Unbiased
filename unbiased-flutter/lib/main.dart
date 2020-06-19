import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'UI/HomePage.dart';
void main() {
  // 初始化LeanCloud
  LeanCloud.initialize(
      'U83hlMObhFRFRS4kX3lOxSlq-gzGzoHsz', 'Jw2Y6KFFsjI5kEz1qYqQ62da',
      server: 'https://u83hlmob.lc-cn-n1-shared.com',
      queryCache: new LCQueryCache());
      //LCLogger.setLevel(LCLogger.DebugLevel);     / / 启动LeanCloud调试

  runApp(UnbiasedApp());
}

class UnbiasedApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unbiased',
      theme: ThemeData(
        // 主题颜色
        primarySwatch: Colors.teal,
        // 密度
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //应用首页路由
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}