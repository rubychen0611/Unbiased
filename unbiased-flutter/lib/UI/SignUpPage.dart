import 'package:flutter/material.dart';
import 'package:unbiased/Common/MyIcons.dart';
import 'package:unbiased/DataModel/Profile.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:provider/provider.dart';
import 'package:unbiased/Common/State.dart';
import 'package:fluttertoast/fluttertoast.dart';


/**
 * 注册界面
 */
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  User user = User('', '');
  String temp_passwd = null;
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  FocusNode usernameFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();
  FocusNode passwordConfirmFocusNode = new FocusNode();
  FocusScopeNode focusScopeNode = new FocusScopeNode();

  GlobalKey<FormState> _SignUpFormKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: EdgeInsets.only(top: 23),
        child: new Column(
          children: <Widget>[
            // 输入框
            new Container(
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.white,),
                width: 300,
                height: 240,
                child: buildSignUpTextForm()
            ),

            new SizedBox(
              height: 20,
            ),

            // sign up按钮
            new GestureDetector(
              child: new Container(
                padding: EdgeInsets.only(
                    top: 10, bottom: 10, left: 42, right: 42),
                decoration: new BoxDecoration(
                  color:Colors.teal,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: new Text("Sign Up",
                  style: new TextStyle(fontSize: 25, color: Colors.white),),

              ),
              onTap: () async{
                /**利用key来获取widget的状态FormState
                    可以用过FormState对Form的子孙FromField进行统一的操作
                 */
                if (_SignUpFormKey.currentState.validate()) {
                  //如果输入都检验通过，则进行登录操作
                  _SignUpFormKey.currentState.save();
                  try {
                    // 注册成功
                    LCUser user_obj = LCUser();
                    user_obj.username = this.user.username;
                    user_obj.password = this.user.password;
                    await user_obj.signUp();
                    Provider.of<UserModel>(context, listen: false).user = user;
                    Fluttertoast.showToast(msg:'Sign up successfully.');
                    Navigator.of(context).pop();
                  } on LCException catch (e) {
                    // 登录失败（可能是密码错误）
                    Fluttertoast.showToast(msg:'Failed: ${e.message}');
                  }
                }
              },
            ),

          ],
        )
    );
  }

  Widget buildSignUpTextForm() {
    return new Form(
      key: _SignUpFormKey,
      child: new Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        //用户名字
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 25, right: 25, top: 20, bottom: 20),
            child: new TextFormField(
              focusNode: usernameFocusNode,
              onEditingComplete: () {
                if (focusScopeNode == null) {
                  focusScopeNode = FocusScope.of(context);
                }
                focusScopeNode.requestFocus(passwordFocusNode);
              },
              decoration: new InputDecoration(
                  icon: new Icon(MyIcons.me, color: Colors.black,),
                  hintText: "User Name",
                  border: InputBorder.none
              ),
              style: new TextStyle(fontSize: 16, color: Colors.black),
              validator: (value) {
                if (value.isEmpty) {
                  return "User name can not be empty!";
                }
              },
              onSaved: (value) {
                this.user.username = value;
              },
            ),
          ),
        ),
        new Container(
          height: 1,
          width: 250,
          color: Colors.grey[400],
        ),
        //密码
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 25, right: 25, top: 20, bottom: 20),
            child: new TextFormField(
              focusNode: passwordFocusNode,
              controller:_pass,
              onEditingComplete: () {
                focusScopeNode.requestFocus(passwordConfirmFocusNode);
              },
              decoration: new InputDecoration(
                icon: new Icon(Icons.lock, color: Colors.black,),
                hintText: "Password",
                border: InputBorder.none,
                suffixIcon: new IconButton(
                    icon: new Icon(Icons.remove_red_eye, color: Colors.black,),
                    onPressed: () {}),
              ),
              obscureText: true,
              style: new TextStyle(fontSize: 16, color: Colors.black),
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 6) {
                  return "Password'length must longer than 6!";
                }
              },
              onSaved: (value) {
                this.user.password = value;
              },
            ),
          ),
        ),
        new Container(
          height: 1,
          width: 250,
          color: Colors.grey[400],
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 25, right: 25, top: 20, bottom: 20),
            child: new TextFormField(
              focusNode: passwordConfirmFocusNode,
              controller: _confirmPass,
              decoration: new InputDecoration(
                icon: new Icon(Icons.lock, color: Colors.black,),
                hintText: "Confirm Password",
                border: InputBorder.none,
                suffixIcon: new IconButton(
                    icon: new Icon(Icons.remove_red_eye, color: Colors.black,),
                    onPressed: () {}),
              ),
              obscureText: true,
              style: new TextStyle(fontSize: 16, color: Colors.black),
              validator: (value) {
                if (value == null || value.isEmpty )
                  return "Empty!";
                if (value != _pass.text) {
                  return "Inconsistent password!";
                }
              }
            ),
          ),
        ),

      ],
    )
    );
  }

}