import 'package:flutter/material.dart';
import '../tabs/BottomTab.dart';
import '../pages/ProductList.dart';
import '../pages/SearchPage.dart';
import '../pages/productContent/ProductContent.dart';
import '../tabs/Cart.dart';
import '../pages/LoginPage.dart';
import '../pages/RegisterPage.dart';
import '../pages/CheckOut.dart';
import '../pages/address/AddressList.dart';
import '../pages/address/AddressAdd.dart';
import '../pages/address/AddressEdit.dart';
import '../pages/PayPage.dart';
import '../pages/Order.dart';
import '../pages/OrderInfo.dart';

final Map routes={
  '/':(context)=>BottomTab(),
  '/search':(context)=>SearchPage(),
  '/productList':(context,{arguments})=>ProductListPage(arguments: arguments,),
  '/productContent':(context,{arguments})=>ProductContentPage(arguments: arguments,),
  '/cart':(context)=>CartPage(),
  '/login':(context)=>LoginPage(),
  '/register':(context)=>RegisterPage(),
  '/checkOut':(context)=>CheckOutPage(),
  '/addressList':(context)=>AddressListPage(),
  '/addressAdd':(context)=>AddressAddPage(),
  '/addressEdit':(context,{arguments})=>AddressEditPage(arguments: arguments,),
  '/pay':(context)=>PayPage(),
  '/order':(context)=>OrderPage(),
  '/orderInfo':(context)=>OrderInfo(),
};  

var onGenerateRoute=(RouteSettings settings){
  final String name=settings.name;
  final Function pageContentBuilder=routes[name]; //把routes[name](即路由widget)传给pageContentBuilder
  if(pageContentBuilder!=null){
    if(settings.arguments!=null){
      final Route route=MaterialPageRoute(
        builder: (context)=>pageContentBuilder(context,arguments:settings.arguments)
      );
      return route;
    }else{
      final Route route=MaterialPageRoute(
        builder: (context)=>pageContentBuilder(context)
      );
      return route;
    }
  }
};