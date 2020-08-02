import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';

class UserModel extends ChangeNotifier{
  LCUser currentUser;
  void setUser(LCUser user)
  {
    currentUser = user;
  }
  bool isLogin()
  {
    return currentUser != null;
  }

  Future update() async{
    currentUser = await LCUser.getCurrent();
    notifyListeners();        // 通知相关组件更新状态
  }
  Future logOut() async{
    await LCUser.logout();
    currentUser = await LCUser.getCurrent();
    notifyListeners();
  }
}