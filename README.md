# xbr_gaode_navi_amap

#### 介绍，高德系列：

欢迎使用高德集成库，本插件包含 高德地图显示、高德地图查询、高德GPS服务、高德导航。使用前您需了解

1.本插件是因为高德导航官方包无法分包，必须使用合包，所以才将所有模块集成。若没有导航需求，不建议使用
2.您可以单独使用地图插件：xbr_gaode_amap
3.您可以单独使用地图查询插件：xbr_gaode_search
4.您可以单独使用定位插件：xbr_gaode_location

5.下面的截图属于：xbr_gaode_amap，可以下载xbr_gaode_amap的demo查看

![](http://gzyl.oss-cn-shenzhen.aliyuncs.com/emergencyImg20220409_161315652tupianpinjie.jpg?Expires=1964941960&OSSAccessKeyId=LTAIbSwdJpv7vRhC&Signature=Vo0CvpUVDbz%2Ba4ghrxwORMqALR4%3D)

#### 主要功能

1.查询插件，查询功能如下

​    （1）关键子检索+周边检索 POI

​    （2）POI详情

​    （3）线路规划

​    （4）货车线路规划（先去高德客服申请）

​    （5）查询输入提示 InputTips

​    （6）地理编码（地址转坐标）

​    （7）逆地理编码（坐标转地址）

2.高德定位

​    （1）原生部分完全使用官方提供的SDK：amap_flutter_location；未额外增加任何功能，可以使用官方SDK所有方法

​	（2）处理了定位返回数据：IOS和Android兼容（官方sdk只返回Map,而且IOS和Android返回的字段不一致）

​	（3）简化了定位回调，使用：XbrLocation.instance().execOnceLocation(callback:... ) 和 XbrLocation.instance().startTimeLocation(callback:... )

​	（4）增加后后台保活定位，使用：XbrLocation.instance().startTimeLocation(callback:...,backgroundService:true ),一个程序仅允许一个保活定位进程

3.地图功能做了以下调整

​	（1）原生部分完全使用官方提供的SDK：amap_flutter_map；未额外增加任何功能，但修复了一些BUG

​	（2）简化地图绘制流程，增加地图UI绘制器：AMapUIController()

​	（3）增加了利用多边形绘制圆的方法

​	（4）修复Marker不能平铺在地图上，使用 FMarker 增加了flat字段，为true时可以平铺在地图上

​	（5）协调了地图查询功能和地图的整合，可以一键绘制路线

4.高德导航

​	（1）导航不能自定义，调用了高德的快速导航API:XbrNavi.startNavi(title,subtext,points,strategy = 0, emulator})

​	（2）ANDROID端可以传递一个title和subtext，显示在地图下方，ios端不支持

​	（3）emulator：虚拟导航


#### 安装教程
```dart
  xbr_gaode_navi_amap: ^1.0.0
```

#### 使用说明

1. ##### 定位

   (1).定位权限配置，使用第三方 permission_handler 动态权限工具，  使用方法请移步 permission_handler
   (2).定位调用

   ```dart
       //TODO:开始单次定位 定位成功自动销毁
       XbrLocation.instance().execOnceLocation(callback: (LocationInfo? location){
           //location 对IOS和Android数据 已兼容处理
   
       });
   
       //TODO:开启连续定位
       XbrLocation.instance().startTimeLocation(
           clientKey："clientKey",//必传，整个APP只有一个定位线程时可以不传
           callback：(LocationInfo? location){
           	//location 对IOS和Android数据 已兼容处理
       	},
       );
   
       @override
       void dispose() {
           //销毁 连续定位
           XbrLocation.instance().destroyLocation(clientKey);
           super.dispose();
       }
   ```
   (3).注意：单次定位不用销毁也可以不用传递clientKey，但是如果在多个地方同时使用连续定位，每个地方需传递不同的clientKey，
   销毁定位时徐传递需要销毁的定位clientKey。
   (4).后台保活定位：后台保活定位只需在XbrLocation.instance().startTimeLocation（）中设置backgroundService为true；但是注意，一个程序仅允许一个保活定位进程，因为在安卓原生端只生成一个保活服务。一般程序也只需要在采集轨迹时才需要保活服务。

   ```dart
   //TODO:开启连续定位
   XbrLocation.instance().startTimeLocation(
        clientKey："clientKey",//必传，整个APP只有一个定位线程时可以不传
        backgroundService:true,//一个程序仅允许一个保活定位进程
        callback：(LocationInfo? location){
          //location 对IOS和Android数据 已兼容处理
        },
   );
   
   //业务结束时销毁定位
   XbrLocation.instance().destroyLocation(clientKey);
   
   ```

