import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_jdshop/services/ScreenAdapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_jdshop/config/Config.dart';
import '../model/ProductModel.dart';
import '../widget/LoadingWidget.dart';
import '../services/SearchService.dart';

class ProductListPage extends StatefulWidget {
  final Map arguments;
  ProductListPage({Key key,this.arguments}):super(key:key);
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey=new GlobalKey<ScaffoldState>();
  
  //上拉分页
  ScrollController _scrollController=new ScrollController();
  //滑动到底请求数据完成之前不允许重复请求
  bool _flag=true;
  //分页
  int _page=1;
  //每一页返回数据条数
  int _pageSize=8;
  //是否有数据
  bool hasMore=true;
  //是否有搜索内容
  bool hasSearchData=true;
  //保存数据
  List _productList=[];
  //排序
  String _sort='';

  //判断导航选中
  int _selectId=1;
  //二级导航数据
  List _subHeaderList=[
    {
      'id':1,
      'title':'综合',
      'fileds':'all',
      'sort':-1
    },
    {
      'id':2,
      'title':'销量',
      'fileds':'salecount',
      'sort':-1
    },
    {
      'id':3,
      'title':'价格',
      'fileds':'price',
      'sort':-1
    },
    {
      'id':4,
      'title':'筛选',
    },
  ];

  //搜索框内容
  var _initKeyWordsController=new TextEditingController();
  //cid
  var _cid;
  //keywords
  var _keywords;
  
  @override
  void initState() {
    super.initState();
    this._cid=widget.arguments['cid'];
    this._keywords=widget.arguments['keywords'];
    this._initKeyWordsController.text=this._keywords;

    _getProductListData();
    this._scrollController.addListener((){
      //_scrollController.position.pixels;  //滚动条已经滚动高度
      //_scrollController.position.maxScrollExtent;   //页面高度
      if(_scrollController.position.pixels>_scrollController.position.maxScrollExtent-20){
        if(this._flag&&this.hasMore){
          setState(() {
            _getProductListData();
          });
        }
      }  
    });
  }

  //获取商品列表数据
  _getProductListData()async{
    setState(() {
      this._flag=false;
    });
    var api;
    if(this._keywords==null){
      api='${Config.domain}api/plist/?cid=${this._cid}&page=${this._page}&sort=${this._sort}&pageSize=${this._pageSize}';
    }else{
      api='${Config.domain}api/plist/?search=${this._keywords}&page=${this._page}&sort=${this._sort}&pageSize=${this._pageSize}';
    }
    //print(api);
    var result=await Dio().get(api);
    var productList=ProductModel.fromJson(result.data);
    
    //判断是否有搜索数据
    if(productList.result.length==0&&this._page==1){
      setState(() {
        this.hasSearchData=false;
      });
    }else{
      setState(() {
        this.hasSearchData=true;
      });
    }

    //判断最后一页有没有数据
    if(productList.result.length<this._pageSize){
      this.hasMore=false;
      setState(() {
        this._productList.addAll(productList.result);
        this._page++;
        this._flag=true;
      });
    }else{
      setState(() {
        this._productList.addAll(productList.result);
        this._page++;
        this._flag=true;
      });
    }
  }
  
