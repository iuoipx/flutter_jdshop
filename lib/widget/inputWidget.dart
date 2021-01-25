import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';

class InputWidget extends StatelessWidget {
  final String text;
  final bool password;
  final Icon icon;
  final Object onChanged;
  final int maxLines;
  final String controllerText;
  InputWidget({Key key,this.text='输入内容',this.icon,this.password=false,this.onChanged,this.maxLines=1,this.controllerText=''}):super(key:key);
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return TextField(
      controller: TextEditingController.fromValue(
        TextEditingValue(
          // 设置内容
          text: controllerText,
          // 保持光标在最后
          selection: TextSelection.fromPosition(
            TextPosition(
              affinity: TextAffinity.downstream,
              offset: controllerText.length
            )
          )
        )
      ),
      maxLines: this.maxLines,
      obscureText: this.password,
      decoration: InputDecoration(
        hintText: this.text,
        prefixIcon : this.icon
      ),
      onChanged: this.onChanged
    );
  }
}