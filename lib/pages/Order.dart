import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';
import '../config/Config.dart';
import 'package:dio/dio.dart';
import '../model/OrderModel.dart';
import '../services/UserService.dart';
import '../services/SignService.dart';

class OrderPage extends StatefulWidget {
  OrderPage({Key key}) : super(key: key);

  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  List _orderList=[];

  _getOrderData() async{
    List userinfo=await UserService.getUserInfo();
    var tempJson={"uid":userinfo[0]['_id'],"salt":userinfo[0]['salt']};
    var sign=await SignService.getSign(tempJson);
    var api="${Config.domain}api/orderList?uid=${userinfo[0]['_id']}&sign=${sign+''}";
    var response=await Dio().get(api);
    setState(() {
      this._orderList=OrderModel.fromJson(response.data).result;
    });
    print(this._orderList[0].name);
  }

  List <Widget> _orderItemWidget(value){
    List <Widget> tempList=[];
    for(var i=0;i<value.length;i++){
      tempList.add(Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Container(
              width: ScreenAdapter.width(80),
              height: ScreenAdapter.height(80),
              child: Image.network(
                '${value[i].productImg}',
                fit: BoxFit.cover,
              ),
            ),
            title: Text('${value[i].productTitle}',style: TextStyle(fontSize: 14),),
            trailing: Text('X${value[i].productCount}'),
          ),
        ],
      ));
    }
    return tempList;
  }

  @override
  void initState() { 
    super.initState();
    _getOrderData();
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('我的订单'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, ScreenAdapter.height(80), 0, 0),
            padding: EdgeInsets.all(ScreenAdapter.width(16)),
            child: ListView(
              children: this._orderList.map((value){
                return Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text('订单编号:${value.sId}',style: TextStyle(color: Colors.black54),),
                      ),
                      Divider(),
                      Column(
                        children: this._orderItemWidget(value.orderItem),
                      ),
                      // ListTile(
                      //   leading: Container(
                      //     width: ScreenAdapter.width(80),
                      //     height: ScreenAdapter.height(80),
                      //     child: Image.network(
                      //       'https://www.itying.com/image/flutter/list2.jpg',
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      //   title: Text('fdsfgsgdff'),
                      //   trailing: Text('X1'),
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: Text('合计:${value.allPrice}'),
                        trailing: FlatButton(
                          child: Text('申请售后'),
                          onPressed: (){

                          },
                          color: Colors.grey[100],
                        ),
                      )
                    ],
                  ),
                );
              }).toList()
            ),
          ),
          Positioned(
            width: ScreenAdapter.width(750),
            height: ScreenAdapter.height(76),
            top: 0,
            child: Container(
              color: Colors.white,
              width: ScreenAdapter.width(750),
              height: ScreenAdapter.height(76),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('全部',textAlign: TextAlign.center,),
                  ),
                  Expanded(
                    child: Text('待付款',textAlign: TextAlign.center,),
                  ),
                  Expanded(
                    child: Text('待收货',textAlign: TextAlign.center,),
                  ),
                  Expanded(
                    child: Text('已完成',textAlign: TextAlign.center,),
                  ),
                  Expanded(
                    child: Text('已取消',textAlign: TextAlign.center,),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}