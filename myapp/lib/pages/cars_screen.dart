import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meigui/pages/brand/all_brand.dart';
import 'package:meigui/pages/brand/all_car_type.dart';
import 'package:meigui/pages/brand/brand_info.dart';
import 'package:meigui/request.dart';
import 'package:meigui/widgets/banner.dart';

class CarsScreen extends StatefulWidget {
  CarsScreen({Key key}) : super(key: key);

  _CarsScreenState createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  @override
  void initState() {
    fetchBanner();
    fetchBrandData();
    fetchCarData();
    fetchBrandCarData();
    super.initState();
  }
  List urls = [];
  List brandList = [];
  List carList = [];
  List brandCarList = [];
  // banner
  Future<void> fetchBanner() async {
    String url = '/index.php?m=banner';
    var result = await HttpUtils.request(url);
    setState(() {
      urls = result['data'];
    });
  }

  // 品牌请求
  void fetchBrandData() async {
    String url = '/car.php?m=brand';
    var result = await HttpUtils.request(url);
    setState(() {
      brandList = result;
    });
  }

  // 热门车型请求
  void fetchCarData() async {
    String url = '/car.php?m=hot_car';
    var result = await HttpUtils.request(url);
    setState(() {
      carList = result;
    });
  }

  // 品牌车系请求
  void fetchBrandCarData() async {
    String url = '/car.php?m=brand_car';
    var result = await HttpUtils.request(url);
    setState(() {
      brandCarList = result['data'];
    });
  }
  // 热门品牌
  Widget _saleBrand() {
    return Container(
      height: ScreenUtil().setHeight(380),
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
                    Text('热门品牌'),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllBrand(),
                      ),
                    );
                  },
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BrandInfo(id: item['id']),
                        ),
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        Image.network(item['brand0_logo'], width: ScreenUtil().setWidth(80)),
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

  // 热门车型
  Widget _hotCars() {
    return Container(
      height: ScreenUtil().setHeight(410),
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
                    Text('热门车型'),
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
          Expanded(
            child:Container(
              child:GridView.count(
                //知道数字
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4, //每行4个
                padding: EdgeInsets.all(5.0),
                children: carList.map((item) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllCarType(id: item['id']),
                        ),
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        Image.network(item['brand2_img1'], width: ScreenUtil().setWidth(80), height: ScreenUtil().setHeight(80)),
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
 // 热门品牌车系
 Widget _brandCarList() {
   if(brandCarList.length >0) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: brandCarList.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index){
          return _brandCarWidget(context, brandCarList[index]);
        },
      )
    );
   }else{
     return Text('');
   }
 }
 Widget _brandCarWidget(context, item) {
   return Container(
    margin: EdgeInsets.only(left:5.0,right:5.0),
    child: Column(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(750),
            height: ScreenUtil().setHeight(72),
            padding: EdgeInsets.only(left:6.0),
            alignment: Alignment.centerLeft,
            color: Colors.black12,
            child: Text(item['title'],style: TextStyle(fontSize: 14.0)),
          ),
          Container(
            child: SizedBox(
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                itemCount: item['chexin_list'].length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index){
                  return _brandCarDetail(context, item['chexin_list'][index]);
                },
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black26,
                ),
              ),
            )
          )
        ],
      ),
   );
 }
 Widget _brandCarDetail(context, item) {
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllCarType(id: item['id']),
          ),
        );
      },
      child:Container(
        height: ScreenUtil().setHeight(150),
        child: Row(
          children: <Widget>[
            Image.network(item['thumb'], fit: BoxFit.cover, width: ScreenUtil().setWidth(210)),
            SizedBox(
              width: 10.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top:8),
                    child:Text(item['title']),
                  ),
                ),
                Expanded(
                  child:Text('${item['price']}万',style: TextStyle(color:Colors.red),),
                ),
                Expanded(
                  child:Text(item['car_type'],style: TextStyle(color: Colors.black38,fontSize: 12.0),),
                )
              ],
            )
          ],
        ),
      )
    );
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('美规之家')
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              HomeBanner(urls: urls),
              _saleBrand(),
              // 分割线
              Container(
                margin: EdgeInsets.only(top:8),
                color: Color(0xffeaeaea),
                constraints: BoxConstraints.expand(height: 8.0),
              ),
              _hotCars(),
              Container(// 分割线
                margin: EdgeInsets.only(top:8),
                color: Color(0xffeaeaea),
                constraints: BoxConstraints.expand(height: 8.0),
              ),
             _brandCarList()
            ],
          ),
        ),
      ),
    );
  }
}

class $ {
}