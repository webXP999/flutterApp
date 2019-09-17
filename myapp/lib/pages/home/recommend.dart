import 'package:flutter/material.dart';
import 'package:meigui/request.dart';
import 'package:meigui/widgets/banner.dart';
import 'package:meigui/widgets/news_widget.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class Recommend extends StatefulWidget {
  Recommend({Key key}) : super(key: key);

  _RecommendState createState() => _RecommendState();
}

class _RecommendState extends State<Recommend> {
  @override
  void initState() {
    fetchData();
    fetchBanner();
    super.initState();
  }

  List urls = [];
  int curPage = 1;
  List newsData = [];
  GlobalKey<RefreshHeaderState> _headerKey = new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerkey = new GlobalKey<RefreshFooterState>();


  Future<void> fetchBanner() async {
    String url = '/index.php?m=banner';
    var result = await HttpUtils.request(url);
    setState(() {
      urls = result['data'];
    });

  }
  
  Future<void> fetchData() async {
    String url = '/index.php?m=top_news&page=$curPage';
    var result = await HttpUtils.request(url);
    setState(() {
      newsData.addAll(result['data'].isEmpty ? [] : result['data']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return newsData.length > 0
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
                      }
                    ),
                    onRefresh:()async{
                      curPage = 1;
                      newsData = [];
                      await fetchData();
                    },
                    loadMore:()async{
                      curPage++;
                      await fetchData();
                    },
                  )
                )
              ],
            )),
          )
        : Center(
            child:SizedBox(
              height: 20,
              width: 20,
              child:CircularProgressIndicator(backgroundColor: Colors.white)
            )
          );
  }
}
