import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:meigui/request.dart';

class NewsDetailInfo extends StatefulWidget {
  NewsDetailInfo({Key key, this.id}) : super(key: key);
  final id;
  _NewsDetailInfoState createState() => _NewsDetailInfoState();
}

class _NewsDetailInfoState extends State<NewsDetailInfo> {
  @override
  void initState() {
    fetchData();
    super.initState();
  }
  Map detailData = {};
  Future<void> fetchData() async {
    String url = '/news.php?m=index&id=${widget.id}';
    var result = await HttpUtils.request(url);
    setState(() {
      detailData = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('详情')
      ),
      body: detailData.isNotEmpty ? Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                detailData['subject'],
                style: TextStyle(
                  fontSize: 20.0,
                  color:Colors.black
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                detailData['createdate'],
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.black87
                ),
              ),
            ),
            Container(
              height: height-200,
              child: Scrollbar(
                child:SingleChildScrollView(
                  child:Column(
                    children: <Widget>[
                      Html(
                        data: detailData['content'],
                      ),
                    ],
                  )
                )
              )
            )
          ],
        ),
      ) : Text('正在加载中...'),
    );
  }
}