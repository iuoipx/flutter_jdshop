import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';
import '../services/UserService.dart';
import '../widget/BuyButtonWidget.dart';
import 'package:flutter/services.dart';
import '../services/EventBus.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  bool isLogin=false;
  List userInfo=[];

  _getUserInfo() async{
    var isLogin=await UserService.gerUserLoginState();
    var userInfo=await UserService.getUserInfo();
    setState(() {
      this.userInfo=userInfo;
      this.isLogin=isLogin;
    });
  }

  @override
  void initState() {
    super.initState();
    this._getUserInfo();
    //监听登录界面改变事件
    eventBus.on<UserEvent>().listen((event){
      this._getUserInfo();   //监听广播后重新获取用户信息
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,  //当从注册页面跳回时，用户页面状态栏颜色被改成黑色，手动改为白色
      child: Scaffold(
        body: ListView(
          padding: new EdgeInsets.all(0.0),    //图片跟状态栏一体
          children: <Widget>[
            Container(
              height: ScreenAdapter.height(240),
              padding: EdgeInsets.only(top: ScreenAdapter.height(20)),
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'images/user_bg.jpg',
                  ),
                  fit: BoxFit.cover
                )
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ClipOval(
                      child: Image.asset(
                        'images/user.png',
                        fit: BoxFit.cover,
                        width: ScreenAdapter.width(120),
                        height: ScreenAdapter.height(120),
                      ),
                    ),
                  ),
                  !this.isLogin
                  ?Expanded(
                    flex: 1,
                    child:GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        '登录/注册',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    )
                  )
                  :Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${this.userInfo[0]['username']}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenAdapter.size(36)
                          ),
                        ),
                        Text(
                          '普通会员',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenAdapter.size(24)
                          ),
                        )
                      ],
                    )
                  )
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.assessment,color: Colors.red,),
              title: Text('全部订单'),
              onTap: (){
                Navigator.pushNamed(context, '/order');
              },
            ),
            Divider(
              height: 0,
            ),
            ListTile(
              leading: Icon(Icons.payment,color: Colors.green,),
              title: Text('待付款'),
            ),
            Divider(
              height: 0,
            ),
            ListTile(
              leading: Icon(Icons.local_car_wash,color: Colors.orange,),
              title: Text('待收货'),
            ),
            Container(
              height: 10,
              color: Color.fromRGBO(242, 242, 242, 0.9),
            ),
            ListTile(
              leading: Icon(Icons.favorite,color: Colors.lightGreen,),
              title: Text('我的收藏'),
            ),
            Divider(
              height: 0,
            ),
            ListTile(
              leading: Icon(Icons.people,color: Colors.black54,),
              title: Text('在线客服'),
            ),
            Divider(
              height: 0,
            ),
            SizedBox(
              height: ScreenAdapter.height(40),
            ),
            isLogin
              ?BuyButton(
                text: "退出登录",
                color: Colors.redAccent,
                cb: (){
                  UserService.logoutOut();
                  this._getUserInfo();
                  },
                )
              :Container(
                width: 0,
                height: 0,
              )
          ],
        ),
      )
    );
  }
}