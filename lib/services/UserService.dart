import 'Storage.dart';
import 'dart:convert';

class UserService{

  static getUserInfo() async{
    List userinfo;
    try{
      List userInfoData=json.decode(await Storage.getString('userInfo'));
      userinfo=userInfoData;
    }catch(e){
      userinfo=[];
    }
    return userinfo;
  }

  static gerUserLoginState() async{
    List userInfo=await UserService.getUserInfo();
    if(userInfo.length>0 && userInfo[0]['username']!=''){
      return true;
    }
    return false;
  }

  static logoutOut(){
    Storage.remove('userInfo');
  }
}