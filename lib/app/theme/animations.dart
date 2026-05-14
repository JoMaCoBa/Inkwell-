import 'package:flutter/material.dart';

class InkwellAnimations {
  static const fast   = Duration(milliseconds: 200);
  static const normal = Duration(milliseconds: 350);
  static const slow   = Duration(milliseconds: 600);
  static const splash = Duration(milliseconds: 1800);

  static const springy = Curves.elasticOut;
  static const snappy  = Curves.easeOutExpo;
  static const smooth  = Curves.easeInOutCubic;

  static Duration stagger(int index) =>
      Duration(milliseconds: 80 + (index * 40));
}
