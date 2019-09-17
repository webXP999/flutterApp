
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:meigui/request.dart';


class VideoDetail extends StatefulWidget {
  VideoDetail({Key key, this.id}) : super(key: key);
  final id;
  _VideoDetailState createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  VideoPlayerController _controller;
  String url = 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';
  @override
  void initState() {
    fetchData();
    super.initState();
     _controller = VideoPlayerController.network(this.url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  Map detailData = {};
  void fetchData() async {
    String url = '/video.php?m=index&id=${widget.id}';
    var result = await HttpUtils.request(url);
    setState(() {
      detailData = result;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('视频详情'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
      body: detailData.length > 0 ?
        Container(
          child: Column(
            children: <Widget>[
              Container(
                // child: Image.network(detailData['thumb'], fit: BoxFit.fill),
                // height: ScreenUtil().setHeight(400),
                 child: _controller.value.initialized
                    // 加载成功
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                    ) : Image.network(detailData['thumb'], fit: BoxFit.fill),
              ),
              Container(
                // height: ScreenUtil().setHeight(32),
                margin: EdgeInsets.all(10.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  detailData['subject'],
                  style: TextStyle(
                      fontSize: 18.0, color: Color.fromRGBO(0, 0, 0, 1)),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      detailData['createdate'],
                      style: TextStyle(
                          fontSize: 12.0, color: Color.fromRGBO(51, 51, 51, 1)),
                    ),
                    Text(
                      '播放量${detailData['clicks']}',
                      style: TextStyle(
                          fontSize: 12.0, color: Color.fromRGBO(51, 51, 51, 1)),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10.0,top: 20.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      detailData['dealer_name'],
                      style: TextStyle(
                          fontSize: 12.0, color: Color.fromRGBO(51, 51, 51, 1)),
                    ),
                    Text(
                      '电话${detailData['mobile']}',
                      style: TextStyle(
                          fontSize: 12.0, color: Color.fromRGBO(51, 51, 51, 1)),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left:10.0, top: 20.0),
                child:Text(detailData['content'])
              ),
              // 分割线
              Container(
                margin: EdgeInsets.all(10.0),
                color: Color(0xffeaeaea),
                constraints: BoxConstraints.expand(height: 1.0),
              )
            ],
          ),
        ) : Text('正在加载中')
    );
  }
}