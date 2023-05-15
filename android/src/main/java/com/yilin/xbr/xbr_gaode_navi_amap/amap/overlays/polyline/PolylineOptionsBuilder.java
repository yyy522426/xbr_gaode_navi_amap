package com.yilin.xbr.xbr_gaode_navi_amap.amap.overlays.polyline;

import com.amap.api.maps.model.BitmapDescriptor;
import com.amap.api.maps.model.LatLng;
import com.amap.api.maps.model.PolylineOptions;

import java.util.List;

class PolylineOptionsBuilder implements PolylineOptionsSink {
    final PolylineOptions polylineOptions;

    PolylineOptionsBuilder() {
        polylineOptions = new PolylineOptions();
    }

    @Override
    public void setPoints(List<LatLng> points) {
        polylineOptions.setPoints(points);
    }

    @Override
    public void setWidth(float width) {
        polylineOptions.width(width);
    }

    @Override
    public void setColor(int color) {
        polylineOptions.color(color);
    }

    @Override
    public void setVisible(boolean visible) {
        polylineOptions.visible(visible);
    }

    @Override
    public void setCustomTexture(BitmapDescriptor customTexture) {
        polylineOptions.setCustomTexture(customTexture);
    }

    @Override
    public void setCustomTextureList(List<BitmapDescriptor> customTextureList) {
        polylineOptions.setCustomTextureList(customTextureList);
    }

    @Override
    public void setColorList(List<Integer> colorList) {
        polylineOptions.colorValues(colorList);
    }

    @Override
    public void setCustomIndexList(List<Integer> customIndexList) {
        polylineOptions.setCustomTextureIndex(customIndexList);
    }

    @Override
    public void setGeodesic(boolean geodesic) {
        polylineOptions.geodesic(geodesic);
    }

    @Override
    public void setGradient(boolean gradient) {
        polylineOptions.useGradient(gradient);
    }

    @Override
    public void setAlpha(float alpha) {
        polylineOptions.transparency(alpha);
    }

    @Override
    public void setDashLineType(int type) {
        polylineOptions.setDottedLineType(type);
    }

    @Override
    public void setDashLine(boolean dashLine) {
        polylineOptions.setDottedLine(dashLine);
    }

    @Override
    public void setLineCapType(PolylineOptions.LineCapType lineCapType) {
        polylineOptions.lineCapType(lineCapType);
    }

    @Override
    public void setLineJoinType(PolylineOptions.LineJoinType joinType) {
        polylineOptions.lineJoinType(joinType);
    }

    public PolylineOptions build(){
        return polylineOptions;
    }


}
