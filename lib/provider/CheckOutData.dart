import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckOutData with ChangeNotifier{
  List _chekOutList=[];   //购物车数据
  List get checkOutList=>this._chekOutList;

  changeCheckOutListData(data){
    this._chekOutList=data;
    notifyListeners();
  }
}