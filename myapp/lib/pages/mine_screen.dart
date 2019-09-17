import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MineScreen extends StatefulWidget {
  MineScreen({Key key}) : super(key: key);

  _MineScreenState createState() => _MineScreenState();
}

class _MineScreenState extends State<MineScreen> {
  
  List mineList = ['查看主页','发布行情','发布行情','联系我们'];
  List iconList = [Icons.account_balance,Icons.assessment,Icons.assignment,Icons.perm_phone_msg];
  // @override
  // void initState() {
  //   super.initState();
  // }
  Widget _mineWidget() {
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Image.asset('images/bg.png',fit: BoxFit.cover,width: ScreenUtil().setWidth(750)),
              Positioned(
                left: 30,
                top:72,
                child: Icon(Icons.account_circle, size: 70.0,color: Colors.white,)
              ),
              Positioned(
                left: 120,
                top:80,
                child:Text('未登录')
              ),
              Positioned(
                left: 120,
                top:110,
                child:Text('老铁，来个个人简介呗，限定字数')
              )
            ],
          ),
          Container(
            width: ScreenUtil().setWidth(750),
            height: ScreenUtil().setHeight(80),
            alignment: Alignment.center,
            color: Colors.lightBlue,
            child: Text('欢迎您！经销商点击登录',style: TextStyle(color: Colors.white),),
          ),
          Expanded(
            child:Container(
              child: ListView.separated(
                itemCount: 4,
                shrinkWrap: true,
                separatorBuilder: (BuildContext context, int index) => Divider(height: 1.0,color: Colors.black26),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(mineList[index]),
                    leading: Icon(iconList[index], color: Colors.lightBlue,),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    contentPadding: EdgeInsets.all(5.0),
                  );
                },
              ),
            )
          )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('个人中心')),
      body: _mineWidget(),
    );
  }
}