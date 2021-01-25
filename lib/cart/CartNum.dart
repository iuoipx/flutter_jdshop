import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../services/ScreenAdapter.dart';
import '../provider/CartProvider.dart';

class CartNum extends StatefulWidget {
  final Map _itemData;
  CartNum(this._itemData,{Key key}):super(key:key);
  @override
  _CartNumState createState() => _CartNumState();
}

class _CartNumState extends State<CartNum> {
  Map _itemData;

  var cartProvider;
  @override
  void initState() { 
    super.initState();
    //this._itemData=widget._itemData;  //涉及Provider状态改变时，赋值放到build里,因为initState不会执行
  }
  //左侧按钮
  Widget _leftButton(){
    return InkWell(
      onTap: (){
        if(this._itemData['count']>1){
          setState(() {
            this._itemData['count']--;
            this.cartProvider.changeItemCount();
          });
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: ScreenAdapter.width(50),
        height: ScreenAdapter.height(50),
        child: Text('-'),
      ),
    );
  }

  //右侧按钮
  Widget _rightButton(){
    return InkWell(
      onTap: (){
        setState(() {
          this._itemData['count']++;
          this.cartProvider.changeItemCount();
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: ScreenAdapter.width(50),
        height: ScreenAdapter.height(50),
        child: Text('+'),
      ),
    );
  }

  //数字
  Widget _centerArea(){
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: ScreenAdapter.width(2),
            color: Colors.black12
          ),
          right: BorderSide(
            width: ScreenAdapter.width(2),
            color: Colors.black12
          ),
        )
      ),
      width: ScreenAdapter.width(80),
      height: ScreenAdapter.height(50),
      child: Text('${this._itemData['count']}'),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    this._itemData=widget._itemData;
    this.cartProvider=Provider.of<CartProvider>(context);
    ScreenAdapter.init(context);
    return Container(
      width: ScreenAdapter.width(188),
      decoration: BoxDecoration(
        border: Border.all(
          width: ScreenAdapter.width(2),
          color: Colors.black12
        )
      ),
      child: Row(
        children: <Widget>[
          _leftButton(),
          _centerArea(),
          _rightButton()
        ],
      ),
    );
  }
}