3. ###### 地图使用:
   ```dart
    AMapUIController uiController = AMapUIController();
   ```
   (1).地图控件
   ```dart
   //简单使用，默认了地图部分功能，快速使用
    AmapWidget(
       initCameraPosition: CameraPosition(target: LatLng(26.653841, 106.642904), bearing: 45, zoom: 12, tilt: 15),
       uiController: uiController,
       onMapCreated: (AMapController controller) {
           //地图加载完成
       },
       onCameraMove: (CameraPosition position) {
           //地图移动
       },
       onCameraMoveEnd: (CameraPosition position) {
           //地图移动结束
       }
   )
   //或者使用 需要满足地图所有功能时使用 绘制需要自己控制和刷新 uiController无法使用
   AMapWidget(
      privacyStatement: XbrGaodeAmap.instace().statement,
      apiKey: XbrGaodeAmap.instace().apikey,
      mapType: widget.mapType??MapType.normal,
      markers: Set<Marker>.of(markers.values),
      polylines: Set<Polyline>.of(polylines.values),
      polygons: Set<Polygon>.of(polygons.values),
      initialCameraPosition: widget.initCameraPosition,
      gestureScaleByMapCenter: widget.gestureScaleByMapCenter,
      onCameraMove: widget.onCameraMove,
      onCameraMoveEnd: widget.onCameraMoveEnd,
      onMapCreated: widget.onMapCreated,
      scaleEnabled:false,
    )
   ```
   (2).地图绘制
   ```dart
      //1.绘制线
      uiController.savePolyline("pathlineId", Polyline(..));
      //2.绘制marker (flat:可将图片贴在地图上，随3d地图旋转)
      uiController.saveMarker("markerId", FlatMarker(flat:...));
      //3.绘制圆 -利用绘制多边形绘制圆
      //获取圆数据：latLng中心点，radius圆的半径（真实半径:单位-米(m)，可以制作电子围栏））
      var points = AmapUtil.getCirclePoints(center:latLng,radiusMi: radius);
      uiController.savePolygon("polygonId",Polygon(points:points);
   
      ///绘制完要刷新地图
      uiController.refreshUI();
   ```
   
   (3).uiController.getMarker(id)、uiController.getPolyline(id)、uiController.getPolygon(id)可以获取地图中已经存在的元素，进行动态编辑。同样的还有删除和清空操作。
   
3. ###### 地图查询:

   (1).线路规划
   ```dart
    AmapSearchUtil.routePlanning(
         wayPoints: list, //第一个为起点，最后一个为终点，中间为途径点,支持无限个点
         callBack: (code, linePoints, bounds) {
               //code 1000为成功
               //linePoints 返回的线点集合，如果需要导航数据，使用方法：
               //bounds 最大可视面积矩形坐标盒（），移动相机时可以直接使用，如下所示
               //绘制规划线 pathlineId 是唯一值 需自定义
               //customTexture：线路Texture图片，可以不设置，使用颜色
               uiController.savePolyline("pathlineId", Polyline(
                 customTexture: BitmapDescriptor.fromIconPath(lineImgPath),
                 joinType: JoinType.round,
                 capType: CapType.round,
                 points: linePoints,
                 color: Colors.blueAccent,
                 width: 14,
               ));
               //利用MAP控制器移动相机到线路最大可视面积，边距50，时间1000毫秒，可自行更改
               mapController.moveCamera(CameraUpdate.newLatLngBounds(bounds, 50), duration: 1000);
               ...
               
              ///绘制完要刷新地图
              uiController.refreshUI();
         }
     )
   //注意上面方法只返回：第一条线路的坐标点串
   //若需要返回其他信息，请使用
   XbrSearch.routeSearchPage(wayPoints,strategy,showFields); 
   //或
   XbrSearch.routeSearch(wayPoints,strategy,showFields,onlyOne);
   //前者支持无限个点（自动分页），后者最大支持8个点（起终点+6途经点）
   //strategy：策略，在DrivingStrategy中已定义
   //showFields：需要返回的字段，在ShowFields中已定义
   //onlyOne：前者已默认true,后者可自定义，只返回一条最优路线。 
   
   //货车线路规划
   XbrSearch.truckRouteSearchPage();
   XbrSearch.truckRouteSearch();
   //drivingMode不等于strategy：在DrivingMode中已定义
   ```
   (2).算路
   ```dart
   routeCalculate(wayPoints, strategy, calculateBack});
   //只返回：时间和距离，wayPoints支持无限个点
   ```
   (3).关键字检索
   ```dart
   XbrSearch.keywordsSearch(keyWord);
   //keyWord：关键字
   ```
   (4)周边检索
   ```dart
   XbrSearch.boundSearch(point,score);
   //point：中心点
   //score：搜索半径（米）
   ```
   (5)搜索提示
   ```dart
   XbrSearch.inputTips(newTextnewText);
   //newTextnewText:需要提示的文本
   ```
   (6)POI详情
   ```dart
   XbrSearch.getPOIById(id);
   ```
   (7)地理编码和逆地理编码
   ```dart
   XbrSearch.geocoding(address);
   XbrSearch.reGeocoding(point);
   ```
###### 4.导航
导航比较简单
 ```dart
 XbrNavi.startNavi(points,strategy,emulator);
//points:导航点 第一个为起点，最后一个终点，中间为途经点，长度不能小于2
//strategy：规划策略
//emulator：虚拟导航
//title：标题，仅android有效
//subtext：标题，仅android有效
 ```

#### 参与贡献

1.  版本内置 高德官方插件  amap_flutter_map，amap_flutter_location，使用前需参考高德API
2.  example中有动态权限功能，使用：permission_handler
3.  本控件由易林物流，XBR-小镖人团队开发并维护。
4.  XBR开发团队：从事物流软件开发、物流AI技术、智慧物流、网络货运
5.  网络货源开发者福利：xbr_network_freight封装了网络货运SDK，并提供了可直接测试的example


