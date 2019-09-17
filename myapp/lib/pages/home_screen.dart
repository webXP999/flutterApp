import 'package:flutter/material.dart';
import 'package:meigui/widgets/tab_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child:TabbedAppBarSample()
          )
        ],
      )
      
    );
  }
}