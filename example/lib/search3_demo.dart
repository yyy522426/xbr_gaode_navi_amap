import 'package:flutter/material.dart';
import 'package:xbr_gaode_navi_amap/amap/amap_widget.dart';
import 'package:xbr_gaode_navi_amap/amap/base/amap_flutter_base.dart';
import 'package:xbr_gaode_navi_amap/amap/core/xbr_ui_controller.dart';
import 'package:xbr_gaode_navi_amap/amap/map/amap_flutter_map.dart';
import 'package:xbr_gaode_navi_amap/amap/map/src/types/camera.dart';
import 'package:xbr_gaode_navi_amap/search/entity/route_result.dart';
import 'package:xbr_gaode_navi_amap/search/utils/search_util.dart';

class Search3DemoPage extends StatefulWidget {
  const Search3DemoPage({Key? key}) : super(key: key);

  @override
  State<Search3DemoPage> createState() => _SearchDemoPageState();
}

class _SearchDemoPageState extends State<Search3DemoPage> {
  List<Path>? result;
  AMapUIController uiController = AMapUIController();
  AMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("綫路规划: 检索示例"),
      ),
      body: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            height: 10,
          ),
          const SizedBox(
            width: double.infinity,
            child: Text("AmapSearchUtil.routePlanning(wayPoints,strategy,back)\n"
                "wayPoints：坐标集合，不低于2个点\n"
                "strategy：策略，DrivingStrategy.DEFAULT，已在DrivingStrategy类中定义\n"
                "back：返回方法(code,data){}\n"
                "\n"
                "本方法理论上支持无限个点，内置自动分页查询，只返回最佳线路坐标导航点，若要返回时间距离请使用："
                "routeCalculate(wayPoints, strategy,calculateBack)，也支持无限个点，但只返回时间。"
                "您也可以直接使用XbrSearch.routeSearch(未分页,不得超过8个点)和XbrSearch.routeSearchPage(可以无限个点)两个方法，"
                "使用 showFields 可以设定返回数据，showFields在ShowFields类中已定义，onlyOne设为true后只返回最优路线"),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child: const Text("开始规划"),
              onPressed: () {
                SearchUtil.routePlanningDraw(
                  itemList: [
                    PlanItem(latLng: const LatLng(26.628053, 106.728491)),
                    PlanItem(latLng: const LatLng(26.641709, 106.618799)),
                    PlanItem(latLng: const LatLng(26.262701, 106.794224)),
                    PlanItem(latLng: const LatLng(26.641709, 106.445064)),
                    PlanItem(latLng: const LatLng(25.91852, 106.618799)),
                    PlanItem(latLng: const LatLng(25.920063, 106.651745)),
                    PlanItem(latLng: const LatLng(25.905858, 106.720409)),
                    PlanItem(latLng: const LatLng(25.83728, 106.5975)),
                    PlanItem(latLng: const LatLng(25.66504, 106.70702)),
                    PlanItem(latLng: const LatLng(25.180703, 106.999531)),
                  ],
                  uiController: uiController,
                  mapController: mapController!,
                );
                // XbrSearch.routeSearch(wayPoints: [const LatLng(26.628053, 106.728491),const LatLng(26.641709, 106.618799)],back: (code,data){
                //   debugPrint(data.paths![0].polyline);
                // });
                // XbrSearch.costSearch(wayPoints: [const LatLng(26.628053, 106.728491),const LatLng(26.641709, 106.618799)],back: (code,data){
                //   debugPrint("${data.paths![0].duration}--${data.paths![0].distance}");
                // });
              },
            ),
          ),
          const SizedBox(
            width: double.infinity,
            height: 10,
          ),
          Expanded(
            child: AmapWidget(
              initCameraPosition: const CameraPosition(target: LatLng(39.993135, 116.474175)),
              uiController: uiController,
              onMapCreated: (controller) {
                mapController = controller;
              },
            ),
          ),
        ],
      ),
    );
  }
}
