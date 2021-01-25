import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../cart/cartItem.dart';
import '../services/ScreenAdapter.dart';
import '../provider/CartProvider.dart';
import 'package:provider/provider.dart';
import '../services/CartService.dart';
import '../provider/CheckOutData.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/UserService.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isEdit=false;

  var checkOutProvider;   //选中商品状态
  //结算
  doCheckOut() async{
    //获取购物车选中的商品数据
    List checkOutData=await CartService.getCheckOutData(); 
    //保存购物车中选中的商品数据
    this.checkOutProvider.changeCheckOutListData(checkOutData);
    //判断购物车有没有选中的数据
    if(checkOutData.length>0){
      //判断用户有没有登录
      bool loginState=await UserService.gerUserLoginState();   //获取 异步方法返回值时 加上await
      if(loginState){
        Navigator.pushNamed(context, '/checkOut');
      }else{
        Fluttertoast.showToast(
          msg: "您还没有登录，请登录以后结算",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 14.0
        );
        Navigator.pushNamed(context, '/login');
      }
    }else{
      Fluttertoast.showToast(
        msg: "购物车没有内容",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 14.0
      );
    }

    //判断用户有没有登录   


  }
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    var cartProvider=Provider.of<CartProvider>(context);
    checkOutProvider=Provider.of<CheckOutData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.launch),
            onPressed: (){
              setState(() {
                this._isEdit=!this._isEdit;
              });
            },
          )
        ],
      ),
      body: cartProvider.cartList.length>0?Stack(
        children: <Widget>[
          ListView(
            children: cartProvider.cartList.map((value){
              return CartItem(value);
            }).toList(),
            padding: EdgeInsets.only(bottom: ScreenAdapter.height(120)),
          ),
          Positioned(
            bottom: 0,
            width: ScreenAdapter.width(750),
            height: ScreenAdapter.height(100),
            child: Container(
              width: ScreenAdapter.width(750),
              height: ScreenAdapter.height(100),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 1,
                    color: Colors.black12
                  )
                ),
                color: Colors.white
              ),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: ScreenAdapter.width(80),
                          child: Checkbox(
                            value: cartProvider.isCheckedAll,
                            onChanged: (value){
                              cartProvider.checkAll(value);
                            },
                            activeColor: Colors.pink,
                          ),
                        ),
                        Text('全选'),
                        SizedBox(width: 10,),
                        this._isEdit==false
                          ?Text('合计:')
                          :Text(''),
                        this._isEdit==false
                          ?Text(
                            '${cartProvider.allPrice}',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18
                            ),        
                          )
                          :Text(''),
                      ],
                    ),
                  ),
                  this._isEdit==false
                    ?Align(
                      alignment: Alignment.centerRight,
                      child:RaisedButton(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '去结算',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16
                                )
                              ),
                              TextSpan(
                                text: '(共${cartProvider.allCount}件)',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10
                                )
                              )
                            ]
                          ),
                        ),
                        color: Colors.red,
                        onPressed: doCheckOut,
                      )
                    )
                    :Align(
                      alignment: Alignment.centerRight,
                      child:RaisedButton(
                        child: Text(
                          '删除',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                        color: Colors.red,
                        onPressed: (){
                          cartProvider.removeItem();
                        },
                      )
                    )
                ],
              ),
            ),
          ),
        ],
      ):Center(
        child: Text('购物车为空...'),
      )
    );
  }
}
