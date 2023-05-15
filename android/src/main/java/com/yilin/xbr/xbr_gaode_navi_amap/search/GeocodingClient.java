package com.yilin.xbr.xbr_gaode_navi_amap.search;

import android.content.Context;

import com.amap.api.services.core.AMapException;
import com.amap.api.services.core.LatLonPoint;
import com.amap.api.services.geocoder.GeocodeAddress;
import com.amap.api.services.geocoder.GeocodeQuery;
import com.amap.api.services.geocoder.GeocodeResult;
import com.amap.api.services.geocoder.GeocodeSearch;
import com.amap.api.services.geocoder.RegeocodeAddress;
import com.amap.api.services.geocoder.RegeocodeQuery;
import com.amap.api.services.geocoder.RegeocodeResult;
import com.yilin.xbr.xbr_gaode_navi_amap.search.core.OnGeocodeSearchListener;
import com.yilin.xbr.xbr_gaode_navi_amap.search.core.OnReGeocodeSearchListener;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class GeocodingClient {

    private final Context context;
    private GeocodeSearch geocoderSearch = null;

    public GeocodingClient(Context context) {
        this.context = context;
    }

    public GeocodeSearch getGeocoderSearch() throws AMapException {
        if (geocoderSearch == null) geocoderSearch = new GeocodeSearch(context);
        return geocoderSearch;
    }

    /**
     * 地理编码（地址转坐标）
     */
    public void geocoding(String address, String cityOrAdcode, final SearchBack searchBack) {
        try {
            GeocodeQuery query = new GeocodeQuery(address, cityOrAdcode);
            getGeocoderSearch().getFromLocationNameAsyn(query);
            getGeocoderSearch().setOnGeocodeSearchListener(new OnGeocodeSearchListener() {
                @Override
                public void onGeocodeSearched(GeocodeResult geocodeResult, int code) {
                    Map<String,Object> map = new HashMap<>();
                    List<Map<String,Object>> geocodeAddressList = new ArrayList<>();
                    for (GeocodeAddress geocodeAddress:geocodeResult.getGeocodeAddressList()){
                        Map<String,Object> geocodeAddressMap = new HashMap<>();

                        geocodeAddressMap.put("neighborhood",geocodeAddress.getNeighborhood());
                        geocodeAddressMap.put("postcode",geocodeAddress.getPostcode());
                        geocodeAddressMap.put("building",geocodeAddress.getBuilding());
                        geocodeAddressMap.put("province",geocodeAddress.getProvince());
                        geocodeAddressMap.put("level",geocodeAddress.getLevel());
                        geocodeAddressMap.put("formattedAddress",geocodeAddress.getFormatAddress());

                        Map<String,Object> locationMap = new HashMap<>();
                        if (geocodeAddress.getLatLonPoint()!=null){
                            locationMap.put("latitude",geocodeAddress.getLatLonPoint().getLatitude());
                            locationMap.put("longitude",geocodeAddress.getLatLonPoint().getLongitude());
                            geocodeAddressMap.put("location",locationMap);
                        }

                        geocodeAddressMap.put("city",geocodeAddress.getCity());
//                        geocodeAddressMap.put("citycode",geocodeAddress.g);
                        geocodeAddressMap.put("district",geocodeAddress.getDistrict());
                        geocodeAddressMap.put("adcode",geocodeAddress.getAdcode());
                        geocodeAddressMap.put("township",geocodeAddress.getTownship());
                        geocodeAddressMap.put("country",geocodeAddress.getCountry());

                        geocodeAddressList.add(geocodeAddressMap);
                    }
                    map.put("geocodeAddressList",geocodeAddressList);
                    //解析result获取坐标信息
                    searchBack.back(code, map);
                }
            });
        } catch (AMapException e) {
            e.printStackTrace();
        }
    }

    /**
     * 逆地理编码（坐标转地址）
     */
    public void reGeocoding(LatLonPoint point, int scope, final SearchBack searchBack) {
        try {
            RegeocodeQuery query = new RegeocodeQuery(point, scope, GeocodeSearch.AMAP);
            getGeocoderSearch().getFromLocationAsyn(query);
            getGeocoderSearch().setOnGeocodeSearchListener(new OnReGeocodeSearchListener() {
                @Override
                public void onRegeocodeSearched(RegeocodeResult regeocodeResult, int i) {
                    Map<String,Object> map = new HashMap<>();
                    RegeocodeAddress address = regeocodeResult.getRegeocodeAddress();
                    Map<String,Object> regeocodeAddress = new HashMap<>();
                    regeocodeAddress.put("citycode",address.getCityCode());
                    regeocodeAddress.put("formattedAddress",address.getFormatAddress());

                    Map<String,Object> addressComponent = new HashMap<>();
                    addressComponent.put("province",address.getProvince());
                    addressComponent.put("city",address.getCity());
                    addressComponent.put("citycode",address.getCityCode());
                    addressComponent.put("adcode",address.getAdCode());
                    addressComponent.put("country",address.getCountry());
                    addressComponent.put("township",address.getTownship());
                    addressComponent.put("towncode",address.getTowncode());
                    addressComponent.put("neighborhood",address.getDistrict());
                    addressComponent.put("building",address.getDistrict());
                    addressComponent.put("countryCode",address.getDistrict());

                    if (address.getStreetNumber()!=null){
                        Map<String,Object> streetNumber = new HashMap<>();
                        streetNumber.put("direction",address.getStreetNumber().getDirection());
                        streetNumber.put("number",address.getStreetNumber().getNumber());
                        streetNumber.put("street",address.getStreetNumber().getStreet());

                        Map<String,Object> locationMap = new HashMap<>();
                        if (address.getStreetNumber().getLatLonPoint()!=null){
                            locationMap.put("latitude",address.getStreetNumber().getLatLonPoint().getLatitude());
                            locationMap.put("longitude",address.getStreetNumber().getLatLonPoint().getLongitude());
                            streetNumber.put("location",locationMap);
                        }

                        streetNumber.put("distance",address.getStreetNumber().getDistance());
                        addressComponent.put("streetNumber",streetNumber);
                    }
                    regeocodeAddress.put("addressComponent",addressComponent);
                    map.put("regeocodeAddress",regeocodeAddress);
                    //解析result获取坐标信息
                    searchBack.back(i, map);
                }
            });
        } catch (AMapException e) {
            e.printStackTrace();
        }
    }
}
