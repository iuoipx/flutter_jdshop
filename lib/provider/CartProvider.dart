import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/Storage.dart';


class CartProvider with ChangeNotifier{
  List _cartList=[];   //购物车数据
  bool _isCheckedAll=false;  //全选checkbox状态
  double _allPrice=0;   //总价
  int _allCount=0;     //总数
  bool get isCheckedAll=>this._isCheckedAll;
  List get cartList=>this._cartList;
  double get allPrice=>this._allPrice;
  int get allCount=>this._allCount;
  CartProvider(){
    this.init();
  }
  init() async{
    try{
      List cartListData=json.decode(await Storage.getString('cartList'));
      this._cartList=cartListData;
    }catch(e){
      this._cartList=[];
    }
    this._isCheckedAll=this.isCheckAll();
    //计算总价
    this.computeAllPrice();
    this.computeAllCount();
    notifyListeners();
  }

  //点击商品页面加入购物车时更新数据
  updateCartList(){
    this.init();
  }

  //在购物车页面修改count之后需要重新保存到本地存储
  changeItemCount(){
    Storage.setString('cartList', json.encode(this._cartList));
    //计算总价
    this.computeAllPrice();
    this.computeAllCount();
    notifyListeners();
  }

  //点击实现全选  反选
  checkAll(value){
    for(var i=0;i<this._cartList.length;i++){
      this._cartList[i]['checked']=value;
    }
    this._isCheckedAll=value;
    //计算总价
    this.computeAllPrice();
    this.computeAllCount();
    //保存到本地存储
    Storage.setString('cartList', json.encode(this._cartList));
    notifyListeners();
  }

  //判断是否全选状态
  bool isCheckAll(){
    if(this._cartList.length>0){
      for(var i=0;i<this._cartList.length;i++){
        if(this._cartList[i]['checked']==false){
          return false;
        }
      }
      return true;
    }else{
      return false;
    }
  }

  //监听每一项checkbox的选中状态
  changeItemChecked(){
    if(this.isCheckAll()){
      this._isCheckedAll=true;
    }else{
      this._isCheckedAll=false;
    }
    //计算总价
    this.computeAllPrice();
    this.computeAllCount();
    //保存到本地存储
    Storage.setString('cartList', json.encode(this._cartList));
    notifyListeners();
  }
  
  //计算总价
  computeAllPrice(){
    double tempPrice=0;
    for(var i=0;i<this._cartList.length;i++){
      if(this._cartList[i]['checked']==true){
        tempPrice+=this._cartList[i]['price']*this._cartList[i]['count'];
      }
    }
    this._allPrice=tempPrice;
    notifyListeners();
  }

  //计算总数量
  computeAllCount(){
    int tempCount=0;
    for(var i=0;i<this._cartList.length;i++){
      if(this._cartList[i]['checked']==true){
        tempCount+=this._cartList[i]['count'];
      }
    }
    this._allCount=tempCount;
    notifyListeners();
  }

  //删除商品数据  
  removeItem(){
    //删除数据后数组下标变化  error
    // for(var i=0;i<this._cartList.length;i++){
    //   if(this._cartList[i]['checked']==true){
    //     this._cartList.removeAt(i);
    //   }
    // }
    List tempList=[];
    for(var i=0;i<this._cartList.length;i++){
      if(this._cartList[i]['checked']==false){
        tempList.add(this._cartList[i]);
      }
    }
    this._cartList=tempList;
    //计算总价
    this.computeAllPrice();
    this.computeAllCount();
    //保存到本地存储
    Storage.setString('cartList', json.encode(this._cartList));
    notifyListeners();
  }

}