import 'package:flutter/material.dart';
import 'package:xbr_gaode_navi_amap/amap/amap_widget.dart';
import 'package:xbr_gaode_navi_amap/amap/base/amap_flutter_base.dart';
import 'package:xbr_gaode_navi_amap/amap/map/src/types/camera.dart';
import 'package:xbr_gaode_navi_amap/amap/map/src/types/ui.dart';
import 'package:xbr_gaode_navi_amap/search/xbr_search.dart';

class SearchDemoPage extends StatefulWidget {
  const SearchDemoPage({Key? key}) : super(key: key);

  @override
  State<SearchDemoPage> createState() => _SearchDemoPageState();
}

class _SearchDemoPageState extends State<SearchDemoPage> {
  String result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("关键字: 检索示例"),
      ),
      body: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            height: 10,
          ),
          const SizedBox(
            width: double.infinity,
            child: Text("XbrSearch.keywordsSearch(keyWord,cityCode,page,limit,back)\n"
                "keyWord:要检索的关键字\n"
                "cityCode:限制在哪个城市，可以传名称/城市编码\n"
                "page:分页，从1开始\n"
                "limit:每页显示数量\n"
                "back:返回方法(code,data){}\n"),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child: const Text("关键字: 北京大学"),
              onPressed: () {
                XbrSearch.keywordsSearch(
                  keyWord: "北京大学",
                  back: (code, data) {
                    setState(() {
                      result = data.toJson().toString();
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
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(result),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
