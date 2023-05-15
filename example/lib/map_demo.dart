import 'package:flutter/material.dart';
import 'package:xbr_gaode_navi_amap/amap/amap_widget.dart';
import 'package:xbr_gaode_navi_amap/amap/base/amap_flutter_base.dart';
import 'package:xbr_gaode_navi_amap/amap/map/src/types/camera.dart';
import 'package:xbr_gaode_navi_amap/amap/map/src/types/ui.dart';

class MapDemoPage extends StatefulWidget {
  const MapDemoPage({Key? key}) : super(key: key);

  @override
  State<MapDemoPage> createState() => _MapDemoPageState();
}

class _MapDemoPageState extends State<MapDemoPage> {
  MapType? mapType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("地图示例"),
      ),
      body: Column(
        children: [
          Expanded(
              child: AmapWidget(
            initCameraPosition: const CameraPosition(target: LatLng(39.993135, 116.474175)),
            mapType: mapType,
          )),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  child: const Text("普通地图"),
                  onPressed: () {
                    setState(() {
                      mapType = MapType.normal;
                    });
                  },
                ),
              ),
              Expanded(
                child: TextButton(
                  child: const Text("导航地图"),
                  onPressed: () {
                    setState(() {
                      mapType = MapType.navi;
                    });
                  },
                ),
              ),
              Expanded(
                child: TextButton(
                  child: const Text("公交线路图"),
                  onPressed: () {
                    setState(() {
                      mapType = MapType.bus;
                    });
                  },
                ),
              ),
              Expanded(
                child: TextButton(
                  child: const Text("夜间地图"),
                  onPressed: () {
                    setState(() {
                      mapType = MapType.night;
                    });
                  },
                ),
              ),
              Expanded(
                child: TextButton(
                  child: const Text("卫星图"),
                  onPressed: () {
                    setState(() {
                      mapType = MapType.satellite;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
