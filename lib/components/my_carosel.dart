import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:topup_shop/constants.dart';

Container customCarosel(Size size) {
  return Container(
    alignment: Alignment.topCenter,
    width: size.width > 850 ? size.width * .62 : size.width,
    decoration:
        BoxDecoration(border: Border.all(color: Colors.orange, width: 2)),
    child: CarouselSlider(
      options: CarouselOptions(
        viewportFraction: 1,
        enableInfiniteScroll: false,
        height: 350,
        autoPlay: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 2000),
      ),
      items: caroselImages.map((image) {
        return Builder(
          builder: (BuildContext context) {
            return Image.asset(
              image,
              width: 1000,
              fit: BoxFit.fill,
            );
          },
        );
      }).toList(),
    ),
  );
}
