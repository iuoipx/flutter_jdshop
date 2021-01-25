import 'dart:convert';
import 'Storage.dart';
import '../config/Config.dart';

class CartService{

  //加入购物车
  static addCart(item) async{
    //把对象转换成Map类型的数据
    item=CartService.formatCartData(item);

    try{
      List cartListData=json.decode(await Storage.getString('cartList'));   //获取本地存储数据并判断本地存储是否有数据，没有数据执行catch
      bool hasData=cartListData.any((value){     //判断购物车有没有当前数据
        if(value['_id']==item['_id']&&value['selectedAttr']==item['selectedAttr']){
          return true;
        }
        return false;
      });
      if(hasData){
        for(var i=0;i<cartListData.length;i++){
          if(cartListData[i]['_id']==item['_id']&&cartListData[i]['selectedAttr']==item['selectedAttr']){
            cartListData[i]['count']++;
          }
        }
        await Storage.setString('cartList', json.encode(cartListData));
      }else{
        cartListData.add(item);
        await Storage.setString('cartList', json.encode(cartListData));
      }
    }catch(e){     //本地存储没有数据时,把当前数据存到本地存储里
      List tempList=[];
      tempList.add(item);
      await Storage.setString('cartList', json.encode(tempList));
    }
  }

  //过滤数据
  static formatCartData(item){
    String pic=item.pic;
    pic=Config.domain+pic.replaceAll('\\', '/');

    final Map data=new Map();
    data['_id']=item.sId;
    data['title']=item.title;
    //处理价格数据类型
    if(item.price is int || item.price is double){
      data['price']=item.price;
    }else{
      data['price']=double.parse(item.price);
    }
    data['selectedAttr']=item.selectedAttr;
    data['count']=item.count;
    data['pic']=pic;
    data['checked']=true;
    return data;
  }

  //获取购物车中选中的商品数据

  static getCheckOutData() async{
    List cartListData=[];       //购物车所有商品
    List tempCheckOutData=[];   //选中商品数据
    try{
      cartListData=json.decode(await Storage.getString('cartList'));
    }catch(e){
      cartListData=[];
    }
    for(var i=0;i<cartListData.length;i++){
      if(cartListData[i]['checked']){
        tempCheckOutData.add(cartListData[i]);
      }
    }
    return tempCheckOutData;
  }


}