import 'package:flutter/material.dart';
import 'routes/Routes.dart';
import 'package:provider/provider.dart';
import 'provider/CartProvider.dart';
import 'provider/CheckOutData.dart';

// 透明状态栏
import 'dart:io';
import 'package:flutter/services.dart';

void main(){
  runApp(MyApp());
  // 透明状态栏
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  } 
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_)=>CartProvider(),),
        ChangeNotifierProvider(builder: (_)=>CheckOutData(),),
      ],
      child: MaterialApp(
        title: '京东商城',
        initialRoute: '/',
        onGenerateRoute: onGenerateRoute,
        debugShowCheckedModeBanner: false,
        //home: BottomTab(),
        theme: ThemeData(
          primaryColor: Colors.red[700],
        ),
      ),
    );
  }
}