import 'package:event_bus/event_bus.dart';

EventBus eventBus=EventBus();

//商品详情广播数据
class ProductContentEvent{
  String str;
  ProductContentEvent(this.str);
}

//用户中心广播数据
class UserEvent{
  String str;
  UserEvent(this.str);
}

//收货地址广播数据
class AddressEvent{
  String str;
  AddressEvent(this.str);
}

//改变默认地址广播数据
class CheckOutEvent{
  String str;
  CheckOutEvent(this.str);
}