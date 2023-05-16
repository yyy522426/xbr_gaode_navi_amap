import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:xbr_gaode_navi_amap/xbr_gaode_navi_amap.dart';
import 'dart:math' as math;

import '../_core/driving_strategy.dart';
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

  /// 最多支持6个途经点，8个一页
  static Future<void> routeSearchPage({
    required List<LatLng> wayPoints,
    int? strategy,
    int? showFields,//ShowFields.
    RouteResultBack? back,
  }) async {
    if(wayPoints.length<2) return;
    int pageLimit = 7; // 最大6个途经点即8个点，预留上一个连接点，正好每页7个
    //int totalPage = wayPoints.length % pageLimit;//总页数
    //需要采集的数据，分页只返回一條綫路
    List<String> polylineList = [];
    num distance = 0;
    num duration = 0;
    //开始分页采集
    nextPage(page,limit) async {
      List<LatLng> pagePoints = paging<LatLng>(wayPoints, page, pageLimit);
      if(pagePoints.isEmpty){
        if(back!=null) back(1000,RouteResult(paths: [Path(polyline:polylineList.join(";"),distance: distance,duration: duration)]));
        return;
      }
      if(page>1) pagePoints.insert(0,pagingLast<LatLng>(wayPoints, page-1, pageLimit));//加入上一页的最后一个点，插在首位
      await routeSearch(wayPoints:pagePoints,strategy:strategy,showFields:showFields, back:(int? code, RouteResult data){
        if(code != 1000) {
          if(back!=null) back(code,data);//只要有一页报错，线路中断，就不要继续了
          return;
        }
        if(data.paths==null || data.paths!.isEmpty) {
          nextPage(page+1, pageLimit);
          return;
        }
        List<String>? pointStr = data.paths?[0].polyline?.split(";");
        if(pointStr!=null) polylineList.addAll(pointStr);
        duration += data.paths?[0].duration??0;
        distance += data.paths?[0].distance??0;
        nextPage(page+1, pageLimit);
      });
    }
    nextPage(1,pageLimit);
  }

  ///线路规划
  static Future<void> routeSearch({
    required List<LatLng> wayPoints,
    int? strategy ,
    int? showFields,//ShowFields.
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

  /// 最多支持6个途经点，8个一页
  static Future<void> truckRouteSearchPage({
    required List<LatLng> wayPoints,
    int? drivingMode,
    TruckInfo? truckInfo,
    int? showFields,//ShowFields.
    RouteResultBack? back,
  }) async {
    if(wayPoints.length<2) return;
    int pageLimit = 7; // 最大6个途经点即8个点，预留上一个连接点，正好每页7个
    //int totalPage = wayPoints.length % pageLimit;//总页数
    //需要采集的数据，分页只返回一條綫路
    List<String> polylineList = [];
    num distance = 0;
    num duration = 0;
    //开始分页采集
    nextPage(page,limit) async {
      List<LatLng> pagePoints = paging<LatLng>(wayPoints, page, pageLimit);
      if(pagePoints.isEmpty){
        if(back!=null) back(1000,RouteResult(paths: [Path(polyline:polylineList.join(";"),distance: distance,duration: duration)]));
        return;
      }
      if(page>1) pagePoints.insert(0,pagingLast<LatLng>(wayPoints, page-1, pageLimit));//加入上一页的最后一个点，插在首位
      await truckRouteSearch(wayPoints:pagePoints,drivingMode:drivingMode,showFields:showFields,truckInfo:truckInfo, back:(int? code, RouteResult data){
        if(code != 1000) {
          if(back!=null) back(code,data);//只要有一页报错，线路中断，就不要继续了
          return;
        }
        if(data.paths==null || data.paths!.isEmpty) {
          nextPage(page+1, pageLimit);
          return;
        }
        List<String>? pointStr = data.paths?[0].polyline?.split(";");
        if(pointStr!=null) polylineList.addAll(pointStr);
        duration += data.paths?[0].duration??0;
        distance += data.paths?[0].distance??0;
        nextPage(page+1, pageLimit);
      });
    }
    nextPage(1,pageLimit);
  }

  ///线路规划 truck
  static Future<void> truckRouteSearch({
    required List<LatLng> wayPoints,
    int? drivingMode,
    TruckInfo? truckInfo,
    int? showFields,//ShowFields.
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

  /// 分页page 1 开始
  static List<T> paging<T>(List<T> list, int page, int limit) {
    List<T> listSort = [];
    int size = list.length;
    int pageStart = page == 1 ? 0 : (page - 1) * limit;//截取的开始位置
    int pageEnd = math.min(size, page * limit);//截取的结束位置
    if (size > pageStart) listSort = list.sublist(pageStart, pageEnd);
    return listSort;
  }

  static T pagingLast<T>(List<T> list, int page, int limit) {
    var pagingList = paging<T>(list, page, limit);
    return pagingList.last;
  }

}