import 'package:flutter/material.dart';
import '../widget/BuyButtonWidget.dart';
import '../services/ScreenAdapter.dart';

class PayPage extends StatefulWidget {
  PayPage({Key key}) : super(key: key);

  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  List _payList=[
    {
      'title':'支付宝支付',
      'checked':true,
      'image':'https://www.itying.com/themes/itying/images/alipay.png'
    },
    {
      'title':'微信支付',
      'checked':false,
      'image':'https://www.itying.com/themes/itying/images/weixinpay.png'
    },
  ];
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('去支付'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: ScreenAdapter.height(300),
            child: ListView.builder(
              itemCount: this._payList.length,
              itemBuilder: (context,index){
                return Column(
                  children: <Widget>[
                    ListTile(
                      leading: Image.network(
                        '${this._payList[index]['image']}',
                        width: ScreenAdapter.width(80),
                        height: ScreenAdapter.height(80),
                      ),
                      title: Text('${this._payList[index]['title']}'),
                      trailing: this._payList[index]['checked']
                        ?Icon(Icons.check)
                        :Container(width: 0,height: 0,),
                        onTap: (){
                          setState(() {
                            //先让payList里面所有的'checked'置为false,再把当前选中
                            for(var i=0;i<this._payList.length;i++){
                              this._payList[i]['checked']=false;
                            }
                            this._payList[index]['checked']=true; 
                          });
                        },
                    ),
                    Divider(
                      height: 0,
                    )
                  ],
                );
              },
            ),
          ),
          BuyButton(
            text: '支付',
            color: Colors.red,
            cb: (){
              
            },
          )
        ],
      ),
    );
  }
}