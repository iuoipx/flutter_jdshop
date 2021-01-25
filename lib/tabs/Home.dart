import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../services/ScreenAdapter.dart';
import 'package:dio/dio.dart';
import '../model/FoucsModel.dart';
import '../model/ProductModel.dart';
import '../config/Config.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  List _foucsData=[];
  List _hotProductData=[];
  List _bestProductData=[];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() { 
    super.initState();
    this._getFoucsData();
    this._getHotProductData();
    this._getBestProductData();
  }
  //获取轮播图数据
  _getFoucsData() async{  
    var api='${Config.domain}api/focus';
    var result=await Dio().get(api);
    var focusList=FocusModel.fromJson(result.data);
    //print(focusList.result);
    setState(() {
      this._foucsData=focusList.result;
    });
  }
  //获取喜欢模块数据
  _getHotProductData() async{
    var api='${Config.domain}api/plist/?is_hot=1';
    var result=await Dio().get(api);
    var productList=ProductModel.fromJson(result.data);
    setState(() {
      this._hotProductData=productList.result;
    });
  }
//获取推荐模块数据
  _getBestProductData() async{
    var api='${Config.domain}api/plist/?is_best=1';
    var result=await Dio().get(api);
    var productList=ProductModel.fromJson(result.data);
    setState(() {
      this._bestProductData=productList.result;
    });
  }

  //轮播图
  Widget _swiperWidget() {
    if(this._foucsData.length>0){
      return Container(
        width: double.infinity,
        height: ScreenAdapter.getScreenWidth()/2,
        child: AspectRatio(
          aspectRatio: 2 / 1,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              String pic=this._foucsData[index].pic;
              pic=Config.domain+pic.replaceAll('\\', '/');
              return new Image.network(
                pic,
                fit: BoxFit.fill,
              );
            },
            itemCount: this._foucsData.length,
            autoplay: true,
            pagination: new SwiperPagination(),
          ),
        ),
      );
    }else{
      return Container(
        width: double.infinity,
        height: ScreenAdapter.getScreenWidth()/2,
      );
    }
  }

  //标题
  Widget _titleWidget(value) {
    return Container(
      height: ScreenAdapter.height(32),
      padding: EdgeInsets.only(left: ScreenAdapter.width(20)),
      margin: EdgeInsets.only(left: ScreenAdapter.width(20)),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: ScreenAdapter.width(10), 
            color: Colors.red
          )
        )
      ),
      child: Text(
        value,
        style: TextStyle(color: Colors.black87, fontSize: 12),
      ),
    );
  }

  //猜你喜欢
  Widget _likeProductListWidget() {
    if(this._hotProductData.length>0){
      return Container(
        padding: EdgeInsets.all(ScreenAdapter.width(20)),
        width: double.infinity,
        height: ScreenAdapter.height(200),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: this._hotProductData.length,
          itemBuilder: (context, index) {
            String sPic=this._hotProductData[index].sPic;
            sPic=Config.domain+sPic.replaceAll('\\', '/');
            return Column(
              children: <Widget>[
                Container(
                  width: ScreenAdapter.width(100),
                  height: ScreenAdapter.height(100),
                  margin: EdgeInsets.only(right: ScreenAdapter.width(20)),
                  child:Image.network(
                    sPic,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: ScreenAdapter.height(20)),
                  height: ScreenAdapter.height(30),
                  child:Text(
                    '￥${this._hotProductData[index].price}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red
                    ),
                  )
                ),
              ],
            );
          },
        ),
      );
    }else{
      return Container(
        width: double.infinity,
        height: ScreenAdapter.height(200),
      );
    }
  }

  Widget _recProductListWidget(){
    var itemWidth=(ScreenAdapter.getScreenWidth()-ScreenAdapter.width(62))/2;
    return Container(
      padding: EdgeInsets.all(10),
      child: Wrap(
        spacing: ScreenAdapter.width(20),
        runSpacing: ScreenAdapter.width(20),
        children: this._bestProductData.map((value){
          String sPic=value.sPic;
          sPic=Config.domain+sPic.replaceAll('\\', '/');
          return InkWell(
            onTap: (){
              Navigator.pushNamed(context, '/productContent',arguments: {'id':'${value.sId}'});
            },
            child: Container(
              width: itemWidth,
              padding: EdgeInsets.all(ScreenAdapter.width(20)),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromRGBO(233, 233, 233, 0.9),
                  width: 1
                )
              ),
              child: Column(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1/1,
                    child: Container(
                      child: Image.network(
                        sPic,
                        fit: BoxFit.cover,
                      ),
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenAdapter.height(20)),
                    child: Text(
                      '${value.title}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenAdapter.height(20)),
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '￥${value.price}',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '￥${value.oldPrice}',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList()
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        //title: Text('${this._titleList[_currentIndex]}'),
        leading: IconButton(
          icon: Icon(Icons.center_focus_weak,size: 26,),
          onPressed: (){

          },
        ),
        title: Container(
          height: ScreenAdapter.height(76),
          decoration: BoxDecoration(
            color: Color.fromRGBO(233, 233, 233, 0.8),
            borderRadius: BorderRadius.circular(30)
          ),
          child: InkWell(
            onTap: (){
              Navigator.pushNamed(context, '/search');
            },
            child: Container(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                children: <Widget>[
                  Icon(Icons.search,size: 18,),
                  Text('笔记本',style: TextStyle(
                    fontSize: ScreenAdapter.size(28),
                  ),)
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mail_outline,size: 26,),
            onPressed: (){

            },
          )
        ],
      ),
      body:SingleChildScrollView(
        child:Column(
          children: <Widget>[
            this._swiperWidget(),
            SizedBox(height: ScreenAdapter.height(20),),
            this._titleWidget('猜你喜欢'),
            this._likeProductListWidget(),
            this._titleWidget('热门推荐'),
            this._recProductListWidget(),
          ],
        ),
      )
    );
  }
}
