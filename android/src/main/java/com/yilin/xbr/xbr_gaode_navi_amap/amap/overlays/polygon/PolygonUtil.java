package com.yilin.xbr.xbr_gaode_navi_amap.amap.overlays.polygon;

import com.amap.api.maps.model.AMapPara;
import com.yilin.xbr.xbr_gaode_navi_amap.amap.utils.ConvertUtil;

import java.util.Map;

class PolygonUtil {

    static String interpretOptions(Object o, PolygonOptionsSink sink) {
        final Map<?, ?> data = ConvertUtil.toMap(o);
        final Object points = data.get("points");
        if (points != null) {
            sink.setPoints(ConvertUtil.toPoints(points));
        }

        final Object width = data.get("strokeWidth");
        if (width != null) {
            sink.setStrokeWidth(ConvertUtil.toFloatPixels(width));
        }

        final Object strokeColor = data.get("strokeColor");
        if (strokeColor != null) {
            sink.setStrokeColor(ConvertUtil.toInt(strokeColor));
        }

        final Object fillColor = data.get("fillColor");
        if (fillColor != null) {
            sink.setFillColor(ConvertUtil.toInt(fillColor));
        }

        final Object visible = data.get("visible");
        if (visible != null) {
            sink.setVisible(ConvertUtil.toBoolean(visible));
        }

        final Object joinType = data.get("joinType");
        if (joinType != null) {
            sink.setLineJoinType(AMapPara.LineJoinType.valueOf(ConvertUtil.toInt(joinType)));
        }

        final String polylineId = (String) data.get("id");
        if (polylineId == null) {
            throw new IllegalArgumentException("polylineId was null");
        } else {
            return polylineId;
        }
    }


}
