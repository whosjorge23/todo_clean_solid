import 'package:flutter/material.dart';

enum MyFontWeight {
  regular,
  bold,
  semiBold,
  medium,
  light,
}

class QuicksandTextStyle {
  TextStyle getQuicksand(MyFontWeight fontWeight) {
    FontWeight? selectedFontWeight;

    switch (fontWeight) {
      case MyFontWeight.regular:
        selectedFontWeight = FontWeight.w400;
        break;
      case MyFontWeight.bold:
        selectedFontWeight = FontWeight.w700;
        break;
      case MyFontWeight.semiBold:
        selectedFontWeight = FontWeight.w600;
        break;
      case MyFontWeight.medium:
        selectedFontWeight = FontWeight.w500;
        break;
      case MyFontWeight.light:
        selectedFontWeight = FontWeight.w300;
        break;
    }

    return TextStyle(
      fontFamily: 'Quicksand',
      fontWeight: selectedFontWeight,
    );
  }
}
