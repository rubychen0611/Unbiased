/* Unbiased App 入口*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:unbiased/Common/Global.dart';
import 'package:unbiased/Common/State.dart';
import 'UI/IndexPage.dart';
import 'UI/SplashPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Global.init();
  // 初始化LeanCloud
  LeanCloud.initialize(
      'U83hlMObhFRFRS4kX3lOxSlq-gzGzoHsz', 'Jw2Y6KFFsjI5kEz1qYqQ62da',
      server: 'https://u83hlmob.lc-cn-n1-shared.com',
      queryCache: new LCQueryCache());
      //LCLogger.setLevel(LCLogger.DebugLevel);     // 启动LeanCloud调试

  runApp(UnbiasedApp());
}

class UnbiasedApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider.value(
    value: UserModel(),
    child: MaterialApp(
      title: 'Unbiased',
      theme: ThemeData(
        // 主题颜色
        primarySwatch: Colors.teal,
        // 密度
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //应用首页路由
      home: SplashPage(),   // 进入开屏页
      debugShowCheckedModeBanner: false,
    )
    );
  }
}