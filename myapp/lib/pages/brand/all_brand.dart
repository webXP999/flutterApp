import 'package:flutter/material.dart';
import 'package:meigui/request.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'brand_info.dart';

class AllBrand extends StatefulWidget {
  AllBrand({Key key}) : super(key: key);

  _AllBrandState createState() => _AllBrandState();
}

class _AllBrandState extends State<AllBrand> {
  List brandList = [];
  @override
  void initState() {
    fetchBrandData();
    super.initState();
  }

  // 品牌请求
  void fetchBrandData() async {
    String url = '/car.php?m=brand&more=1';
    var result = await HttpUtils.request(url);
    setState(() {
      brandList = result;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('品牌分类'),
      ),
      body: brandList.length > 0 ?
        Container(
          child: GridView.count(
            crossAxisCount: 4, //每行5个
            padding: EdgeInsets.all(5.0),
            children: brandList.map((item) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BrandInfo(id: item['id']),
                    ),
                  );
                },
                child: Column(
                  children: <Widget>[
                    Image.network(item['brand0_logo'], width: ScreenUtil().setWidth(95)),
                    Text(item['title']), //后台数据
                  ],
                ),
              );
            }).toList(), 
          ),
      ) : Text('加载中'),
    );
  }
}