import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meigui/request.dart';

import 'all_car_type.dart';

class BrandInfo extends StatefulWidget {
  BrandInfo({Key key, this.id}) : super(key: key);
  final id;
  _BrandInfoState createState() => _BrandInfoState();
}

class _BrandInfoState extends State<BrandInfo> {
  @override
  void initState() {
    fetchData();
    super.initState();
  }
  List brandList = [];
  Future<void> fetchData() async {
    String url = '/brand.php?m=chexin_list&id=${widget.id}';
    var result = await HttpUtils.request(url);
    setState(() {
      brandList = result['data'];
    });
  }
  Widget _brandWidget(context, item) {
    return Container(
      height: ScreenUtil().setHeight(160),
      padding: EdgeInsets.only(left: 30, right: 30, top: 20),
      child: InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AllCarType(id: item['id']),
            ),
          );
        },
        child:Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(item['thumb'], fit: BoxFit.fill,width: ScreenUtil().setWidth(210)),
            SizedBox(width: 10),
            Container(
              margin: EdgeInsets.only(top: 10),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(item['title'], style: TextStyle(fontSize: 14.0),),
                  Container(
                    height: ScreenUtil().setHeight(30),
                    alignment: Alignment.center,
                    child:Text('${item['price']}万', style: TextStyle(fontSize: 12.0,color: Colors.red))
                  ),
                  Text(item['car_type'], style: TextStyle(fontSize: 10.0,color: Colors.black45),)
                ],
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child:Icon(Icons.keyboard_arrow_right),
              )
            )
          ],
        ),
      ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: brandList.length>0 ? Text(brandList[0]['title']) : Text(''),
      ),
      body: brandList.length>0 ? Container(
        child: ListView.separated(
          itemCount: brandList[0]['chexin_list'].length,
          shrinkWrap: true,
          separatorBuilder: (BuildContext context, int index) => Divider(height: 1,color: Colors.black38),
          itemBuilder: (BuildContext context, int index) {
            return _brandWidget(context, brandList[0]['chexin_list'][index]);
          },
        ),
      ) : Text('正在加载中...'),
    );
  }
}