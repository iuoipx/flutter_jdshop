import 'package:flutter/material.dart';

class BottomBorderContainer extends StatelessWidget {
  final String _text;
  final double _borderWidth;
  final _taped;
  BottomBorderContainer(this._text,this._taped,[this._borderWidth=0]);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: double.infinity,
        height: 50,
        child: Center(
          child: Text("${this._text}"),
        ),
        decoration: UnderlineTabIndicator(
          borderSide: BorderSide(width: this._borderWidth, color: Colors.black12),
          //insets: EdgeInsets.fromLTRB(0, 2, 0, 2)
        ),
      ),
      onTap: this._taped,
    );
  }
}