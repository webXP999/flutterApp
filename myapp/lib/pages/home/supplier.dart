import 'package:flutter/material.dart';
import 'package:meigui/pages/details/supplier_detail.dart';
import 'package:meigui/request.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class Supplier extends StatefulWidget {
  Supplier({Key key}) : super(key: key);

  _SupplierState createState() => _SupplierState();
}

class _SupplierState extends State<Supplier> {
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  int curPage = 1;
  List supplierData = [];
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerkey =
      new GlobalKey<RefreshFooterState>();

  Future<void> fetchData() async {
    String url = '/dealer.php?m=index&page=$curPage';
    var result = await HttpUtils.request(url);
    setState(() {
      supplierData.addAll(result['data'].isEmpty ? [] : result['data']);
    });
  }

  Widget _supplierWidget(context, item) {
    return Container(
        padding: EdgeInsets.all(5.0),
        child: Column(children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SupplierDetail(id: item['id']),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 60.0,
                  width: 60.0,
                  margin: EdgeInsets.only(top: 6.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5.0),
                    image: DecorationImage(
                      image: NetworkImage(item['thumb']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        item['name'],
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Container(
                        height: 30.0,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: <Widget>[
                            Image.asset('images/icon/vip.png',
                                fit: BoxFit.cover),
                            SizedBox(
                              width: 5.0,
                            ),
                            Image.asset('images/icon/hz.png',
                                fit: BoxFit.cover),
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
                        )),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${item['lastdate']}',
                        style: TextStyle(fontSize: 15.0),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          // 分割线
          Container(
            margin: EdgeInsets.only(top: 4.0),
            color: Color(0xffeaeaea),
            constraints: BoxConstraints.expand(height: 4.0),
          )
        ]));
  }

  @override
  Widget build(BuildContext context) {
    if (supplierData.length > 0) {
      return Container(
          height: 200.0,
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
                    itemCount: supplierData.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return _supplierWidget(context, supplierData[index]);
                    },
                  ),
                  onRefresh: () async {
                    curPage = 1;
                    supplierData = [];
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
