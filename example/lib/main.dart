import 'package:flutter/material.dart';
import 'package:xbr_gaode_navi_amap/amap/base/amap_flutter_base.dart';
import 'package:xbr_gaode_navi_amap/location/xbr_location_service.dart';
import 'package:xbr_gaode_navi_amap/navi/xbr_navi.dart';
import 'package:xbr_gaode_navi_amap/xbr_gaode_navi_amap.dart';
import 'package:xbr_gaode_navi_amap_example/search2_demo.dart';
import 'package:xbr_gaode_navi_amap_example/search3_demo.dart';
import 'package:xbr_gaode_navi_amap_example/search_demo.dart';

import 'map_demo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    XbrGaodeNaviAmap.initKey(androidKey: "e3af18fff0b5be1a07f4160e0fa6365f", iosKey: "6576199a6c246345e57fee50d2edc8d1");
    XbrGaodeNaviAmap.updatePrivacy(hasContains: true, hasShow: true, hasAgree: true);
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String text = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('高德全套服务集成'),
      ),
      body: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: const [
                  SizedBox(
                    width: double.infinity,
                    child: Text("* 本插件包含高德套件：高德地图、高德定位、高德检索、高德导航 四个产品，采用高德导航合包，包本身体积较大，"
                        "若没有导航需求，建议使用 xbr_gaode_amap、xbr_gaode_search、xbr_gaode_location 单产品，因为高德只提供合包，"
                        "导航包无法和其他包拆分，使用导航时必须同时提供其他套件，从而衍生此包, 此包除了新增导航外，其他部分与单产品一模一样。"),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const SizedBox(
                    width: double.infinity,
                    child: Text("地图部分"),
                  ),
                  ElevatedButton(
                      child: const Text("显示地图"),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MapDemoPage()));
                      })
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const SizedBox(
                    width: double.infinity,
                    child: Text("检索部分"),
                  ),
                  Wrap(
                    spacing: 5, //主轴上子控件的间距
                    runSpacing: 5, //交叉轴上子控件之间的间距
                    children: [
                      ElevatedButton(
                          child: const Text("关键字"),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchDemoPage()));
                          }),
                      ElevatedButton(
                          child: const Text("周边"),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const Search2DemoPage()));
                          }),
                      ElevatedButton(child: const Text("线路规划"), onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Search3DemoPage()));
                      })
                    ], //要显示的子控件集合
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const SizedBox(
                    width: double.infinity,
                    child: Text("定位部分"),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(text),
                  ),
                  Wrap(
                    spacing: 5, //主轴上子控件的间距
                    runSpacing: 5, //交叉轴上子控件之间的间距
                    children: [
                      ElevatedButton(
                          child: const Text("获取定位"),
                          onPressed: () {
                            XbrLocation.instance().execOnceLocation(callback: (locationInfo) {
                              setState(() {
                                text = locationInfo.toJson().toString();
                              });
                            });
                          }),
                      ElevatedButton(child: const Text("实时定位"), onPressed: () {}),
                      ElevatedButton(child: const Text("后台地位（新）"), onPressed: () {}),
                    ], //要显示的子控件集合
                  ),
                  const SizedBox(
                    width: double.infinity,
                    child: Text("本插件支持后台保活定位，你可以摒弃高德提供的猎鹰终端SDK（坑特别多且不支持保活），您可以在自己服务端配置好猎鹰服务接口，提供轨迹上传接口，"
                        "然后使用本插件定时采集后定时上传（定时采集到的点先保存到设备本地，每隔几分钟上传一次，建议平均20个点上传一次，这样，你依然可以使用猎鹰服务的轨迹分析功能），"
                        "保活定位原理：在安卓端采用双服务拉活机制，定位服务被杀死后，保活服务会重新唤起定位服务，若定位服务存在，但因某些原因（如安卓后台自动切换低功耗、省电模式下、"
                        "未在电池优化白名单等）获取不到定位信息，则保活服务可能会通过唤醒屏幕方式重新获取定位，所以：必需使用后台定位场景下还是建议引导用户去开启”电池优化白名单“。"
                        "或者直接和手机厂商合作。IOS端无需保活，直接在Xcode添加后台定位功能即可（上线APP需联系客服说明使用后台定位服务的原因，否则APP上架不通过）"),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const SizedBox(
                    width: double.infinity,
                    child: Text("导航部分"),
                  ),
                  ElevatedButton(
                      child: const Text("开始导航"),
                      onPressed: () {
                        XbrNavi.startNavi(points: [
                          // //为了方便展示,选择了固定的起终点
                          //     self.startPoint = [AMapNaviPoint locationWithLatitude:39.993135 longitude:116.474175];
                          //     self.endPoint   = [AMapNaviPoint locationWithLatitude:39.908791 longitude:116.321257];
                          const LatLng(39.993135, 116.474175), const LatLng(39.908791, 116.321257),
                        ], title: "正在前往：基本上界面所有元素都有对应的资源样式和图片，所以大家只需要按照给定的", subtext: "李欣 | 18744925565", emulator: true);
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
