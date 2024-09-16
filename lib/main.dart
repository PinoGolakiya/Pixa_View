import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pixa_view/core/utils/app_strings.dart';
import 'package:pixa_view/screen_view/gallery_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      builder: EasyLoading.init(),
      home: GalleryScreen(),
    );
  }
}
