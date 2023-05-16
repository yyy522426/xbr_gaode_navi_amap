import 'package:flutter/material.dart';
import 'package:xbr_gaode_navi_amap/_core/show_fields.dart';
import '../../_core/driving_strategy.dart';
import '../../amap/amap_widget.dart';
import '../../amap/base/amap_flutter_base.dart';
import '../../amap/core/point_util.dart';
import '../../amap/core/xbr_ui_controller.dart';
import '../../amap/map/amap_flutter_map.dart';
import '../../amap/map/src/types/bitmap.dart';
import '../../amap/map/src/types/camera.dart';
import '../../amap/map/src/types/marker.dart';
import '../../amap/map/src/types/polygon.dart';
import '../../amap/map/src/types/polyline.dart';
import '../../amap/utils/amap_util.dart';
import '../xbr_search.dart';

typedef OnComplete = Function(List<PlanItem> itemList);

///地图查询工具类 再封装
class AmapSearchUtil {

  ///线路规划 一键绘制
  ///不建议使用一键绘制，最好使用线路规划接口获取点位后参考下面自己绘制
  static void routePlanningDraw({
    required List<PlanItem> itemList,
    String? lineImgPath,
    Color? lineColor,
    String? pathlineId,
    required AMapUIController uiController,
    required AMapController mapController,
    OnComplete? onComplete,
  }) {
    List<LatLng> list = [];
    for(int i =0;i<itemList.length;i++){
      list.add(ToMLatLng.from(itemList[i].latLng));
    }
    //线路规划示例
    AmapSearchUtil.routePlanning(
      //最多支持18个点，第一个为起点，最后一个为终点，中间为途径点,
      wayPoints: list,
      callBack: (code, linePoints, bounds) {
        //处理返回码不是1000的逻辑
        if (code != 1000) return;
        //code返回码==1000：成功
        ///绘制规划线
        uiController.savePolyline(pathlineId??"planningLine", Polyline(
          customTexture: lineImgPath!=null?BitmapDescriptor.fromIconPath(lineImgPath):null,
          joinType: JoinType.round,
          capType: CapType.round,
          points: linePoints,
          color: lineColor??Colors.blueAccent,
          width: 6,
        ));
        ///利用MAP控制器移动相机到线路最大可视面积，边距50
        mapController.moveCamera(CameraUpdate.newLatLngBounds(bounds, 50), duration: 1000);
        ///绘制关键点
        for(int i=0;i< itemList.length;i++){
          uiController.saveMarker(itemList[i].markerId??"planningPoint$i", Marker(
            icon: itemList[i].iconPath==null?null:BitmapDescriptor.fromIconPath(itemList[i].iconPath!),
            position: itemList[i].latLng,
            infoWindow: InfoWindow(title: "第${i+1}个")
          ));
          if(itemList[i].showScope){
            ///绘制一个scope米的电子围栏
            uiController.savePolygon(itemList[i].scopeId??"scopePolygon$i", Polygon(
              points: AmapUtil.getCirclePoints(center: itemList[i].latLng, radiusMi: itemList[i].scope),
              joinType: JoinType.round,
              fillColor: Colors.deepOrange.withOpacity(0.4),
              strokeColor: Colors.cyan.withOpacity(0.6),
              strokeWidth: 1,
            ));
          }
          if(i > 0 && itemList[i].showConnecting){
            ///绘制一条方向线 起终点连线
            uiController.savePolyline(itemList[i].conineId??"connectingLine$i", Polyline(
              joinType: JoinType.round,
              capType: CapType.round,
              points: [itemList[i-1].latLng, itemList[i].latLng],
              color: Colors.red,
              width: 1,
            ));
          }
        }
        ///绘制结束，刷新UI
        uiController.refreshUI();
        if(onComplete!=null) onComplete(itemList);
      },
    );
  }

  // 线路规划
  static void routePlanning({required List<LatLng> wayPoints, int? strategy, PlanningCallBack? callBack}) {
    if (wayPoints.length < 2) return;
    XbrSearch.routeSearchPage(
      wayPoints: wayPoints,
      strategy: strategy ?? DrivingStrategy.DEFAULT,
      showFields: ShowFields.POLINE,
      back: (code, data) {
        if (code != 1000) {
          ToLatLng southwest, northeast;
          if (wayPoints[0].latitude < wayPoints[0].latitude) {
            southwest = ToLatLng.from(wayPoints[0]);
            northeast = ToLatLng.from(wayPoints[1]);
          } else {
            southwest = ToLatLng.from(wayPoints[1]);
            northeast = ToLatLng.from(wayPoints[0]);
          }
          if (callBack != null) callBack((code), [], LatLngBounds(southwest: southwest, northeast: northeast));
          return;
        }
        if(data.paths==null|| data.paths!.isEmpty) return;
        List<LatLng> points = PointUtil.listCover(data.paths![0].polyline);
        if (callBack != null) {
          callBack(1000, points, PointUtil.lineBounds(points));
        }
      },
    );
  }

  // 线路計算
  static void routeCalculate({required List<LatLng> wayPoints, int? strategy, CalculateCallBack? calculateBack}) {
    XbrSearch.routeSearchPage(
      wayPoints: wayPoints,
      strategy: strategy ?? DrivingStrategy.DEFAULT,
      showFields: ShowFields.COST,
      back: (code, data) {
        if (code != 1000) return;
        if(data.paths==null|| data.paths!.isEmpty) return;
        if(calculateBack != null){
          calculateBack(data.paths![0].distance?.toInt()??0,data.paths![0].duration?.toInt()??0);
        }
      },
    );
  }
}


class PlanItem {
  final LatLng latLng;
  final String? iconPath;
  final bool showScope;
  final double scope;
  final bool showConnecting;

  final String? markerId;
  final String? scopeId;
  final String? conineId;

  PlanItem({
    required this.latLng,
    this.iconPath,
    this.showScope = false,
    this.scope = 300,
    this.showConnecting = false,
    this.markerId,
    this.scopeId,
    this.conineId,
  });
}
