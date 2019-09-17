import 'package:flutter/material.dart';
import 'package:meigui/request.dart';
import 'package:meigui/widgets/banner.dart';
import 'package:meigui/widgets/news_widget.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class NewsScreen extends StatefulWidget {
  NewsScreen({Key key}) : super(key: key);

  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    fetchData();
    fetchBanner();
    super.initState();
  }

  List urls = [];
  int curPage = 1;
  List newsData = [];
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerkey =
      new GlobalKey<RefreshFooterState>();

  Future<void> fetchBanner() async {
    String url = '/news.php?m=focus_news';
    var result = await HttpUtils.request(url);
    setState(() {
      urls = result['data'];
    });
  }

  Future<void> fetchData() async {
    String url = '/news.php?m=cat_news&page=$curPage&catid=';
    var result = await HttpUtils.request(url);
    setState(() {
      newsData.addAll(result['data'].isEmpty ? [] : result['data']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('资讯'),
      ),
      body: newsData.length > 0
          ? Container(
              child: Scaffold(
                  body: Column(
                children: <Widget>[
                  HomeBanner(urls: urls),
                  Expanded(
                    child: EasyRefresh(
                      refreshHeader: ClassicsHeader(
                        key: _headerKey,
                        bgColor: Colors.transparent,
                        textColor: Colors.black87,
                        moreInfoColor: Colors.black54,
                        showMore: true,
                      ),
                      refreshFooter: ClassicsFooter(
                        key: _footerkey,
                        bgColor: Colors.transparent,
                        textColor: Colors.black87,
                        moreInfoColor: Colors.black54,
                        showMore: true,
                      ),
                      child: ListView.builder(
                          itemCount: newsData.length,
                          shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return NewsWidget(newsItem: newsData[index]);
                          }),
                      onRefresh: () async {
                        curPage = 1;
                        newsData = [];
                        await fetchData();
                      },
                      loadMore: () async {
                        curPage++;
                        await fetchData();
                      },
                    )
                  )
                ],
              )),
            )
          : Text('正在加载中...'),
    );
  }
}
