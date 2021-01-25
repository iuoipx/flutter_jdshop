import 'dart:convert';
import 'package:crypto/crypto.dart';
class SignService{
  static getSign(json){
    var attrKeys=json.keys.toList();
    attrKeys.sort();  //排序  ASCII 字符顺序进行升序排序
    String str='';
    for(var i=0;i<attrKeys.length;i++){
      str+='${attrKeys[i]}${json[attrKeys[i]]}';
    }
    // print(Stream.empty());
    // print(md5.convert(utf8.encode(str)));
    return md5.convert(utf8.encode(str)).toString();
  }
}