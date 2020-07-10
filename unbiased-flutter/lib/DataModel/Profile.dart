/* 用户信息 */
class User
{
  String username;
  String password;
  User(this.username, this.password);
}
class Profile {

  User user;
  Profile()
  {
    user = null;
  }

  Profile.fromJson(Map<String, dynamic> json)
  {
    user = User(json['username'],json['password'] );
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'username': user.username,
        'password': user.password,
      };
}