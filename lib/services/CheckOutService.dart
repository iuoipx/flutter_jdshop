import 'dart:convert';
import 'Storage.dart';

class CheckOutService{
  static getAllPrice(checkOutData){
    var tempAllPrice=0.0;
    for(var i=0;i<checkOutData.length;i++){
      if(checkOutData[i]['checked']){
        tempAllPrice+=checkOutData[i]['price']*checkOutData[i]['count'];
      }
    }
    return tempAllPrice;
  }

  static removeUnSelectedItem()async{
    List _cartList=[];
    //获取购物车数据
    try{
      List cartListData=json.decode(await Storage.getString('cartList'));
      _cartList=cartListData;
    }catch(e){
      _cartList=[];
    }
    List _tempList=[];
    for(var i=0;i<_cartList.length;i++){
      if(_cartList[i]['checked']==false){
        _tempList.add(_cartList[i]);
      }
    }
    //保存到本地存储
    Storage.setString('cartList', json.encode(_tempList));
  }
}