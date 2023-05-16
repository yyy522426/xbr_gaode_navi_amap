package com.yilin.xbr.xbr_gaode_navi_amap.search;

import android.app.Activity;

import androidx.annotation.NonNull;
import com.amap.api.services.core.LatLonPoint;
import com.amap.api.services.core.ServiceSettings;
import com.google.gson.reflect.TypeToken;
import com.yilin.xbr.xbr_gaode_navi_amap.search.core.TruckInfo;
import com.yilin.xbr.xbr_gaode_navi_amap._code.GsonUtil;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;

/** XbrGaodeSearchPlugin */
public class XbrAMapSearchPlugin {
  private final Activity activity;

  AmapSearchClient amapSearchClient;
  GeocodingClient geocodingClient;

  public XbrAMapSearchPlugin(Activity activity) {
    this.activity = activity;
  }

  public AmapSearchClient getAmapSearchClient() {
    if (amapSearchClient == null) amapSearchClient = new AmapSearchClient(activity);
    return amapSearchClient;
  }

  public GeocodingClient getGeocodingClient() {
    if (geocodingClient==null) geocodingClient = new GeocodingClient(activity);
    return geocodingClient;
  }

  public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result) {
    switch (call.method) {
      case "keywordsSearch":{
        //关键词搜索
        String keyWord = call.argument("keyWord");
        String cityCode = call.argument("cityCode");
        Integer page = call.argument("page");
        Integer limit = call.argument("limit");
        if (page == null) page = 0;
        if (limit == null) limit = 10;
        getAmapSearchClient().keywordsSearch(keyWord, cityCode, page, limit, new SearchBack() {
          @Override
          public void back(final int code,final Map<String,Object> map) {
            result.success(GsonUtil.toJson(toResult(code,map)));
          }
        });
        break;
      }
      case "boundSearch":{
        //周边搜索
        String pointJson = call.argument("pointJson");
        Integer scope = call.argument("scope");
        Integer page = call.argument("page");
        Integer limit = call.argument("limit");
        if (page == null) page = 0;
        if (limit == null) limit = 10;
        if (scope == null) scope = 1000;
        LatLonPoint latLonPoint = null;
        if (pointJson != null) {
          Double[] map = GsonUtil.fromJson(pointJson, new TypeToken<Double[]>() {});
          if (map.length == 2) latLonPoint = new LatLonPoint(toDouble(map[0]), toDouble(map[1]));
        }
        getAmapSearchClient().boundSearch(latLonPoint, scope, page, limit, new SearchBack() {
          @Override
          public void back(final int code,final Map<String,Object> map) {
            result.success(GsonUtil.toJson(toResult(code,map)));
          }
        });
        break;
      }
      case "inputTips":
        //输入提示
        String newText = call.argument("newText");
        String city = call.argument("city");
        Boolean cityLimit = call.argument("cityLimit");
        if (cityLimit == null) cityLimit = true;
        getAmapSearchClient().inputTips(newText, city, cityLimit, new SearchListBack() {
          @Override
          public void back(final int code,final List<Map<String,Object>> mapList) {
            result.success(GsonUtil.toJson(toResult(code,mapList)));
          }
        });
        break;
      case "getPOIById":
        //输入提示
        String id = call.argument("id");
        getAmapSearchClient().getPOIById(id, new SearchBack() {
          @Override
          public void back(final int code,final Map<String,Object> map) {
            result.success(GsonUtil.toJson(toResult(code,map)));
          }
        });
        break;
      case "routeSearch": {
        //线路规划
        String json = call.argument("wayPointsJson");
        Integer strategy = call.argument("strategy");
        Boolean onlyOne = call.argument("onlyOne");
        Integer showFields = call.argument("showFields");
        List<LatLonPoint> wayPoints = new ArrayList<>();
        if (json != null) {
          List<Double[]> mapPoints = GsonUtil.fromJson(json, new TypeToken<List<Double[]>>() {
          });
          wayPoints = coverPoint(mapPoints);
        }
        if (onlyOne==null) onlyOne = true;
        if (wayPoints.size() >= 2) {
          getAmapSearchClient().routeSearch(wayPoints, strategy,showFields,onlyOne, new SearchBack() {
            @Override
            public void back(final int code,final Map<String,Object> map) {
              result.success(GsonUtil.toJson(toResult(code,map)));
            }
          });
        }
        break;
      }
      case "truckRouteSearch": {
        //线路规划 --货车
        String json = call.argument("wayPointsJson");
        String truckInfoJson = call.argument("truckInfoJson");
        Integer drivingMode = call.argument("drivingMode");
        Boolean onlyOne = call.argument("onlyOne");
        Integer showFields = call.argument("showFields");
        List<LatLonPoint> wayPoints = null;
        TruckInfo truckInfo = null;
        if (json != null) {
          List<Double[]> mapPoints = GsonUtil.fromJson(json, new TypeToken<List<Double[]>>() {});
          wayPoints = coverPoint(mapPoints);
        }
        if (truckInfoJson != null) {
          truckInfo = GsonUtil.fromJson(truckInfoJson, new TypeToken<TruckInfo>() {});
        }
        if (onlyOne==null) onlyOne = true;
        if (wayPoints != null && wayPoints.size() >= 2) {
          getAmapSearchClient().truckRouteSearch(wayPoints, drivingMode, truckInfo,showFields,onlyOne, new SearchBack() {
            @Override
            public void back(final int code,final Map<String,Object> map) {
              result.success(GsonUtil.toJson(toResult(code,map)));
            }
          });
        }
        break;
      }
      case "geocoding":
        //地理编码
        String address = call.argument("address");
        String cityOrAdcode = call.argument("cityOrAdcode");
        getGeocodingClient().geocoding(address, cityOrAdcode, new SearchBack() {
          @Override
          public void back(final int code,final Map<String,Object> map) {
            result.success(GsonUtil.toJson(toResult(code,map)));
          }
        });
        break;
      case "reGeocoding":{
        //逆地理编码
        String pointJson = call.argument("pointJson");
        Integer scope = call.argument("scope");
        if (scope == null) scope = 300;
        LatLonPoint latLonPoint = null;
        if (pointJson != null) {
          Double[] map = GsonUtil.fromJson(pointJson, new TypeToken<Double[]>() {});
          if (map.length == 2) latLonPoint = new LatLonPoint(toDouble(map[0]), toDouble(map[1]));
        }
        if (latLonPoint != null) {
          getGeocodingClient().reGeocoding(latLonPoint, scope, new SearchBack() {
            @Override
            public void back(final int code,final Map<String,Object> map) {
              result.success(GsonUtil.toJson(toResult(code,map)));
            }
          });
        }
        break;
      }
    }
  }


  private List<LatLonPoint> coverPoint(List<Double[]> mapList) {
    List<LatLonPoint> list = new ArrayList<>();
    if (mapList == null) return list;
    for (int i = 0; i < mapList.size(); i++) {
      Double[] map = mapList.get(i);
      if (map.length != 2) continue;
      list.add(new LatLonPoint(toDouble(map[0]), toDouble(map[1])));
    }
    return list;
  }

  private double toDouble(Object o) {
    try {
      return Double.parseDouble(String.valueOf(o));
    } catch (Exception e) {
      return 0d;
    }
  }

  private Map<String,Object> toResult(int code,Object o){
    Map<String,Object> map= new HashMap<>();
    map.put("code",code);
    map.put("data",o);
    return map;
  }
}
