import 'package:flutter/material.dart';
import 'package:xbr_gaode_navi_amap/amap/base/amap_flutter_base.dart';
import 'dart:math' as math;
import 'package:xbr_gaode_navi_amap/search/entity/poi_result.dart';
import 'package:xbr_gaode_navi_amap/search/xbr_search.dart';

class Search2DemoPage extends StatefulWidget {
  const Search2DemoPage({Key? key}) : super(key: key);

  @override
  State<Search2DemoPage> createState() => _Search2DemoPageState();
}

class _Search2DemoPageState extends State<Search2DemoPage> {
  List<Pois>? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("周边: 检索示例"),
      ),
      body: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            height: 10,
          ),
          const SizedBox(
            width: double.infinity,
            child: Text("XbrSearch.boundSearch(point,score,page,limit,back)\n"
                "point:检索中心点\n"
                "score:检索范围（米）\n"
                "page:分页，从1开始\n"
                "limit:每页显示数量\n"
                "back:返回方法(code,data){}\n"),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child: const Text("中心检索: LatLng(39.993135,116.474175)"),
              onPressed: () {
                XbrSearch.boundSearch(
                  point: const LatLng(39.993135,116.474175),
                  page: 1,
                  limit: 999,
                  back: (code, data) {
                    setState(() {
                      result = data.pois;
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(
            width: double.infinity,
            height: 30,
          ),
          Expanded(
            child: ListView(
              children: _buildList(),
            )
          ),
        ],
      ),
    );
  }
  _buildList(){
    List<Widget> list = <Widget>[];
    if( result == null) return list;
    for (var element in result!) {
      var distanceBetween = AMapTools.distanceBetween(const LatLng(39.993135,116.474175), LatLng(element.location?.latitude??0, element.location?.longitude??0));
      list.add(Card(
        margin: const EdgeInsets.all(4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text("${distanceBetween.toInt()}米:${element.address}"),
        ),
      ));
    }
   return list;
  }
}
