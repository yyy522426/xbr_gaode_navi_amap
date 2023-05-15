package com.yilin.xbr.xbr_gaode_navi_amap.amap.overlays;

import com.amap.api.maps.AMap;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

public abstract class AbstractOverlayController<T> {
    protected final Map<String, T> controllerMapByDartId;
    protected final Map<String, String> idMapByOverlyId;
    protected final MethodChannel methodChannel;
    protected final AMap amap;
    public AbstractOverlayController(MethodChannel methodChannel, AMap amap){
        this.methodChannel = methodChannel;
        this.amap = amap;
        controllerMapByDartId = new HashMap<String, T>(12);
        idMapByOverlyId = new HashMap<String, String>(12);
    }
}
