import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';
import 'Home.dart';
import 'Category.dart';
import 'Cart.dart';
import 'User.dart';

class BottomTab extends StatefulWidget {
  final int index;
  BottomTab({Key key, this.index = 0}) : super(key: key);
  @override
  _BottomTabState createState() => _BottomTabState();
}

class _BottomTabState extends State<BottomTab> {
  int _currentIndex=0;
  List <Widget> _pageList=[
    HomePage(),
    CategoryPage(),
    CartPage(),
    UserPage()
  ];
  // List <String> _titleList=[
  //   '首页',
  //   '分类',
  //   '购物车',
  //   '我的',
  // ];
  PageController _pageController;
  @override
  void initState() {
    super.initState();
    this._currentIndex=widget.index;
    this._pageController=PageController(initialPage: _currentIndex);
  }
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      body: PageView(
        controller: this._pageController,
        children: this._pageList,
        physics: NeverScrollableScrollPhysics(),
        // onPageChanged: (index){
        //   setState(() {
        //     this._currentIndex=index;            
        //   });
        // },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          setState(() {
            this._currentIndex=index;
            this._pageController.jumpToPage(index);
          });
        },
        currentIndex: this._currentIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.red,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('首页')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            title: Text('分类')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('购物车')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('我的')
          ),
        ],
      ),
    );
  }
}