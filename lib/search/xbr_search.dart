import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:xbr_gaode_navi_amap/xbr_gaode_navi_amap.dart';
import '../_core/driving_strategy.dart';
import '../_core/show_fields.dart';
import '../amap/base/amap_flutter_base.dart';
import 'entity/geocoding_result.dart';
import 'entity/input_tip_result.dart';
import 'entity/poi_result.dart';
import 'entity/re_geocoding_result.dart';
import 'entity/route_result.dart';
import 'entity/truck.dart';

typedef InitBack = Function(int? code, bool data);
typedef PoiResultBack = Function(int? code, PoiResult data);
typedef InputTipResultBack = Function(int? code, List<InputTipResult> data);
typedef RouteResultBack = Function(int? code, RouteResult data);
typedef GeocodingResultBack = Function(int? code, GeocodingResult data);
typedef ReGeocodingResultBack = Function(int? code, ReGeocodingResult data);

class XbrSearch {

  static const MethodChannel _channel = XbrGaodeNaviAmap.channel;
  static const Map<String,Function> searchMap = <String,Function> {};

  ///关键词POI
  static Future<void> keywordsSearch({
    required String? keyWord,
    String? cityCode,
    int? page = 1,
    int? limit = 10,
    PoiResultBack? back,
  }) async {
    final String? jsonStr = await _channel.invokeMethod('keywordsSearch', {
      "keyWord": keyWord,
      "cityCode": cityCode,
      "page": page,
      "limit": limit,
    });
    if (jsonStr != null) {
      Map? map = json.decode(jsonStr);
      if (map != null && back != null) {
        back(map['code'] as int, PoiResult.fromJson(map["data"]));
      }
    }
  }

  ///周边POI
  static Future<void> boundSearch({
    required LatLng point,
    String? keyWord,
    int? score = 1000,
    int? page = 1,
    int? limit = 10,
    PoiResultBack? back,
  }) async {
    final String? jsonStr = await _channel.invokeMethod('boundSearch', {
      "pointJson": json.encode(point),
      "score": score,
      "keyWord":keyWord,
      "page": page,
      "limit": limit,
    });
    if (jsonStr != null) {
      Map? map = json.decode(jsonStr);
      if (map != null && back != null) {
        back(map['code'] as int, PoiResult.fromJson(map["data"]));
      }
    }
  }

  ///输入提示
  static Future<void> inputTips({
    required String newText,
    String? city,
    bool cityLimit = false,
    InputTipResultBack? back,
  }) async {
    final String? jsonStr = await _channel.invokeMethod('inputTips', {
      "newText": newText,
      "city": city,
      "cityLimit": cityLimit,
    });
    if (jsonStr != null) {
      Map? map = json.decode(jsonStr);
      if (map != null && back != null) {
        List<InputTipResult> tips = [];
        map["data"].forEach((element) {
          tips.add(InputTipResult.fromJson(element));
        });
        back(map['code'] as int, tips);
      }
    }
  }

  ///POI详情
  static Future<void> getPOIById({
    required String id,
    PoiResultBack? back,
  }) async {
    final String? jsonStr = await _channel.invokeMethod('getPOIById', {
      "id": id,
    });
    if (jsonStr != null) {
      Map? map = json.decode(jsonStr);
      if (map != null && back != null) {
        back(map['code'] as int, PoiResult.fromJson(map["data"]));
      }
    }
  }

  ///线路规划
  static Future<void> routeSearch({
    required List<LatLng> wayPoints,
    int? strategy ,
    int? showFields = ShowFields.POLINE,//ShowFields.
    bool onlyOne = true,
    RouteResultBack? back,
  }) async {
    final String? jsonStr = await _channel.invokeMethod('routeSearch', {
      "wayPointsJson": json.encode(wayPoints),
      "strategy": strategy??DrivingStrategy.DEFAULT,
      "showFields": showFields,
      "onlyOne": onlyOne,
    });
    if (jsonStr != null) {
      Map? map = json.decode(jsonStr);
      if (map != null && back != null) {
        back(map['code'] as int, RouteResult.fromJson(map["data"]));
      }
    }
  }

  ///线路费用计算
  static Future<void> costSearch({
    required List<LatLng> wayPoints,
    int? strategy ,
    bool onlyOne = true,
    RouteResultBack? back,
  }) async {
    final String? jsonStr = await _channel.invokeMethod('costSearch', {
      "wayPointsJson": json.encode(wayPoints),
      "strategy": strategy??DrivingStrategy.DEFAULT,
      "onlyOne": onlyOne,
    });
    if (jsonStr != null) {
      Map? map = json.decode(jsonStr);
      if (map != null && back != null) {
        back(map['code'] as int, RouteResult.fromJson(map["data"]));
      }
    }
  }

  ///线路规划 truck
  static Future<void> truckRouteSearch({
    required List<LatLng> wayPoints,
    int? drivingMode,
    TruckInfo? truckInfo,
    int? showFields = ShowFields.POLINE,//ShowFields.
    bool onlyOne = true,
    RouteResultBack? back,
  }) async {
    final String? jsonStr = await _channel.invokeMethod('truckRouteSearch', {
      "wayPointsJson": json.encode(wayPoints),
      "drivingMode": drivingMode,
      "truckInfoJson": json.encode(truckInfo),
      "showFields": showFields,
      "onlyOne": onlyOne,
    });
    if (jsonStr != null) {
      Map? map = json.decode(jsonStr);
      if (map != null && back != null) {
        back(map['code'] as int, RouteResult.fromJson(map["data"]));
      }
    }
  }

  ///线路费用计算 truck
  static Future<void> truckCostSearch({
    required List<LatLng> wayPoints,
    int? drivingMode,
    TruckInfo? truckInfo,
    bool onlyOne = true,
    RouteResultBack? back,
  }) async {
    final String? jsonStr = await _channel.invokeMethod('truckCostSearch', {
      "wayPointsJson": json.encode(wayPoints),
      "drivingMode": drivingMode,
      "truckInfoJson": json.encode(truckInfo),
      "onlyOne": onlyOne,
    });
    if (jsonStr != null) {
      Map? map = json.decode(jsonStr);
      if (map != null && back != null) {
        back(map['code'] as int, RouteResult.fromJson(map["data"]));
      }
    }
  }

  ///地理编码
  static Future<void> geocoding({
    required String? address,
    String? cityOrAdcode,
    GeocodingResultBack? back,
  }) async {
    final String? jsonStr = await _channel.invokeMethod('geocoding', {
      "address": address,
      "cityOrAdcode": cityOrAdcode,
    });
    if (jsonStr != null) {
      Map? map = json.decode(jsonStr);
      if (map != null && back != null) {
        back(map['code'] as int, GeocodingResult.fromJson(map["data"]));
      }
    }
  }

  ///逆地理编码
  static Future<void> reGeocoding({
    required LatLng? point,
    int? scope,
    ReGeocodingResultBack? back,
  }) async {
    final String? jsonStr = await _channel.invokeMethod('reGeocoding', {
      "pointJson": json.encode(point),
      "scope": scope,
    });
    if (jsonStr != null) {
      Map? map = json.decode(jsonStr);
      if (map != null && back != null) {
        back(map['code'] as int, ReGeocodingResult.fromJson(map["data"]));
      }
    }
  }

}