import 'package:flutter/material.dart';
import 'package:flutter_jdshop/services/EventBus.dart';
import '../../widget/inputWidget.dart';
import '../../widget/BuyButtonWidget.dart';
import '../../services/ScreenAdapter.dart';
import 'package:city_pickers/city_pickers.dart';
import '../../services/UserService.dart';
import '../../services/SignService.dart';
import 'package:dio/dio.dart';
import '../../config/Config.dart';

class AddressEditPage extends StatefulWidget {
  final Map arguments;
  AddressEditPage({Key key,this.arguments}) : super(key: key);
  _AddressEditPageState createState() => _AddressEditPageState();
}

class _AddressEditPageState extends State<AddressEditPage> {
  String _area='';
  bool _flag=false;
  String _name='';
  String _phone='';
  String _address='';
  @override
  void initState() {
    super.initState();
    this._name=widget.arguments['name'];
    this._phone=widget.arguments['phone'];
    this._address=widget.arguments['address'];
  }
  @override
  void dispose() {
    super.dispose();
    if(this._flag){
      eventBus.fire(new AddressEvent('修改收货地址信息成功...'));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text('修改收货地址'),
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
              this._address=value;
            },
          ),
          SizedBox(height: 10,),
          BuyButton(
            text: '修改',
            color: Colors.red,
            cb: ()async{
              List userInfo=await UserService.getUserInfo();
              var tempJson={
                'uid':'${userInfo[0]['_id']}',
                'id':widget.arguments['id'],
                'name':this._name,  
                'phone':this._phone,
                'address':this._address,
                'salt':'${userInfo[0]['salt']}'
              };
              var sign=SignService.getSign(tempJson);
              var api='${Config.domain}api/editAddress';
              var result=await Dio().post(api,data: {
                'uid':'${userInfo[0]['_id']}',
                'id':widget.arguments['id'],
                'name':this._name,  
                'phone':this._phone,
                'address':this._address,
                'sign':sign
              });
              this._flag=result.data['success'];
              if(this._flag){
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
    );
  }
}
