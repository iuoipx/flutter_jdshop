import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../services/ScreenAdapter.dart';
import '../services/SearchService.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var _keywords;
  var _hintText='笔记本';
  
  List _historyListData=[];

  @override
  void initState() {
    super.initState();
    this._getHistoryData();
  }
  //获取历史记录数据
  _getHistoryData() async{
    var historyListData=await SearchService.getHistoryData();
    setState(() {
      this._historyListData=historyListData;
    });
  }

  _alertDialog(keywords) async{
    var result=await showDialog(
      barrierDismissible:true,
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("提示信息"),
          content: Text("您确定删除吗"),
          elevation: 20,
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.of(context).pop("cancel");
              },
              child: Text("取消"),
            ),
            FlatButton(
              onPressed: () async{
                //注意异步
                //print('${keywords}');
                await SearchService.removeHistoryData('${keywords+''}');
                _getHistoryData();
                Navigator.of(context).pop("ok");
              },
              child: Text("确定"),
            ),
          ],
        );
      }
    );
    print(result);
  }

  Widget _historyListWidget(){
    if(this._historyListData.length>0){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10),
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Text('搜索历史',style: Theme.of(context).textTheme.title,),
          ),
          Divider(height: 0,),
          Column(
            children: this._historyListData.map((value){
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text('${value+''}'),
                    onLongPress: (){
                      this._alertDialog(value);
                    },
                  ),
                  Divider(
                    height: 0,
                  )
                ],
              );
            }).toList()
          ),
          Center(
            child: InkWell(
              child: Container(
                height: ScreenAdapter.height(80),
                width: ScreenAdapter.width(400),
                margin: EdgeInsets.only(top: ScreenAdapter.height(40)),              
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromRGBO(233, 233, 233, 0.8),
                    width: 1
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.delete),
                    Text('清空历史记录')
                  ],
                ),
              ),
              onTap: (){
                SearchService.clearHistoryData();
                this._getHistoryData();
              },
            ),
          )
        ],
      );
    }else{
      return Container(
        width: 0,
        height: 0,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Stack(
          alignment: FractionalOffset(0, 0.5),
          children: <Widget>[
            Container(
              height: ScreenAdapter.height(76),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(233, 233, 233, 0.8),
                  borderRadius: BorderRadius.circular(30)
              ),
              //child: 
            ),
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                hintText: this._hintText,
                hintStyle: TextStyle(color: Colors.black26)              
              ),
              onChanged: (value){
                this._keywords=value;
              },
            ),
          ],
        ),
        actions: <Widget>[
          InkWell(
            onTap: (){
              this._keywords==null?this._keywords=this._hintText:this._keywords=this._keywords;
              SearchService.setHistoryData(this._keywords);
              Navigator.pushReplacementNamed(context, '/productList',arguments: {'keywords':'${this._keywords}'});
            },
            child: Container(
              color: Colors.red[700],    //去掉inkwell点击效果
              height: ScreenAdapter.height(76),
              width: ScreenAdapter.width(90),
              child: Row(
                children: <Widget>[
                  Text('搜索')
                ],              
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text('热搜',style: Theme.of(context).textTheme.title,),
            ),
            Wrap(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(10, 6, 10, 10),
                  padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(233, 233, 233, 0.9)
                  ),
                  child: Text('笔记本电脑'),
                ),
                Container(
                  margin: EdgeInsets.all(6),
                  padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(233, 233, 233, 0.9)
                  ),
                  child: Text('笔记本'),
                ),
              ],
            ),
            Container(
              height: 10,
              color: Color.fromRGBO(233, 233, 233,0.9),
            ),
            //历史记录
            _historyListWidget(),
          ],
        ),
      ),
    );
  }
}