import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'ProductContentFirst.dart';
import 'ProductContentSecond.dart';
import 'ProductContentThird.dart';
import '../../services/ScreenAdapter.dart';
import '../../widget/BuyButtonWidget.dart';
import '../../config/Config.dart';
import 'package:dio/dio.dart';
import '../../model/ProductContentModel.dart';
import '../../widget/LoadingWidget.dart';
import '../../services/EventBus.dart';

class ProductContentPage extends StatefulWidget {
  final Map arguments;
  ProductContentPage({Key key,this.arguments}):super(key:key);
  @override
  _ProductContentPageState createState() => _ProductContentPageState();
}

class _ProductContentPageState extends State<ProductContentPage> {

  List _productContentData=[];
  @override
  void initState() {
    super.initState();

    this._getContentData();
  }
  _getContentData()async{
    var api='${Config.domain}api/pcontent?id=${widget.arguments['id']}';
    var result=await Dio().get(api);
    var productContent=new ProductContentModel.fromJson(result.data);
    setState(() {
      this._productContentData.add(productContent.result);
    });
  }
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Container(
              width: ScreenAdapter.width(400),
              child: TabBar(
                indicatorColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: <Widget>[
                  Tab(
                    child: Text('商品'),
                  ),
                  Tab(
                    child: Text('详情'),
                  ),
                  Tab(
                    child: Text('评价'),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: (){
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(ScreenAdapter.width(600), ScreenAdapter.height(160), ScreenAdapter.width(10), 0),
                  items: [
                    PopupMenuItem(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.home),
                          Text('首页')
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.search),
                          Text('搜索')
                        ],
                      ),
                    ),
                  ]
                );
              },
            )
          ],
        ),
        body: this._productContentData.length>0? Stack(
          children: <Widget>[
            TabBarView(
              physics: NeverScrollableScrollPhysics(),   //禁止左右滑动
              children: <Widget>[
                ProductContentFirst(this._productContentData),
                ProductContentSecond(this._productContentData),
                ProductContentThird()
              ],
            ),
            Positioned(
              width: ScreenAdapter.width(750),
              height: ScreenAdapter.height(100),
              bottom: 0,
              child: Container(
                width: ScreenAdapter.width(750),
                height: ScreenAdapter.height(100),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.black12,
                      width: 1
                    ),
                  ),
                  color: Colors.white
                ),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, '/cart');
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 4),
                        width: 70,
                        height: ScreenAdapter.height(94),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.shopping_cart,size: ScreenAdapter.size(42),),
                            Text('购物车',style: TextStyle(fontSize: 12),)
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: BuyButton(
                        color:Color.fromRGBO(253, 1, 0, 0.9),
                        text:'加入购物车',
                        cb:(){
                          //广播
                          eventBus.fire(ProductContentEvent('加入购物车'));
                        }
                      )
                    ),
                    Expanded(
                      flex: 1,
                      child: BuyButton(
                        color:Color.fromRGBO(255, 165, 0, 0.9),
                        text:'立即购买',
                        cb:(){
                          eventBus.fire(ProductContentEvent('立即购买'));
                        }
                      )
                    ),
                  ],
                )
              ),
            )
          ],
        ):LoadingWidget()
      ),
    );
  }
}