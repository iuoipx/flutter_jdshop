import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widget/inputWidget.dart';
import '../../widget/BuyButtonWidget.dart';
import '../../services/ScreenAdapter.dart';
import 'package:city_pickers/city_pickers.dart';
import '../../services/UserService.dart';
import '../../services/SignService.dart';
import 'package:dio/dio.dart';
import '../../config/Config.dart';
import '../../services/EventBus.dart';

class AddressAddPage extends StatefulWidget {
  AddressAddPage({Key key}) : super(key: key);

  _AddressAddPageState createState() => _AddressAddPageState();
}

class _AddressAddPageState extends State<AddressAddPage> {
  String _area='';
  String _name='';
  String _phone='';
  String _address='';
  bool _flag=false;
  @override
  void dispose() {
    super.dispose();
    //添加收货地址页面销毁给AddressList发送广播
    if(this._flag){
      eventBus.fire(new AddressEvent('添加收货地址成功...'));
      eventBus.fire(new CheckOutEvent('修改收货地址成功...'));
    }
  }
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('增加收货地址'),
      ),
      body: ListView(
        padding: EdgeInsets.all(4),
        children: <Widget>[
          SizedBox(height: 10,),
          InputWidget(
            text: '收货人姓名',
            controllerText: this._name,
            onChanged: (value){
              this._name=value;
            },
          ),
          SizedBox(height: 10,),
          InputWidget(
            text: '收货人电话',
            controllerText: this._phone,
            onChanged: (value){
              this._phone=value;
            },
          ),
          SizedBox(height: 10,),
          GestureDetector(
            child:Container(
              height: ScreenAdapter.height(100),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Colors.black38
                  )
                )
              ),
              child: Row(
                children: <Widget>[
                  Icon(Icons.add_location),
                  this._area.length>0
                    ?Text(this._area)
                    :Text(
                      '省/市/区',
                      style: TextStyle(
                        color: Colors.black45
                      ),
                    )
                ],
              ),
            ),
            onTap: ()async{
              Result result = await CityPickers.showCityPicker(
                context: context,
              );
              setState(() {
                this._area=result==null
                  ?''
                  :'${result.provinceName}/${result.cityName}/${result.areaName}';
              });
            },
          ),
          InputWidget(
            text: '详细地址',
            controllerText: this._address,
            maxLines: 3,
            onChanged: (value){
              this._address='${this._area}'+' '+value;
            },
          ),
          SizedBox(height: 10,),
          BuyButton(
            text: '增加',
            color: Colors.red,
            cb: ()async{
              List userInfo=await UserService.getUserInfo();
              //print(userInfo); //[{_id: 5d49356197045b1864d6af83, username: 13636131234, tel: 13636131234, salt: bf4d73f316737b26f1e860da0ea63ec8}]
              var tempJson={
                'uid':'${userInfo[0]['_id']}',
                'name':this._name,  
                'phone':this._phone,
                'address':this._address,
                'salt':'${userInfo[0]['salt']}'
              };
              var sign=SignService.getSign(tempJson);
              //print(sign);  //d0a7d82bd05468f252dfebcc935ad3dd
              var api='${Config.domain}api/addAddress';
              var result=await Dio().post(api,data: {
                'uid':'${userInfo[0]['_id']}',
                'name':this._name,  
                'phone':this._phone,
                'address':this._address,
                'sign':sign
              });
              this._flag=result.data['success'];
              //print(result); //{"success":true,"message":"增加成功"}
              if(this._flag){
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
    );
  }
}
