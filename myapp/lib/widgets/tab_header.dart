import 'package:flutter/material.dart';
import 'package:meigui/pages/home/recommend.dart';
// import 'package:meigui/pages/home/news.dart';
import 'package:meigui/pages/home/quotation.dart';
import 'package:meigui/pages/home/supplier.dart';
import 'package:meigui/pages/home/video.dart';
// import 'banner.dart';

class TabbedAppBarSample extends StatelessWidget {
  
  final List<Tab> myTabs = <Tab>[
    Tab(text: '推荐'),
    // Tab(text: '资讯'),
    Tab(text: '视频'),
    Tab(text: '经销商'),
    Tab(text: '行情')
  ];
  final List<Widget> tabList = [
    Recommend(),
    // News(),
    Video(),
    Supplier(),
    Quotation()
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('首页'),
          leading: Icon(Icons.home),
          bottom: TabBar(
            // isScrollable: true,
            tabs: myTabs,
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: TabBarView(
                children: tabList.map((item) {
                  return item;
                }).toList(),
              ),
            )
          ],
        )
      )
    );
  }
}
