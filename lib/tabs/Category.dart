import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../services/ScreenAdapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_jdshop/config/Config.dart';
import '../model/CateModel.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with AutomaticKeepAliveClientMixin{
  int _selectedIndex=0;
  List _leftCateData=[];
  List _rightCateData=[];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() { 
    super.initState();
    _getLeftCateData();
  }
  //获取左侧数据
  _getLeftCateData() async{
    var api='${Config.domain}api/pcate';
    var result=await Dio().get(api);
    var leftCateList=CateModel.fromJson(result.data);
    setState(() {
      this._leftCateData=leftCateList.result;  
    });
    _getRightCateData(this._leftCateData[0].sId);
  }
  //获取右侧数据
  _getRightCateData(pid) async{
    var api='${Config.domain}api/pcate?pid=${pid+''}';
    var result=await Dio().get(api);
    var rightCateList=CateModel.fromJson(result.data);
    setState(() {
      this._rightCateData=rightCateList.result;  
    });
  }

  Widget _leftCateWidget(leftWidth){
    if(this._leftCateData.length>0){
      return Container(
        width: leftWidth,
        height: double.infinity,
        child: ListView.builder(
          itemCount: this._leftCateData.length,
          itemBuilder: (context,index){
            return InkWell(
              child: Container(
                width: double.infinity,
                height: ScreenAdapter.height(120),
                color: this._selectedIndex==index?Colors.white:Color.fromRGBO(240, 240, 240, 1),
                child: Center(
                  child: Text(
                    "${this._leftCateData[index].title}",
                    style: TextStyle(
                      color: this._selectedIndex==index?Colors.black:Colors.black38,
                      fontSize: this._selectedIndex==index?16:14
                    ),
                  ),
                ),
              ),
              onTap: (){
                setState(() {
                  this._selectedIndex=index;
                  this._getRightCateData(this._leftCateData[index].sId);
                });
              },
            );
          },
        ),
      );
    }else{
      return Container(
        width: leftWidth,
        height: double.infinity,
      );
    }
  }

  Widget _rightCateWidget(rightItemWidth,rightItemHeight){
    if(this._rightCateData.length>0){
      return Expanded(
        flex: 1,
        child: Container(
          padding: EdgeInsets.all(10) ,
          height: double.infinity,
          color: Colors.white,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: rightItemWidth/rightItemHeight,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10
            ),
            itemCount: this._rightCateData.length,
            itemBuilder: (context,index){
              String pic=this._rightCateData[index].pic;
              pic=Config.domain+pic.replaceAll('\\', '/');
              return InkWell(
                onTap: (){
                  Navigator.pushNamed(context, '/productList',arguments: {'cid':'${this._rightCateData[index].sId}'});
                },
                child:Container(
                  child: Column(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1/1,
                        child: Image.network(pic),
                      ),
                      Container(
                        height: ScreenAdapter.height(40),
                        child: Text(
                          '${this._rightCateData[index].title}',
                          style: TextStyle(
                            fontSize: 12
                          ),
                        ),
                      )
                    ],
                  ),
                )
              );
            },
          ),
        ),
      );
    }else{
      return Expanded(
        flex: 1,
        child: Container(
          padding: EdgeInsets.all(10) ,
          height: double.infinity,
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    super.build(context);
    //左侧宽度
    var leftWidth=ScreenAdapter.getScreenWidth()/4;
    //右侧每一项宽度
    var rightItemWidth=(ScreenAdapter.getScreenWidth()-leftWidth-40)/3;
    rightItemWidth=ScreenAdapter.width(rightItemWidth);
    //右侧每一项高度
    var rightItemHeight=rightItemWidth+ScreenAdapter.height(20);
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
        body:Row(
          children: <Widget>[
            this._leftCateWidget(leftWidth),
            this._rightCateWidget(rightItemWidth, rightItemHeight)
          ],
        )
    );
  }
}