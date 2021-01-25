import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';
import '../widget/inputWidget.dart';
import '../widget/BuyButtonWidget.dart';
import '../Config/Config.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import '../services/Storage.dart';
import '../services/EventBus.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String userName='';
  String passWord='';
  doLogin() async{
    RegExp regExp=RegExp(r"^1\d{10}$");
    if(!regExp.hasMatch(this.userName)){
      Fluttertoast.showToast(
          msg: "手机号格式不正确",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 14.0
        );
    }else if(this.passWord.length<6){
      Fluttertoast.showToast(
        msg: "密码不正确",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 14.0
      );
    }else{
      var api='${Config.domain}api/doLogin';
      var response=await Dio().post(api,data:{'username':this.userName,'password':this.passWord});
      if(response.data['success']){
        //保存用户信息
        Storage.setString('userInfo', json.encode(response.data["userinfo"]));
        Navigator.of(context).pop();
      }else{
        Fluttertoast.showToast(
          msg: "${response.data['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 14.0
        );
      }
    }
  }

  //登录页面销毁时,更新用户页面
  @override
  void dispose() {
    super.dispose();
    eventBus.fire(UserEvent('登录成功.....'));
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,     //白色appbar,红色主题情况下状态栏颜色也是白色
        brightness: Brightness.light,      //把状态栏字体颜色改为黑色
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          '登录',
          style: TextStyle(
            color: Colors.black
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: (){

            },
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Center(
                child: Text(
                  '客服',
                  style: TextStyle(
                    color: Colors.black
                  ),
                ),
              ),
            )
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(ScreenAdapter.width(24)),
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.only(top: ScreenAdapter.height(60)),
              width: ScreenAdapter.width(160),
              height: ScreenAdapter.height(160),
              child: Image.asset('images/ic_launcher.png',fit: BoxFit.cover,),
            ),
          ),
          SizedBox(
            height: ScreenAdapter.height(20),
          ),
          InputWidget(
            text:'请输入用户名',
            icon: Icon(Icons.people),
            onChanged: (value){
              this.userName=value;
            },
          ),
          SizedBox(
            height: ScreenAdapter.height(20),
          ),
          InputWidget(
            text:'请输入密码',
            icon: Icon(Icons.lock),
            password: true,
            onChanged: (value){
              this.passWord=value;
            },
          ),
          SizedBox(
            height: ScreenAdapter.height(20),
          ),
          Container(
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '忘记密码',
                    style: TextStyle(
                      color: Colors.black45
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: ScreenAdapter.height(50),
          ),
          BuyButton(
            text: '登录',
            color: Colors.redAccent,
            cb: (){
              doLogin();
            },
          ),
          SizedBox(
            height: ScreenAdapter.height(60),
          ),
          Center(
            child: GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, '/register');
              },
              child: Text(
                '还没账号？快去注册',
                style: TextStyle(
                  color: Colors.blue[300]
                ),
              ),
            )
          )
        ]
      ),
    );
  }
}