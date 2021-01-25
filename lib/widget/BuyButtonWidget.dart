import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';

class BuyButton extends StatelessWidget {
  final Color color;
  final String text;
  final Object cb;
  BuyButton({Key key,this.color=Colors.black,this.text='按钮',this.cb}):super(key:key);
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return InkWell(
      onTap: this.cb,
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        height: ScreenAdapter.height(80),
        decoration: BoxDecoration(
          color: this.color,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Center(
          child: Text('${this.text}',style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}