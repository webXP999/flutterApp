import 'package:flutter/material.dart';
import 'package:meigui/pages/details/news_detail_info.dart';

class NewsWidget extends StatelessWidget {
  NewsWidget({Key key, this.newsItem}) : super(key: key);
  final Map newsItem;
  Widget _cellContentView(context, item) {
    return GestureDetector(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                newsItem['subject'],
                style: TextStyle(
                  fontSize: 15.0,
                  color: Color(0xff111111),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Container(
                // width: 50.0,
                height: 20.0,
                margin: EdgeInsets.only(top: 6.0),
                child: ButtonTheme(
                  buttonColor: Color(0xff1C64CF),
                  shape: StadiumBorder(),
                  child: Text(newsItem['createdate']),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Container(
          height: 85.0,
          width: 115.0,
          margin: EdgeInsets.only(top: 3.0),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(5.0),
            image: DecorationImage(
              image: NetworkImage(newsItem['thumb']),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115.0,
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailInfo(id: newsItem['id']),
                ),
              );
            },
            // 内容视图
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: _cellContentView(context, newsItem),
            ),
          ),
          // 分割线
          Container(
            margin: EdgeInsets.only(top: 4.0),
            color: Color(0xffeaeaea),
            constraints: BoxConstraints.expand(height: 4.0),
          )
        ],
      ),
    );
  }
}
