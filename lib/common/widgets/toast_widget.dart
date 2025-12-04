import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShowToastWidget {
  static void show(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT, //makes it last longer
      gravity: ToastGravity.TOP, //position(Top,center,bottom)
      timeInSecForIosWeb: 2, // iOS/Web duration
      backgroundColor: Colors.green.shade600,
      textColor: Colors.white,
      fontSize: 16.h,
    );
  }
}
