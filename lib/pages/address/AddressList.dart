import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../services/ScreenAdapter.dart';
import '../../services/UserService.dart';
import '../../config/Config.dart';
import '../../services/SignService.dart';
import 'package:dio/dio.dart';
import '../../services/EventBus.dart';

class AddressListPage extends StatefulWidget {
  AddressListPage({Key key}) : super(key: key);

  _AddressListPageState createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {

  List _addressList=[];
  bool _flag=false;
  bool _flag1=false;

  @override
  void initState() {
    super.initState();
    this._getAddressList();
    //监听增加收货地址的广播
    eventBus.on<AddressEvent>().listen((event){
      this._getAddressList();
    });
  }

  @override
  void dispose() {
    super.dispose();
    //添加收货地址页面销毁给AddressList发送广播
    eventBus.fire(new CheckOutEvent('修改默认收货地址成功...'));
  }
  
  //获取收货地址列表
  _getAddressList()async{
    List userInfo=await UserService.getUserInfo();
    var tempJson={
      'uid':'${userInfo[0]['_id']}',
      'salt':'${userInfo[0]['salt']}'
    };
    var sign=SignService.getSign(tempJson);
    var api='${Config.domain}api/addressList?uid=${userInfo[0]['_id']}&sign=${sign+''}';
    var result=await Dio().get(api);
    //print(result.data['result']);
    if(mounted){          //调用setState()前判断当前页面是否存在防止内存泄露
      setState(() {       //报错setState() called after dispose()
        this._addressList=result.data['result'];
      });
    }
  }

  //修改默认收货地址
  _changeDefaultAddress(id) async{
    List userInfo=await UserService.getUserInfo();
    var tempJson={
      'uid':'${userInfo[0]['_id']}',
      'id':id,
      'salt':'${userInfo[0]['salt']}'
    };
    var sign=SignService.getSign(tempJson);
    var api='${Config.domain}api/changeDefaultAddress';
    var result=await Dio().post(api,data: {
      'uid':'${userInfo[0]['_id']}',
      'id':id,
      'sign':sign
    });
    //print(result.data['result']);
    this._flag=result.data['success'];
    if(this._flag){
      Navigator.of(context).pop();
    } 
  }

  //删除收货地址
  _delAddress(id)async{
    List userInfo=await UserService.getUserInfo();
      var tempJson={
        'uid':'${userInfo[0]['_id']}',
        'id':id,
        'salt':'${userInfo[0]['salt']}'
      };
      var sign=SignService.getSign(tempJson);
      var api='${Config.domain}api/deleteAddress';
      var result=await Dio().post(api,data: {
        'uid':'${userInfo[0]['_id']}',
        'id':id,
        'sign':sign
      });
      this._flag1=result.data['success'];
      if(this._flag1){
        this._getAddressList();
      }
    }

    //弹出框
  _alertDialog(id) async{
      var result=await showDialog(
        barrierDismissible:true,  //表示点击灰色背景是否取消弹出框
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("提示信息"),
            content: Text("您确定删除吗"),
            elevation: 20,
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                  Navigator.of(context).pop("cancel");
                },
                child: Text("取消"),
              ),
              FlatButton(
                onPressed: () async{
                  //删除
                  _delAddress(id);
                  Navigator.of(context).pop("ok");
                },
                child: Text("确定"),
              ),
            ],
          );
        }
      );
      print(result);
    }

  
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('收货地址列表'),
        elevation: 0,
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            ListView.builder(
              itemCount: this._addressList.length,
              itemBuilder: (context,index){
                return Column(
                  children: <Widget>[
                    this._addressList[index]['default_address']==1
                      ?ListTile(
                        leading: Icon(
                          Icons.check,
                          color: Colors.red,
                        ),
                        title: InkWell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('${this._addressList[index]['name']} ${this._addressList[index]['phone']}'),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '${this._addressList[index]['address']}',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                          onTap: (){
                            this._changeDefaultAddress(this._addressList[index]['_id']);
                          },
                          onLongPress: (){
                            this._alertDialog(this._addressList[index]['_id']);
                          },
                        ),
                        trailing: IconButton(
                          icon:Icon(Icons.edit),
                          color: Colors.blue,
                          onPressed: (){
                            Navigator.pushNamed(
                              context, '/addressEdit',
                              arguments: {
                                'id':this._addressList[index]['_id'],
                                'name':this._addressList[index]['name'],
                                'phone':this._addressList[index]['phone'],
                                'address':this._addressList[index]['address'],
                              }
                            );
                          },
                        ), 
                      )
                      :ListTile(
                        title: Container(
                          //width: ScreenAdapter.width(600),
                          child: InkWell(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('${this._addressList[index]['name']} ${this._addressList[index]['phone']}'),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${this._addressList[index]['address']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                            onTap: (){
                              this._changeDefaultAddress(this._addressList[index]['_id']);
                            },
                            onLongPress: (){
                              this._alertDialog(this._addressList[index]['_id']);
                            },
                          ),
                        ),
                        trailing: IconButton(
                          icon:Icon(Icons.edit),
                          color: Colors.blue,
                          onPressed: (){
                            Navigator.pushNamed(
                              context, '/addressEdit',
                              arguments: {
                                'id':this._addressList[index]['_id'],
                                'name':this._addressList[index]['name'],
                                'phone':this._addressList[index]['phone'],
                                'address':this._addressList[index]['address'],
                              }
                            );
                          },
                        ), 
                      ),
                      Divider(),
                  ],
                );
              },
            ),
            Positioned(
              bottom: 0,
              width: ScreenAdapter.width(750),
              height: ScreenAdapter.height(100),
              child: Container(
                width: ScreenAdapter.width(750),
                height: ScreenAdapter.height(100),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.red,
                  border: Border(
                    top: BorderSide(
                      color: Colors.black26,
                      width: 1
                    )
                  )
                ),
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      Text(
                        '新增收货地址',
                        style: TextStyle(
                          color: Colors.white
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, '/addressAdd');
                  },
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}