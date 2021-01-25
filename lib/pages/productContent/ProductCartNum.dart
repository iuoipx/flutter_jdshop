import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../services/ScreenAdapter.dart';
import '../../model/ProductContentModel.dart';

class ProductCartNum extends StatefulWidget {
  final ProductContentItem _productContent;
  ProductCartNum(this._productContent,{Key key}):super(key:key);
  @override
  _ProductCartNumState createState() => _ProductCartNumState();
}

class _ProductCartNumState extends State<ProductCartNum> {
  ProductContentItem _productContent;
  @override
  void initState() { 
    super.initState();
    this._productContent=widget._productContent;
  }
  //左侧按钮
  Widget _leftButton(){
    return InkWell(
      onTap: (){
        if(this._productContent.count>1){
          setState(() {
            this._productContent.count--;
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
          this._productContent.count++;
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

  //按钮
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
      child: Text('${this._productContent.count}'),
    );
  }
  @override
  Widget build(BuildContext context) {
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