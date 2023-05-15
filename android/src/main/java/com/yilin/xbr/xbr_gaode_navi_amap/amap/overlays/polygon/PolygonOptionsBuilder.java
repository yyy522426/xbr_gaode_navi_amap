package com.yilin.xbr.xbr_gaode_navi_amap.amap.overlays.polygon;

import com.amap.api.maps.model.AMapPara;
import com.amap.api.maps.model.LatLng;
import com.amap.api.maps.model.PolygonOptions;

import java.util.List;

class PolygonOptionsBuilder implements PolygonOptionsSink {
    final PolygonOptions polygonOptions;
    PolygonOptionsBuilder() {
        polygonOptions = new PolygonOptions();
        //必须设置为true，否则会出现线条转折处出现断裂的现象
        polygonOptions.usePolylineStroke(true);
    }

    public PolygonOptions build(){
        return polygonOptions;
    }


    @Override
    public void setPoints(List<LatLng> points) {
        polygonOptions.setPoints(points);
    }

    @Override
    public void setStrokeWidth(float strokeWidth) {
        polygonOptions.strokeWidth(strokeWidth);
    }

    @Override
    public void setStrokeColor(int color) {
        polygonOptions.strokeColor(color);
    }

    @Override
    public void setFillColor(int color) {
        polygonOptions.fillColor(color);
    }

    @Override
    public void setVisible(boolean visible) {
        polygonOptions.visible(visible);
    }

    @Override
    public void setLineJoinType(AMapPara.LineJoinType joinType) {
        polygonOptions.lineJoinType(joinType);
    }
}
