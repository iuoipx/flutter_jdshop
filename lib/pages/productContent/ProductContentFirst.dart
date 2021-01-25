import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../../config/Config.dart';
import '../../services/CartService.dart';
import '../../widget/BuyButtonWidget.dart';
import '../../services/ScreenAdapter.dart';
import '../../model/ProductContentModel.dart';
import '../../services/EventBus.dart';
import 'package:provider/provider.dart';
import '../../provider/CartProvider.dart';
import 'ProductCartNum.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductContentFirst extends StatefulWidget {
  final List _productContentList;
  ProductContentFirst(this._productContentList,{Key key}):super(key:key);
  @override
  _ProductContentFirstState createState() => _ProductContentFirstState();
}

class _ProductContentFirstState extends State<ProductContentFirst> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  ProductContentItem _productContent;
  List _attr=[];
  String _selectedValue;

  //销毁事件监听
  var actionEventBus;
  @override
  void initState() { 
    super.initState();
    this._productContent=widget._productContentList[0];
    this._attr=_productContent.attr;
    this._initAttr();


    //监听 <ProductContentEvent> 广播
    this.actionEventBus=eventBus.on<ProductContentEvent>().listen((event){
      this._attrBottomSheet();
    });
  }

  @override  
  void dispose(){
    super.dispose();
    //销毁事件监听
    this.actionEventBus.cancel();  
  }


