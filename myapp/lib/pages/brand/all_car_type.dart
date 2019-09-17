import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meigui/pages/details/car_detail.dart';
import 'package:meigui/pages/details/supplier_detail.dart';
import 'package:meigui/request.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
class AllCarType extends StatefulWidget {
  AllCarType({Key key, this.id}) : super(key: key);
  final id;
  _AllCarTypeState createState() => _AllCarTypeState();
}

class _AllCarTypeState extends State<AllCarType> with SingleTickerProviderStateMixin {
  var iconType = Icons.arrow_drop_up;
  bool isMask = false; //下拉蒙层是否显示
  List carPriceList = [];
  List carTypeList = [];
  String carTypeTitle = '全部车型';
  @override
  void initState() {
    fetchcarPriceList();
    fetchcarTypeList();
    super.initState();
  }
  int curPage = 1;
  String modelId = '';
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerkey =
      new GlobalKey<RefreshFooterState>();
  // 车型报价列表请求
  Future<void> fetchcarPriceList() async {
    String url = '/price.php?m=plist&dealer_id=&brand_id=${widget.id}&model_id=$modelId&page=$curPage';
    var result = await HttpUtils.request(url);
    setState(() {
      carPriceList.addAll(result['data'].isEmpty ? [] : result['data']);
    });
  }
  // 车型列表请求
  Future<void> fetchcarTypeList() async {
    String url = '/brand.php?m=car_list&chexi_id=${widget.id}';
    var result = await HttpUtils.request(url);
    setState(() {
      carTypeList = result['data'];
    });
  }
  void triggerMask () {
    setState(() {
      iconType = iconType == Icons.arrow_drop_up ? Icons.arrow_drop_down : Icons.arrow_drop_up;
      isMask = !isMask;
    });
  }
  // 具体车型
  Widget _carTypeDetail(context, item) {
    return InkWell(
      onTap: () {
        setState(() {
          carTypeTitle = item['title'];
          modelId = item['id'].toString();
          curPage = 1;
          carPriceList = [];
        });
        triggerMask();
        fetchcarPriceList();
      },
      child:Container(
        height: ScreenUtil().setHeight(100),
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 15.0,right: 15.0,top: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(item['title'], style: TextStyle(fontSize: 14.0,color: carTypeTitle==item['title']?Colors.red:Colors.black),),
            Container(
              width: ScreenUtil().setWidth(74),
              height: ScreenUtil().setHeight(36),
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 10.0),
              color: Colors.black12,
              child: Text(item['type'],style: TextStyle(color: Colors.black54),),
            )
          ],
        )
      )
    );
  }
  // 浮层里面的内容
  Widget _carTypeListWidget(context, item) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: ScreenUtil().setHeight(72),
            alignment: Alignment.centerLeft,
            color: Colors.black12,
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
            child: Text(item['niankuan'].toString()),
          ),
          Container(
            child: item['list'].length>0 ?ListView.separated(
              itemCount: item['list'].length,
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) => Divider(height: 1,color: Colors.black26,),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return _carTypeDetail(context, item['list'][index]);
              },
            ): Text('暂无数据'),
          )
        ],
      ),
    );
  }
  // 点击出现的浮层
  Widget _carTypeWidget() {
    if(iconType == Icons.arrow_drop_down) {
       return Positioned(
          width:  MediaQuery.of(context).size.width,
          top: ScreenUtil().setHeight(90),
          left: 0,
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    carTypeTitle = '全部车型';
                    modelId = '';
                    curPage = 1;
                    carPriceList = [];
                  });
                  triggerMask();
                  fetchcarPriceList();
                },
                child: Container(
                  height: ScreenUtil().setHeight(88),
                  alignment: Alignment.centerLeft,
                  padding:EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                  color: Colors.white,
                  child: Text('全部车型',style: TextStyle(color: carTypeTitle=='全部车型'?Colors.red:Colors.black),),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                height: ScreenUtil().setHeight(600),
                child: carTypeList.length >0 ? ListView.builder(
                  itemCount: carTypeList.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return _carTypeListWidget(context, carTypeList[index]);
                  },
                ):Text('暂无数据')
              ),
              _mask()
            ],
          )
          
      );
    }else{
      return Container(height: 0,);
    }
  }
  //筛选的黑色蒙层
  Widget _mask() {
    if(isMask) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color.fromRGBO(0, 0, 0, 0.5),
      );
    } else {
      return Container( 
        height: 0,
      );
    }
  }
  // 车型报价列表
  Widget _carPriceWidget(context, item) {
    return carPriceList.length>0 ? Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          child: InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarDetail(id: item['id']),
                ),
              );
            },
            child:Column(
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
          )),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SupplierDetail(id: item['dealer_id']),
                ),
              );
            },
            child:Container(
              height: ScreenUtil().setHeight(76),
              padding: EdgeInsets.only(left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(item['dealer_name']),
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
                          fit: BoxFit.cover),
                    ],
                  ),
                  Icon(Icons.keyboard_arrow_right, color: Colors.black38,)
                ],
              ),
            )
          )
        ],
      ) : Text('正在加载中...');
      // Container(
      //   SizedBox(
      //     height: 20,
      //     width: 20,
      //     child:CircularProgressIndicator(backgroundColor: Colors.lightBlue)
      //   )
      // );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('美规之家'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                   triggerMask();
                  },
                  child:Container(
                    height: ScreenUtil().setHeight(88),
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(carTypeTitle, style: TextStyle(color: Colors.red),),
                        Icon(iconType)
                      ],
                    ),
                  ),
                ),
                Divider(height: ScreenUtil().setHeight(2),color: Colors.black26,),
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
                      itemCount: carPriceList.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return _carPriceWidget(context, carPriceList[index]);
                      },
                    ),
                    onRefresh: () async {
                      curPage = 1;
                      carPriceList = [];
                      await fetchcarPriceList();
                    },
                    loadMore: () async {
                      curPage++;
                      await fetchcarPriceList();
                    },
                  ),
                )
              ],
            ),
          ),
          _carTypeWidget()
        ],
      )
    );
  }
}

  