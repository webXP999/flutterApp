import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meigui/pages/mine_screen.dart';
import 'package:meigui/pages/news_screen.dart';
import 'package:meigui/pages/home_screen.dart';
import 'package:meigui/pages/cars_screen.dart';



class GuideScene extends StatefulWidget {
  GuideScene({Key key}) : super(key: key);

  _GuideSceneState createState() => _GuideSceneState();
}
/*
 * with是dart的关键字，意思是混入的意思，就是说可以将一个或者多个类的功能添加到自己的类无需继承这些类， 避免多重继承导致的问题。
 * 混入AutomaticKeepAliveClientMixin，这是保持状态的关键
 * 然后重写wantKeppAlive 的值为true。
 */
class _GuideSceneState extends State<GuideScene> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  // final _GuideSceneColor = Colors.black;
  int _currenIndex = 0;
  List<Widget> list = List();

  @override
  void initState() {
    list
      ..add(HomeScreen())
      ..add(NewsScreen())
      ..add(CarsScreen())
      ..add(MineScreen());
      super.initState();
      print(111);
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true)..init(context);
    return Scaffold(
      body: IndexedStack(
        index:_currenIndex,
        children: list,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type:BottomNavigationBarType.fixed,
        fixedColor: Colors.lightBlue,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              // color: _GuideSceneColor,
            ),
            title: Text(
              '首页',
              // style:TextStyle(color: _GuideSceneColor)
            )
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message,
              // color: _GuideSceneColor,
            ),
            title: Text(
              '资讯',
              // style:TextStyle(color: _GuideSceneColor)
            )
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.pages,
              // color: _GuideSceneColor,
            ),
            title: Text(
              '选车',
              // style:TextStyle(color: _GuideSceneColor)
            )
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              // color: _GuideSceneColor,
            ),
            title: Text(
              '我的',
              // style:TextStyle(color: _GuideSceneColor)
            )
          )
        ],
        currentIndex: _currenIndex,
        onTap: (int index){
          setState(() {
            _currenIndex = index;
          });
        },
      )
    );
  }
}