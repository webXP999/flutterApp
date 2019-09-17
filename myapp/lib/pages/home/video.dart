import 'package:flutter/material.dart';
import 'package:meigui/pages/details/video_detail.dart';
import 'package:meigui/request.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class Video extends StatefulWidget {
  Video({Key key}) : super(key: key);

  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  int curPage = 1;
  List videoData = [];
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerkey =
      new GlobalKey<RefreshFooterState>();

  Future<void> fetchData() async {
    String url = '/video.php?m=cat_video&catid=&page=$curPage';
    var result = await HttpUtils.request(url);
    setState(() {
      videoData.addAll(result['data'].isEmpty ? [] : result['data']);
    });
  }

  Widget _videoWidget(context, item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoDetail(id: item['id']),
              ),
            );
          },
          child:Image.network(item['thumb'], fit: BoxFit.fill),
        ),
        Container(
          padding: EdgeInsets.all(11.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                item['subject'],
                style: TextStyle(
                    fontSize: 15.0, color: Color.fromRGBO(0, 0, 0, 1)),
              ),
              Container(
                height: 40.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              'images/icon/hot.png',
                              fit: BoxFit.cover,
                              alignment: Alignment.centerLeft,
                              height: 16.0,
                            ),
                            Text(
                              item['dealer_name'],
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Color.fromRGBO(51, 51, 51, 1)),
                            ),
                          ],
                        ),
                    )),
                    Text(
                      '播放量${item['clicks']}',
                      style: TextStyle(
                          fontSize: 12.0, color: Color.fromRGBO(51, 51, 51, 1)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (videoData.length > 0) {
      return Container(
          height: 300.0,
          child: Column(
            children: <Widget>[
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
                    itemCount: videoData.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return _videoWidget(context, videoData[index]);
                    },
                  ),
                  onRefresh: () async {
                    curPage = 1;
                    videoData = [];
                    await fetchData();
                  },
                  loadMore: () async {
                    curPage++;
                    await fetchData();
                  },
                ),
              )
            ],
          ));
    } else {
      return Center(
            child:SizedBox(
              height: 20,
              width: 20,
              child:CircularProgressIndicator(backgroundColor: Colors.white)
            )
          );
    }
  }
}