//[{"cate":"鞋面材料","list":["牛皮 "]},{"cate":"闭合方式","list":["系带"]},{"cate":"颜色","list":["红色","白色","黄色"]}]
  /*
    'list':['白色','黑色','红色']      默认数据格式
    
    修改后数据格式
    'list':[
      {
      'title':'白色',
      'checked':'false'
      },
      {
      'title':'黑色',
      'checked':'false'
      },{
      'title':'红色',
      'checked':'false'
      },
    ]
  */ 


  //格式化数据
  _initAttr(){
    var attr=this._attr;
    for(var i=0;i<attr.length;i++){
      for(var j=0;j<attr[i].list.length;j++){
        if(j==0){
            attr[i].attrList.add({
            'title': attr[i].list[j],
            'checked':true
          });
        }else{
          attr[i].attrList.add({
            'title': attr[i].list[j],
            'checked':false
          });
        }
      }
    }
    _getSelectedAttr();
  }
  //改变点击选中状态
  _changeAttr(cate,title,setBottomState){
    var attr=this._attr;
    for(var i=0;i<attr.length;i++){
      if(attr[i].cate==cate){
        for(var j=0;j<attr[i].attrList.length;j++){
          attr[i].attrList[j]['checked']=false;
          if(title==attr[i].attrList[j]['title']){
          attr[i].attrList[j]['checked']=true;
          }
        }
      }
    }
    //改变showModelBottomSheet里面的数据,来源于StateFulBuilder
    setBottomState(() {
      this._attr=attr;
    });
    _getSelectedAttr();
  }

  //获取选中的值
  _getSelectedAttr(){
    var _list=this._attr;
    List tempAttr=[];
    for(var i=0;i<_list.length;i++){
      for(var j=0;j<_list[i].attrList.length;j++){
        if(_list[i].attrList[j]['checked']){
          tempAttr.add(_list[i].attrList[j]['title']);
        }
      }
    }
    //print(tempAttr.join(','));
    setState(() {
      this._selectedValue=tempAttr.join(',');

      //给选中属性赋值
      this._productContent.selectedAttr=this._selectedValue;
    });
  }
 
  List<Widget> _getAttrItemWidget(attrItem,setBottomState){
    List<Widget> attrItemList=[];
    attrItem.attrList.forEach((item){
      attrItemList.add(Container(
        margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: GestureDetector(
          onTap: (){
            _changeAttr(attrItem.cate,item['title'],setBottomState);
          },
          child: Chip(
            label: Text(
              '${item['title']}',
              style: TextStyle(
                color: item['checked']?Colors.white:Colors.black54
              ),
            ),
            padding: EdgeInsets.all(8),
            backgroundColor: item['checked']?Colors.red:Colors.black12,
          ),
        )
      ));
    });
    return attrItemList;
  }

  List<Widget> _getAttrWidget(setBottomState){
    List<Widget> attrList=[];
    this._attr.forEach((attrItem){
      attrList.add(Wrap(
        children: <Widget>[
          Container(
            width: ScreenAdapter.width(130),
            child: Padding(
              padding: EdgeInsets.only(top: ScreenAdapter.height(48)),
              child: Text('${attrItem.cate}:',style: TextStyle(fontWeight: FontWeight.bold),),
            )
          ),
          Container(
            width: ScreenAdapter.width(590),
            child: Wrap(
              children: _getAttrItemWidget(attrItem,setBottomState),
            )
          )
        ],
      ));
    });
    return attrList;
  }

  //底部弹出框
  var cartProvider;
  _attrBottomSheet(){
    showModalBottomSheet(
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (BuildContext context, setBottomState) {
            return GestureDetector(
              onTap: (){
                return false;
              },
              child: Container(
                color: Colors.white,
                height: 400,
                child: Stack(
                  children: <Widget>[
                    ListView(
                      children: <Widget>[
                        Column(
                          children: _getAttrWidget(setBottomState)
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white
                          ),
                          margin: EdgeInsets.only(top: 10),
                          height: ScreenAdapter.height(100),
                          child: Row(
                            children: <Widget>[
                              Divider(),
                              Text('数量:',style: TextStyle(fontWeight: FontWeight.bold),), 
                              SizedBox(width: 10,),
                              ProductCartNum(this._productContent),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      width: ScreenAdapter.width(750),
                      height: ScreenAdapter.height(100),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: BuyButton(
                              color:Color.fromRGBO(253, 1, 0, 0.9),
                              text:'加入购物车',
                              cb:() async{  //CartService.addCart()为异步方法，加上async await等待执行完再去执行下面语句
                                //选出需要在购物车中显示的数据
                                await CartService.addCart(this._productContent);  
                                Navigator.of(context).pop();
                                //调用provider更新数据
                                cartProvider.updateCartList();
                                Fluttertoast.showToast(
                                    msg: "加入购物车成功",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIos: 1,
                                    backgroundColor: Colors.black87,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              }
                            )
                          ),
                          Expanded(
                            flex: 1,
                            child: BuyButton(
                              color:Color.fromRGBO(255, 165, 0, 0.9),
                              text:'立即购买',
                              cb:(){

                              }
                            )
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    this.cartProvider=Provider.of<CartProvider>(context);
    var pic=this._productContent.pic;
    pic=Config.domain+pic.replaceAll('\\', '/');
    ScreenAdapter.init(context);
    return Container(
      color: Color.fromRGBO(233, 233, 233, 0.9),
      child: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 5/4,
            child: Image.network(pic,fit: BoxFit.cover,),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white
            ),
            margin: EdgeInsets.only(top: 10),
            child: Text(
              '${this._productContent.title}',
              style: TextStyle(
                color: Colors.black,
                fontSize: ScreenAdapter.size(36)
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white
            ),
            child: Text(
              '${this._productContent.subTitle}',
              style: TextStyle(
                color: Colors.black45,
                fontSize: ScreenAdapter.size(28)
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white
            ),
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '现价',
                        style: TextStyle(
                          fontSize: ScreenAdapter.size(28),
                        ),
                      ),
                      Text(
                        '￥${this._productContent.price}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: ScreenAdapter.size(40)
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '原价',
                        style: TextStyle(
                          fontSize: ScreenAdapter.size(28),
                        ),
                      ),
                      Text(
                        '￥${this._productContent.oldPrice}',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: ScreenAdapter.size(36),
                          decoration: TextDecoration.lineThrough
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white
            ),
            margin: EdgeInsets.only(top: 10),
            height: ScreenAdapter.height(80),
            child: InkWell(
              onTap: (){
                _attrBottomSheet();
              },
              child: Row(
                children: <Widget>[
                  Text('已选:',style: TextStyle(fontWeight: FontWeight.bold),), 
                  Text('${this._selectedValue}')
                ],
              ),
            )
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white
            ),
            margin: EdgeInsets.only(top: 10),
            height: ScreenAdapter.height(80),
            child: Row(
              children: <Widget>[
                Text('运费:',style: TextStyle(fontWeight: FontWeight.bold),), 
                Text('免运费')
              ],
            ),
          ),
          SizedBox(
            height: ScreenAdapter.height(150),
          )
        ],
      ),
    );
  }
}