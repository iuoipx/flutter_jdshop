import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../services/ScreenAdapter.dart';
import '../widget/inputWidget.dart';
import '../widget/BuyButtonWidget.dart';
import '../config/Config.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';   //定时器
import '../services/Storage.dart';
import 'dart:convert';
import '../tabs/BottomTab.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _tel='';             //用户输入的手机号
  bool _setCodeBtn=true;      //发送验证码后改变-发送按钮 
  int _second=10;             //倒计时 过60秒重新发送
  String _code='';            //用户输入的验证码
  String _password='';        //用户输入的密码
  bool _registerBtn=false;     //当手机号正确时才能点击注册按钮

  //发送验证码
  sentCode() async{
    RegExp regExp=RegExp(r"^1\d{10}$");
    if(regExp.hasMatch(_tel)){
      setState(() {
        this._setCodeBtn=false;
      });
      var api='${Config.domain}api/sendCode';
      var response=await Dio().post(api,data:{'tel':this._tel});
      if(response.data['success']){
        print(response.data);
        this.showTimer();
        Fluttertoast.showToast(
          msg: "${response.data['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 14.0
        );
        this._registerBtn=true;
      }else{
        this.showTimer();
        Fluttertoast.showToast(
          msg: "${response.data['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0
        );
        this._registerBtn=true;
      }
    }else{
      Fluttertoast.showToast(
        msg: "请输入正确的手机号",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 14.0
      );
    }
  }

  //验证验证码
  validataCode() async{
    var api='${Config.domain}api/validataCode';
    var response=await Dio().post(api,data:{'tel':this._tel,'code':this._code});
    if(response.data['success']){
      Fluttertoast.showToast(
        msg: "${response.data['message']}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }else{
      Fluttertoast.showToast(
        msg: "验证码错误",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
  }

  //注册
  doRegister() async{
    var api='${Config.domain}api/register';
    var response=await Dio().post(api,data:{'tel':this._tel,'code':this._code,'password':this._password});
    if(response.data['success']){
      //print(response.data['userinfo']);
      Fluttertoast.showToast(
        msg: "${response.data['message']}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0
      );
      //保存用户信息  返回根
      Storage.setString('userInfo', json.encode(response.data["userinfo"]));
      //Navigator.of(context).pop();
      Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) => BottomTab(index: 3,)),
        (route) => route == null);
    }else{
      Fluttertoast.showToast(
        msg: "注册失败",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
  }

  Timer t;
  showTimer(){
    t=Timer.periodic(Duration(milliseconds: 1000), (timer){
      setState(() {
        this._second--;
      });
      if(this._second==0){
        t.cancel();  //清除定时器
        this._second=10;
        setState(() {
          this._setCodeBtn=true;          
        });
      }
    });
  }

  @override
  void dispose() { 
    super.dispose();
    if(this._second!=10){
      t.cancel();
    }
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
          '注册',
          style: TextStyle(
            color: Colors.black
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          SizedBox(
            height: ScreenAdapter.height(60),
          ),
          Center(
            child: Text(
              '开启你的账号',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: ScreenAdapter.size(60)
              ),
            ),
          ),
          SizedBox(
            height: ScreenAdapter.height(40),
          ),
          InputWidget(
            text: '请输入手机号',
            icon: Icon(Icons.phone_android),
            onChanged: (value){
              this._tel=value;
            },
          ),
          SizedBox(
            height: ScreenAdapter.height(20),
          ),
          Stack(
            children: <Widget>[
              InputWidget(
                text: '请输入验证码',
                icon: Icon(Icons.vpn_key),
                onChanged: (value){
                  this._code=value;
                },
              ),
              Positioned(
                top: 0,
                right: 0,
                child: this._setCodeBtn
                  ?RaisedButton(
                    color: Colors.red,
                    textColor: Colors.white,
                    onPressed: (){
                      sentCode();
                    },
                    child: Text(
                      '获取验证码',
                      style: TextStyle(
                        fontSize: ScreenAdapter.size(28)
                      ),
                    ),
                  )
                  :RaisedButton(
                    color: Colors.red[200],
                    textColor: Colors.white,
                    onPressed: (){
                        
                    },
                    child: Text(
                      '${this._second}秒后重新发送',
                      style: TextStyle(
                        fontSize: ScreenAdapter.size(24)
                      ),
                    ),
                  )
              )
            ],
          ),
          SizedBox(
            height: ScreenAdapter.height(20),
          ),
          InputWidget(
            text: '请输入密码',
            password: true,
            icon: Icon(Icons.lock),
            onChanged: (value){
              this._password=value;
            },
          ),
          SizedBox(
            height: ScreenAdapter.height(40),
          ),
          this._registerBtn
            ?BuyButton(
              text: '注册',
              color: Colors.redAccent,
              cb: () {
                this.doRegister();
              },
            )
            :BuyButton(
              text: '注册',
              color: Colors.redAccent[100],
              cb: () {
                Fluttertoast.showToast(
                  msg: "请输入正确的手机号",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.black87,
                  textColor: Colors.white,
                  fontSize: 14.0
                );
              },
            )
        ],
      ),
    );
  }
}