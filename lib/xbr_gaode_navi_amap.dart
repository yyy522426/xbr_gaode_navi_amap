
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:xbr_gaode_navi_amap/amap/xbr_amap.dart';
import 'package:xbr_gaode_navi_amap/location/xbr_location_service.dart';
import 'package:xbr_gaode_navi_amap/navi/xbr_navi.dart';
import 'package:xbr_gaode_navi_amap/search/xbr_search.dart';

class XbrGaodeNaviAmap {
  static const MethodChannel channel = MethodChannel('xbr_gaode_navi_amap');

  static Future<String?> get platformVersion async {
    final String? version = await channel.invokeMethod('getPlatformVersion');
    return version;
  }

  ///初始化KEY
  static Future<void> initKey({required String androidKey, required String iosKey}) async {
    XbrNavi.initKey(androidKey: androidKey, iosKey: iosKey);
  }

  ///隐私合规
  static void updatePrivacy({required bool hasContains, required bool hasShow, required bool hasAgree}) {
    XbrNavi.updatePrivacy(hasContains: hasContains, hasShow: hasShow, hasAgree: hasAgree);
  }

}
