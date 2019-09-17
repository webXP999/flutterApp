// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 轮播图组件


// class HomeBanner extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // color: Colors.white,
//       child: CarouselSlider(
//         height: ScreenUtil().setHeight(333),
//         items: urls.map((url) {
//           return Builder(
//             builder: (BuildContext context) {
//               return Container(
//                 width: MediaQuery.of(context).size.width,
//                 // margin: EdgeInsets.symmetric(horizontal: 5.0),
//                 child: Image.network(
//                   url,
//                   fit: BoxFit.fill,
//                 ),
//               );
//             },
//           );
//         }).toList(),
//         aspectRatio: MediaQuery.of(context).size.aspectRatio,
//         autoPlayInterval: const Duration(seconds: 5),
//         autoPlay: true,
//         viewportFraction: 1.0,
//       ),
//     );
//   }
// }
class HomeBanner extends StatelessWidget {
  const HomeBanner({Key key, this.urls}) : super(key: key);
  final List urls;
  @override
  Widget build(BuildContext context) {
    if(urls.length > 0) {
      return Container(
        height: ScreenUtil().setHeight(333),
        width: ScreenUtil().setWidth(750),
        child: Swiper(
          itemBuilder: (BuildContext context, int index){
            // return Image.network(urls[index]['thumb'] ?? urls[index]['img'], fit: BoxFit.fill);
            return Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(5.0),
                image: DecorationImage(
                  image: NetworkImage(urls[index]['thumb'] ?? urls[index]['img']),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
          itemCount: urls.length,
          autoplay: true,
          // pagination: SwiperPagination(),
          // control: new SwiperControl(),
        ),
      );
    }else{
      return Text('正在加载中...');
    }
  }
}
