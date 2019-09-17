import 'package:flutter/material.dart';
import 'package:meigui/request.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'car_detail.dart';

class SupplierDetail extends StatefulWidget {
  SupplierDetail({Key key, this.id}) : super(key: key);
  final id;
  _SupplierDetailState createState() => _SupplierDetailState();
}

class _SupplierDetailState extends State<SupplierDetail> {
  @override
  void initState() {
    fetchData();
    fetchBrandData();
    fetchCarPriceData();
    super.initState();
  }

  Map topDetailData = {};
  List brandList = [];
  List carPriceList = [];
  // 经销商信息请求
  void fetchData() async {
    String url = '/dealer.php?m=detail&dealer_id=${widget.id}';
    var result = await HttpUtils.request(url);
    setState(() {
      topDetailData = result['data'];
    });
  }
  // 品牌请求
  void fetchBrandData() async {
    String url = '/dealer.php?m=brand&dealer_id=${widget.id}';
    var result = await HttpUtils.request(url);
    setState(() {
      brandList = result['data'];
    });
  }
  // 车型报价请求
  void fetchCarPriceData() async {
    String url = '/dealer.php?m=price_list&page=1&dealer_id=${widget.id}';
    var result = await HttpUtils.request(url);
    setState(() {
      carPriceList = result['data'];
    });
  }
  // 电话联系
  void _launchURL() async {
    print('联系他');
    String url = 'tel:' + topDetailData['sales'][0]['phone'].toString();
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // 经销商信息
  Widget _topInfoWidget() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(750),
            height: ScreenUtil().setHeight(420),
            child: Image.network(topDetailData['logo'],
                fit: BoxFit.cover,
                height: ScreenUtil().setHeight(420),
                width: ScreenUtil().setWidth(750)),
          ),
          Container(
              width: ScreenUtil().setWidth(750),
              padding: EdgeInsets.only(top: 14, left: 15, right: 15),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      topDetailData['name'],
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1), fontSize: 16.0),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      topDetailData['address'],
                      style: TextStyle(
                          color: Color.fromRGBO(153, 153, 153, 1),
                          fontSize: 12.0),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Image.asset('images/icon/vip.png', fit: BoxFit.cover),
                        SizedBox(
                          width: 5.0,
                        ),
                        Image.asset('images/icon/hz.png', fit: BoxFit.cover),
                        SizedBox(
                          width: 5.0,
                        ),
                        Image.asset('images/icon/zhizhao.png',
                            fit: BoxFit.cover),
                        SizedBox(
                          width: 5.0,
                        ),
                        Image.asset('images/icon/shiming.png',
                            fit: BoxFit.cover)
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 8, bottom: 15),
                      child: Image.asset('images/supSign.jpeg'))
                ],
              )),
          // 分割线
          Container(
            color: Color(0xffeaeaea),
            constraints: BoxConstraints.expand(height: 8.0),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(88),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.title,
                        color: Colors.lightBlue,
                      ),
                      Text('销售顾问')
                    ],
                  ),
                ),
                _getSalePerson()
              ],
            )
          ),
          // 分割线
          Container(
            margin: EdgeInsets.only(top:8),
            color: Color(0xffeaeaea),
            constraints: BoxConstraints.expand(height: 8.0),
          )
        ],
      ),
    );
  }

  // 销售顾问
  Widget _getSalePerson() {
    return topDetailData['sales'].length>0 ? Container(
      // child:ListView.builder(
      //   scrollDirection: Axis.horizontal,
      //   itemCount: topDetailData['sales'].length,
      //   itemBuilder: (BuildContext context, int index) {
      //     return Container(
      //       width: ScreenUtil().setWidth(108),
      //       child: Column(
      //         children: <Widget>[
      //           Flexible(
      //             child: Image.network(topDetailData['sales'][index]['imgurl']),
      //           ),
      //           Flexible(
      //             child: Text(topDetailData['sales'][index]['name']),
      //           ),
      //           RaisedButton(
      //             onPressed: _launchURL,
      //             child: Text('联系他'),
      //           )
      //         ],
      //       ),
      //     );
      //   },
      // )
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                Container(
                  child: Image.network(
                  topDetailData['sales'][0]['imgurl'],
                  fit: BoxFit.cover,
                  height: ScreenUtil().setHeight(128),
                  width: ScreenUtil().setWidth(128),
                )),
                Container(
                  child: Text(topDetailData['sales'][0]['name']),
                ),
                Container(
                  width: ScreenUtil().setWidth(128),
                  height: ScreenUtil().setHeight(40),
                  alignment: Alignment.center,
                  child: RaisedButton(
                    onPressed: _launchURL,
                    child: Text('联系',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0)),
                  color: Colors.lightBlue,
                ))
              ],
            ),
          )
        ],
      )
    ) : Text('暂无顾问');
  }
  // 在售品牌
  Widget _saleBrand() {
    return Container(
      height: ScreenUtil().setHeight(390),
      padding: EdgeInsets.all(3.0),
      child: Column(
        children: <Widget>[
          Container(
            height: ScreenUtil().setHeight(88),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.title,
                  color: Colors.lightBlue,
                ),
                Text('在售品牌')
              ],
            ),
          ),
          Expanded(
            child:Container(
              child:GridView.count(
                //知道数字
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 5, //每行5个
                padding: EdgeInsets.all(5.0),
                children: brandList.map((item) {
                  return InkWell(
                    onTap: () {
                      print('点击了导航');
                    },
                    child: Column(
                      children: <Widget>[
                        Image.network(item['logo'], width: ScreenUtil().setWidth(95)),
                        Text(item['title']), //后台数据
                      ],
                    ),
                  );
                }).toList(), //传过来为List-直接map遍历-接收一个回调
              ),
            )
          )
        ],
      )
    );
  }
  // 车型报价
  Widget _carPrice() {
    return Container(
      padding: EdgeInsets.all(3.0),
      child: Column(
        children: <Widget>[
          Container(
            height: ScreenUtil().setHeight(88),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.title,
                      color: Colors.lightBlue,
                    ),
                    Text('车型报价'),
                  ],
                ),
                InkWell(
                  child: Row(
                    children: <Widget>[
                      Text('更多'),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            child: ListView.builder(
              itemCount: carPriceList.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return _carPriceWidget(context, carPriceList[index]);
              },
            ),
          )
        ],
      ),
    );
  }
  Widget _carPriceWidget(context, item) {
    return InkWell(
      onTap: () {
         Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarDetail(id: item['id']),
          ),
        );
      },
      child:Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Image.network(item['thumb'], fit: BoxFit.cover,width: ScreenUtil().setWidth(250), height: ScreenUtil().setHeight(154)),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: ScreenUtil().setWidth(96),
                          height: ScreenUtil().setHeight(34),
                          color: Colors.orange,
                          alignment: Alignment.center,
                          child: Text('现车', style: TextStyle(color: Colors.white),),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item['title'],
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text(item['source_type'],style: TextStyle(color: Colors.black38, fontSize: 12.0)),
                          Text(item['color'],style: TextStyle(color: Colors.black38, fontSize: 12.0))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(item['createdate'],style: TextStyle(color: Colors.black38, fontSize: 12.0)),
                          Text(item['price'],style: TextStyle(color: Colors.red, fontSize: 14.0))
                        ],
                      )
                    ],
                  )
                )
              ],
            ),
            Container(
              width: ScreenUtil().setWidth(750),
              padding: EdgeInsets.all(3.0),
              margin: EdgeInsets.only(top:10.0),
              color: Color.fromRGBO(242, 242, 242, 1),
              child: Text('${item['desc']}', style: TextStyle(color: Color.fromRGBO(102, 102, 102, 1))),
            )
          ],
        ),
      )
    );}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('经销商详情'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              topDetailData.isNotEmpty ? _topInfoWidget() : Text('正在加载中...'),
              _saleBrand(),
              // 分割线
              Container(
                margin: EdgeInsets.only(top:8),
                color: Color(0xffeaeaea),
                constraints: BoxConstraints.expand(height: 8.0),
              ),
              _carPrice()
            ],
          ),
        ),
      ),
    );
  }
}
