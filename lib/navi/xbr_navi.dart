import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:xbr_gaode_navi_amap/xbr_gaode_navi_amap.dart';

import '../amap/base/amap_flutter_base.dart';

class XbrNavi {

  static const MethodChannel _channel = XbrGaodeNaviAmap.channel;

  /// title：标题，仅android有效
  /// subtext：标题，仅android有效
  /// points：导航点 第一个为起点，最后一个终点，中间为途经点，长度不能小于2
  /// strategy：规划策略
  /// emulator：虚拟导航
  static Future<void> startNavi({String? title,String? subtext, required List<LatLng> points, int? strategy = 0, bool? emulator = false}) async {
    if(points.length<2) return ;
    await _channel.invokeMethod('startNavi', {
      "title": title,
      "subtext":subtext,
      "pointsJson": json.encode(points),
      "strategy": strategy,
      "emulator": emulator,
    });
  }
}