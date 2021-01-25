import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../cart/CartNum.dart';
import '../services/ScreenAdapter.dart';
import 'package:provider/provider.dart';
import '../provider/CartProvider.dart';

class CartItem extends StatefulWidget {
  final Map _itemData;
  CartItem(this._itemData,{Key key}):super(key:key);
  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  Map _itemData;
  @override
  void initState() {
    super.initState();
    //this._itemData=widget._itemData;//涉及Provider状态改变时，赋值放到build里,因为initState不会执行
  }
  @override
  Widget build(BuildContext context) {
    this._itemData=widget._itemData;
    var cartProvider=Provider.of<CartProvider>(context);
    ScreenAdapter.init(context);
    return Container(
      height: ScreenAdapter.height(220),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black12
          )
        )
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenAdapter.width(80),
            child: Checkbox(
              value: this._itemData['checked'],
              onChanged: (value){
                setState(() {
                  this._itemData['checked']=!this._itemData['checked'];
                });
                cartProvider.changeItemChecked();              
              },
              activeColor: Colors.pink,
            ),
          ),
          Container(
            width: ScreenAdapter.width(160),
            child: Image.network(
              '${this._itemData['pic']}',
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
                    '${this._itemData['title']}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                    ),
                    maxLines: 2,
                  ),
                  Text(
                    '${this._itemData['selectedAttr']}',
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
                          '￥${this._itemData['price']}',
                          style: TextStyle(
                            color: Colors.red
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: CartNum(this._itemData),
                      )
                    ],
                  )
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}
