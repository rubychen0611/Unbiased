/* 用户信息 */
class User
{
  String username;  // 用户名
  String password;  // 密码
  String objectId;  // LeanCloud对象id
  User(this.username, this.password, this.objectId);
}
class Profile {

  User user;
  Profile()
  {
    user = null;
  }

  Profile.fromJson(Map<String, dynamic> json)
  {
    user = User(json['username'],json['password'],json['objectId']);
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'username': user.username,
        'password': user.password,
        'objectId': user.objectId
      };
}