  //判断商品列表底部进度条是否显示
  showMore(index){
    if(this.hasMore){
      return (index==this._productList.length-1)?LoadingWidget():Container(height: 0,);
    }else{
      return (index==this._productList.length-1)
        ?Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
          child: Text('---已经到底了---',textAlign: TextAlign.center,),
        )
        :Container(height: 0,);
    }
  }
  
  //商品列表
  Widget _productListWidget(){
    if(this._productList.length>0){
      return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        margin: EdgeInsets.only(top: ScreenAdapter.height(80)),
        child: ListView.builder(
          itemCount: this._productList.length,
          controller: _scrollController,
          itemBuilder: (context,index){
            String pic=this._productList[index].pic;
            pic=Config.domain+pic.replaceAll('\\', '/');
            //print(pic);
            return Column(
              children: <Widget>[
                Divider(
                  height: 0,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 6, 10, 6),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: ScreenAdapter.width(180),
                        height: ScreenAdapter.height(180),
                        child: Image.network(pic,fit: BoxFit.cover,),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: ScreenAdapter.height(180),
                          margin: EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${this._productList[index].title}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    height: ScreenAdapter.height(40),
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromRGBO(230, 230, 230, 0.9)
                                    ),
                                    child: Text('4g'),
                                  ),
                                  Container(
                                    height: ScreenAdapter.height(40),
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromRGBO(230, 230, 230, 0.9)
                                    ),
                                    child: Text('126'),
                                  ),
                                ],
                              ),
                              Text(
                                '￥${this._productList[index].price}',
                                style: TextStyle(
                                  color: Colors.red
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                ),
                showMore(index)
              ],
            );
          },
        )
      );
    }else{
      return LoadingWidget();
    }
  }
  
  //导航点击切换商品内容
  _subHeaderChange(id){
    if(id==4){
      this._scaffoldKey.currentState.openEndDrawer();
    }else{
      setState(() {
        this._selectId=id;
        //排序
        this._sort="${this._subHeaderList[id-1]['fileds']}_${this._subHeaderList[id-1]['sort']}";
        //重置分页
        this._page=1;
        //清空数据
        this._productList=[];
        //防止滑到最底部hasMore变成false
        this.hasMore=true;
        //切换升序降序
        this._subHeaderList[id-1]['sort']=this._subHeaderList[id-1]['sort']*-1;
        //回到顶部
        this._scrollController.jumpTo(0);
        //请求数据
        this._getProductListData();
      });
    }
  }

  //导航点击切换图标
  _showIcon(id){
    if(id==2||id==3){
      //print(this._selectId==id);
      if(this._selectId==id){
        return (this._subHeaderList[id-1]['sort']==1)
          ?Icon(Icons.arrow_drop_down,size: 18,)
          :Icon(Icons.arrow_drop_up,size: 18);
      }else{
        // return Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     Icon(Icons.arrow_drop_up,size: 18,),
        //     Icon(Icons.arrow_drop_down,size: 18,)
        //   ],
        // );
        return Image.asset("images/jiantou.png",
          width: 10,
          height: 10,
        );
      }
    }
    return Container(
      width: 0,
      height: 0,
    );
  }

  //筛选导航
  Widget _subHeaderWidget(){
    return Positioned(
      width: ScreenAdapter.getScreenWidth(),              
      height: ScreenAdapter.height(100),
      top: 0,
      child: Container(
        width: ScreenAdapter.getScreenWidth(),              
        height: ScreenAdapter.height(100),
        // decoration: BoxDecoration(
        //   border: Border(
        //     bottom: BorderSide(
        //       width: 1,
        //       color: Color.fromRGBO(233, 233, 233, 1)
        //     )
        //   )
        // ),
        child: Row(
          children: this._subHeaderList.map((value){
            return Expanded(
              flex: 1,
              child: InkWell(
                child: Container(
                  height: ScreenAdapter.height(96),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("${value['title']}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: this._selectId==value['id']?Colors.red:Colors.black
                          ),  
                        ),
                        _showIcon(value['id'])
                      ],
                    )
                  )
                ),
                onTap: (){
                  this._subHeaderChange(value['id']);
                },
              ),
            );
          }).toList()
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: Container(
          height: ScreenAdapter.height(76),
          decoration: BoxDecoration(
              color: Color.fromRGBO(233, 233, 233, 0.8),
              borderRadius: BorderRadius.circular(30)
          ),
          child: TextField(
            controller: this._initKeyWordsController,
            autofocus: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none
              )              
            ),
            onChanged: (value){
              setState(() {
                this._keywords=value;
              });
            },
          ),
        ),
        actions: <Widget>[
          InkWell(
            onTap: (){
              SearchService.setHistoryData(this._keywords);
              this._subHeaderChange(1);
            },
            child: Container(
              height: ScreenAdapter.height(76),
              width: ScreenAdapter.width(90),
              color: Colors.red[700],   //去掉inkwell点击效果
              child: Row(
                children: <Widget>[
                  Text('搜索')
                ],              
              ),
            ),
          )
        ],
      ),
      endDrawer: Drawer(
        child: Text('adniadbwdb'),
      ),
      body: this.hasSearchData
        ?Stack(
          children: <Widget>[
            _subHeaderWidget(),
            _productListWidget(),
          ],
        )
        :Center(
          child: Text('没有您要搜索的内容'),
        )
    );
  }
}