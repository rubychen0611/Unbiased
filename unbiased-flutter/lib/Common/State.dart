import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:unbiased/DataModel/Profile.dart';
import 'package:unbiased/Common/Global.dart';

//共享状态
//class ProfileChangeNotifier extends ChangeNotifier{
//
//  Profile get _profile => Global.profile;
//
//  @override
//  void notifyListeners() {
//    Global.saveProfile();  //保存profile变更
//    super.notifyListeners();  ////通知依赖的Widget更新
//  }
//}
//
////用户状态
//class UserModel extends ProfileChangeNotifier {
// User get user => _profile.user;
//
//  // APP是否登录(如果有用户信息，则证明登录过)
//  bool get isLogin => user != null;
//
//  set user(User user){
//      //_profile.lastLogin = _profile.user?.login;
//      _profile.user = user;
//      notifyListeners();
//    }
//}

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
    //currentUser = user;
    currentUser = await LCUser.getCurrent();
    notifyListeners();        // 通知相关组件更新状态
  }
  Future logOut() async{
    await LCUser.logout();
    currentUser = await LCUser.getCurrent();
    notifyListeners();
  }
}