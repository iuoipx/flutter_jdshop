import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';
import '../provider/CheckOutData.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import '../config/Config.dart';
import '../services/UserService.dart';
import '../services/SignService.dart';
import '../services/EventBus.dart';
import '../services/CheckOutService.dart';
import '../provider/CartProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckOutPage extends StatefulWidget {
  CheckOutPage({Key key}) : super(key: key);

  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  List _addressList=[];
  @override
  void initState() {
    super.initState();
    this._getDefaultAddress();
    //监听切换默认地址的广播
    eventBus.on<CheckOutEvent>().listen((event){
      print(event.str);
      this._getDefaultAddress();
    });
  }

  _getDefaultAddress() async{
    List userInfo=await UserService.getUserInfo();
    var tempJson={
      'uid':'${userInfo[0]['_id']}',
      'salt':'${userInfo[0]['salt']}'
    };
    var sign=SignService.getSign(tempJson);
    var api='${Config.domain}api/oneAddressList?uid=${userInfo[0]['_id']}&sign=${sign+''}';
    var result=await Dio().get(api);
    //print(result.data['result']);
    setState(() {
      this._addressList=result.data['result'];
    });
  }

  Widget _checkOutItem(value){
    return Row(
      children: <Widget>[
        Container(
          width: ScreenAdapter.width(160),
          child: Image.network(
            '${value['pic']}',
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${value['title']}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold
                  ),
                  maxLines: 2,
                ),
                Text(
                  '${value['selectedAttr']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black87
                  ),
                  maxLines: 2,
                ),
                Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '￥${value['price']}',
                        style: TextStyle(
                          color: Colors.red
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'x${value['count']}',
                        style: TextStyle(
                          color: Colors.black
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    var checkOutProvider=Provider.of<CheckOutData>(context);
    var cartProvider=Provider.of<CartProvider>(context);
    List checkOutList=checkOutProvider.checkOutList;
    return Scaffold(
      appBar: AppBar(
        title: Text('订单页面'),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.only(bottom: ScreenAdapter.height(100)),
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Colors.black12
                    )
                  )
                ),
                child: Column(
                  children: <Widget>[
                    this._addressList.length>0
                      ?ListTile(
                        title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('${this._addressList[0]['name']} ${this._addressList[0]['phone']}'),
                              SizedBox(
                                height: ScreenAdapter.height(10),
                              ),
                              Text('${this._addressList[0]['address']}')
                            ],
                          ),
                        trailing: Icon(Icons.navigate_next),
                        onTap: (){
                          Navigator.pushNamed(context, '/addressList');
                        },
                      )
                      :ListTile(
                        leading: Icon(Icons.add_location),
                        title: Center(
                          child: Text('请添加收货地址'),
                        ),
                        trailing: Icon(Icons.navigate_next),
                        onTap: (){
                          Navigator.pushNamed(context, '/addressAdd');
                        },
                      )

                  ],
                ),
              ),
              SizedBox(
                height: ScreenAdapter.height(40),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Column(
                  children: checkOutProvider.checkOutList.map((value){
                    return Column(
                      children: <Widget>[
                        _checkOutItem(value),
                        Divider()
                      ],
                    );
                  }).toList()
                ),
              ),
              SizedBox(
                height: ScreenAdapter.height(40),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Text('商品总金额:')
                  ],
                ),
              )
            ],
          ),
          Positioned(
            bottom: 0,
            width: ScreenAdapter.width(750),
            height: ScreenAdapter.height(100),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 1,
                    color: Colors.black12
                  )
                ),
                color: Colors.white
              ),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        Text('总价')
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RaisedButton(
                      child: Text(
                        '立即下单',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                      color: Colors.red,
                      onPressed: ()async{
                        if(this._addressList.length>0){
                          //print(checkOutList);
                          //1.获取用户信息
                          List userInfo=await UserService.getUserInfo();
                          //2.计算总价
                          var allPrice=CheckOutService.getAllPrice(checkOutList).toStringAsFixed(1);
                          //3.生成签名
                          var sign=SignService.getSign({
                            'uid':userInfo[0]['_id'],
                            'phone':this._addressList[0]['phone'],
                            'address':this._addressList[0]['address'],
                            'name':this._addressList[0]['name'],
                            'all_price':allPrice,
                            'products':json.encode(checkOutList),//转成json字符串
                            'salt':userInfo[0]['salt'] //私钥
                          });
                          //4.请求接口
                          var api='${Config.domain}api/doOrder';
                          var response=await Dio().post(api,data: {
                            'uid':userInfo[0]['_id'],
                            'phone':this._addressList[0]['phone'],
                            'address':this._addressList[0]['address'],
                            'name':this._addressList[0]['name'],
                            'all_price':allPrice,
                            'products':json.encode(checkOutList),//转成json字符串
                            'sign':sign  //生成的签名
                          });
                          if(response.data['success']){
                            //print(response.data['success']);
                            //删除购物车选中的商品
                            //   -------- 删除商品是异步方法 加上await等待删除成功后在更新数据----------
                            await CheckOutService.removeUnSelectedItem();
                            //调用cartProvider更新数据
                            cartProvider.updateCartList();
                            Navigator.pushNamed(context, '/pay');
                          }
                        }else{
                          Fluttertoast.showToast(
                            msg: "请填写收货地址",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            )
          )
        ],
      )
    );
  }
}