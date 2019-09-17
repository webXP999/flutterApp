
import 'package:flutter/material.dart';
import 'package:meigui/pages/details/supplier_detail.dart';
// import 'package:meigui/pages/brand/all_car_type.dart';
import 'package:meigui/widgets/banner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meigui/request.dart';

class CarDetail extends StatefulWidget {
  CarDetail({Key key, this.id}) : super(key: key);
  final id;
  _CarDetailState createState() => _CarDetailState();
}

class _CarDetailState extends State<CarDetail> {
  @override
  void initState() {
    fetchData();
    fetchSaleList();
    super.initState();
  }
  Map detailData = {};
  List saleList = [];
  Future<void> fetchData() async {
    String url = '/price.php?m=detail&id=${widget.id}';
    var result = await HttpUtils.request(url);
    setState(() {
      detailData = result['data'];
    });
  }
  Future<void> fetchSaleList() async {
    String url = '/price.php?m=dealer_recommend&id=${widget.id}';
    var result = await HttpUtils.request(url);
    setState(() {
      saleList = result['data'];
    });
  }
  // carInfo
  Widget _carInfo() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(42),
                  alignment: Alignment.centerLeft,
                  child:Text(detailData['title'], style: TextStyle(fontSize: 16.0)),
                ),
                Container(
                  margin: EdgeInsets.only(top:5,bottom: 5),
                  child: Text('${detailData['source_status']}/${detailData['source_type']}', style: TextStyle(fontSize: 12.0,color: Colors.black38)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(detailData['price'], style: TextStyle(fontSize: 16.0, color: Colors.red),),
                    Text('发布日期：${detailData['createdate']}', style: TextStyle(fontSize: 12.0, color: Colors.black38),)
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(82),
            padding: EdgeInsets.only(left: 10),
            color: Color.fromRGBO(47, 161, 213, 0.2),
            child: Row(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(120),
                  height: ScreenUtil().setHeight(38),
                  alignment: Alignment.center,
                  color: Colors.lightBlue,
                  margin: EdgeInsets.only(right: 5),
                  child: Text('外观内饰', style: TextStyle(color: Colors.white),),
                ),
                Text(detailData['color'], style: TextStyle(color: Colors.lightBlue),)
              ],
            ),
          ),
          // 分割线
          Container(
            color: Color(0xffeaeaea),
            constraints: BoxConstraints.expand(height: ScreenUtil().setHeight(12)),
          ),
          Container(
            height: ScreenUtil().setHeight(88),
            child: Row(
              children: <Widget>[
                Container(
                  color: Colors.lightBlue,
                  margin: EdgeInsets.only(left: 10,right: 5),
                  constraints: BoxConstraints.expand(height: ScreenUtil().setHeight(27),width: ScreenUtil().setWidth(6)),
                ),
                Text('车源信息', style: TextStyle(fontWeight: FontWeight.bold),)
              ],
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(88),
            padding: EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                Text('车源所在地',style: TextStyle(color: Colors.black54),),
                Container(
                  margin: EdgeInsets.only(left: 30),
                  child: Text('天津港', style: TextStyle(fontSize: 16),),
                )
              ],
            ),
          ),
          // 分割线
          Container(
            color: Color(0xffeaeaea),
            constraints: BoxConstraints.expand(height: ScreenUtil().setHeight(12)),
          ),
          Container(
            padding: EdgeInsets.only(left: 10,right: 10),
            child: Column(
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(88),
                  child:Row(
                    children: <Widget>[
                      Container(
                        color: Colors.lightBlue,
                        margin: EdgeInsets.only(right: 5),
                        constraints: BoxConstraints.expand(height: ScreenUtil().setHeight(27),width: ScreenUtil().setWidth(6)),
                      ),
                      Text('车型配置', style: TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
                Divider(
                  height: ScreenUtil().setHeight(2),
                  indent: 0.0,
                  color: Colors.black12,
                ),
              ],
            )
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(detailData['car_config'],style: TextStyle(fontSize: 14),),
          ),
          // 分割线
          Container(
            color: Color(0xffeaeaea),
            constraints: BoxConstraints.expand(height: ScreenUtil().setHeight(12)),
          ),
          Container(
            height: ScreenUtil().setHeight(158),
            padding:EdgeInsets.only(left: 10, right: 10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SupplierDetail(id: detailData['dealer_id']),
                  ),
                );
              },
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child:Image.network(detailData['dealer_logo'],width: ScreenUtil().setWidth(100),height: ScreenUtil().setHeight(100),),
                      ),
                      Text(detailData['dealer_name']),
                    ],
                  ),
                  Icon(Icons.keyboard_arrow_right, color: Colors.black38,)
                ],
              ),
            )
          ),
          // 分割线
          Container(
            color: Color(0xffeaeaea),
            constraints: BoxConstraints.expand(height: ScreenUtil().setHeight(12)),
          )
        ],
      ),
    );
  }
  // 同店在售
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
                // InkWell(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => AllCarType(id: ''),
                //       ),
                //     );
                //   },
                //   child: Row(
                //     children: <Widget>[
                //       Text('更多'),
                //       Icon(
                //         Icons.keyboard_arrow_right,
                //         color: Colors.black45,
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
          Container(
            child: ListView.builder(
              itemCount: saleList.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return _carPriceWidget(context, saleList[index]);
              },
            ),
          )
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('美规之家'),
      ),
      body: detailData.isNotEmpty ? Container(
        child: SingleChildScrollView(
          child:Column(
            children: <Widget>[
              HomeBanner(urls: detailData['imgs']),
              _carInfo(),
              _carPrice()
            ],
          ),
        )
      ) : Center(
        child: Text('正在加载中'),
      ),
    );
  }
}