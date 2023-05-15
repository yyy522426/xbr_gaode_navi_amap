package com.yilin.xbr.xbr_gaode_navi_amap.navi.utils;

import static android.text.Spanned.SPAN_INCLUSIVE_EXCLUSIVE;

import android.graphics.Color;
import android.text.SpannableString;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.text.style.ForegroundColorSpan;
import android.text.style.RelativeSizeSpan;

import com.amap.api.maps.AMapUtils;
import com.amap.api.maps.model.LatLng;
import com.amap.api.navi.model.NaviLatLng;
import com.autonavi.amap.mapcore.IPoint;
import com.autonavi.amap.mapcore.MapProjection;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * 包名： com.amap.navi.demo.util
 * <p>
 * 创建时间：2018/4/19
 * 项目名称：NaviDemo
 *
 * @author guibao.ggb
 * @email guibao.ggb@alibaba-inc.com
 * <p>
 * 类说明：
 */
public class NaviUtil {

    public static float calculateDistance(NaviLatLng start, NaviLatLng end) {
        double x1 = start.getLongitude();
        double y1 = start.getLatitude();
        double x2 = end.getLongitude();
        double y2 = end.getLatitude();
        return AMapUtils.calculateLineDistance(new LatLng(y1, x1), new LatLng(y2, x2));
    }


    public static NaviLatLng getPointForDis(NaviLatLng sPt, NaviLatLng ePt, double dis) {
        double lSegLength = calculateDistance(sPt, ePt);
        NaviLatLng pt = new NaviLatLng();
        double preResult = dis / lSegLength;
        pt.setLatitude(((ePt.getLatitude() - sPt.getLatitude()) * preResult + sPt.getLatitude()));
        pt.setLongitude(((ePt.getLongitude() - sPt.getLongitude()) * preResult + sPt.getLongitude()));
        return pt;
    }

    /**
     * 根据经纬度计算需要偏转的角度
     *
     * @param startPoi
     * @param secondPoi
     * @return
     */
    public static float getRotate(NaviLatLng startPoi, NaviLatLng secondPoi) {
        float rotate = 0;
        try {
            IPoint point1 = new IPoint();
            IPoint point2 = new IPoint();
            MapProjection.lonlat2Geo(startPoi.getLongitude(), startPoi.getLatitude(), point1);
            MapProjection.lonlat2Geo(secondPoi.getLongitude(), secondPoi.getLatitude(), point2);
            double x1 = point1.x;
            double x2 = point2.x;
            double y1 = point1.y;
            double y2 = point2.y;
            rotate = (float) (Math.atan2(y2 - y1, x2 - x1) / Math.PI * 180);
            rotate = rotate + 90;
            return rotate;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rotate;
    }


    public static final int MAXZOOMLEVEL = 20;
    public static final int PIXELSPERTILE = 256;
    public static final double MINLATITUDE = -85.0511287798;
    public static final double MAXLATITUDE = 85.0511287798;
    public static final double MINLONGITUDE = -180;
    public static final double MAXLONGITUDE = 180;
    public static final int EARTHRADIUSINMETERS = 6378137;
    public static final int TILESPLITLEVEL = 0;


    public static final double EarthCircumferenceInMeters = 2 * Math.PI
            * EARTHRADIUSINMETERS;


    public static double clip(double n, double minValue, double maxValue) {
        return Math.min(Math.max(n, minValue), maxValue);
    }

    public static IPoint lonlat2Geo(double latitude, double longitude,
                                    int levelOfDetail) {
        IPoint rPnt = new IPoint();
        latitude = clip(latitude, MINLATITUDE, MAXLATITUDE) * Math.PI / 180;
        longitude = clip(longitude, MINLONGITUDE, MAXLONGITUDE) * Math.PI / 180;
        double sinLatitude = Math.sin(latitude);
        double xMeters = EARTHRADIUSINMETERS * longitude;
        double lLog = Math.log((1 + sinLatitude) / (1 - sinLatitude));
        double yMeters = EARTHRADIUSINMETERS / 2 * lLog;
        long numPixels = (long) PIXELSPERTILE << levelOfDetail;
        double metersPerPixel = EarthCircumferenceInMeters / numPixels;
        rPnt.x = (int) clip((EarthCircumferenceInMeters / 2 + xMeters)
                / metersPerPixel + 0.5, 0, numPixels - 1);
        long tmp = (long) (EarthCircumferenceInMeters / 2 - yMeters);
        rPnt.y = (int) clip((double) tmp / metersPerPixel + 0.5, 0,
                numPixels - 1);
        return rPnt;
    }

    public static SpannableString formatKMSpan(int d) {
        String[] strings = formatKM(d).split(",");
        SpannableString spannableString = new SpannableString("剩余"+strings[0]+strings[1]);
        spannableString.setSpan(new ForegroundColorSpan(Color.RED), 2, strings[0].length()+2, SPAN_INCLUSIVE_EXCLUSIVE);
        spannableString.setSpan(new RelativeSizeSpan(1.5f), 2, strings[0].length()+2, Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
        return spannableString;
    }

    public static String formatKM(int d) {
        if (d == 0) {
            return "0,米";
        } else if (d < 100) {
            return d + ",米";
        } else if (d < 1000) {
            return d + ",米";
        } else if (d < 10000) {
            return (d / 10) * 10 / 1000.0D + ",公里";
        } else if (d < 100000) {
            return (d / 100) * 100 / 1000.0D + ",公里";
        }
        return (d / 1000) + ",公里";
    }

    public static String formatKMUnit(int d) {
        if (d < 20) {
            return "现在, ";
        } else if (d < 100) {
            return d + ",米";
        } else if (d < 1000) {
            return d + ",米";
        } else if (d < 10000) {
            return (d / 10) * 10 / 1000.0D + ",公里";
        } else if (d < 100000) {
            return (d / 100) * 100 / 1000.0D + ",公里";
        }
        return (d / 1000) + ",公里";
    }

    public static SpannableStringBuilder formatTimeSecSpan(Long s) {
        List<String> stringList = formatTime(s * 1000);
        SpannableStringBuilder builder = new SpannableStringBuilder();
        for (String s1 : stringList) {
            String[] strings = s1.split(",");
            SpannableString spannableString = new SpannableString(strings[0]+strings[1]);
            spannableString.setSpan( new ForegroundColorSpan(Color.RED), 0, strings[0].length(), SPAN_INCLUSIVE_EXCLUSIVE);
            spannableString.setSpan(new RelativeSizeSpan(1.5f), 0, strings[0].length(), Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
            builder.append(spannableString);
        }
        return builder;
    }

    public static List<String> formatTime(Long ms) {
        int ss = 1000;
        int mi = ss * 60;
        Integer hh = mi * 60;
        Integer dd = hh * 24;
        Long day = ms / dd;
        Long hour = (ms - day * dd) / hh;
        long minute = (ms - day * dd - hour * hh) / mi;
        long second = (ms - day * dd - hour * hh - minute * mi) / ss;
        long milliSecond = ms - day * dd - hour * hh - minute * mi - second * ss;
        List<String> listStr = new ArrayList<>();
        if(day > 0) listStr.add(day+",天");
        if(hour > 0) listStr.add(hour+",小时");
        if(minute > 0) listStr.add(minute+",分钟");
        //if(second > 0) listStr.add(second+",秒");
        return listStr;
    }

    public static Date addTimeSec(Date date,int sec) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(Calendar.SECOND,sec);
        return calendar.getTime();
    }

    public static String getAutoTime(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        Calendar currentCalendar = Calendar.getInstance();
        currentCalendar.set(Calendar.HOUR_OF_DAY, 0);
        currentCalendar.set(Calendar.MINUTE, 0);
        currentCalendar.set(Calendar.SECOND, 0);
        currentCalendar.set(Calendar.MILLISECOND, 0);
        long dateL = calendar.getTimeInMillis();
        long nowL = currentCalendar.getTimeInMillis();
        if (dateL < nowL - 1296000000L) { // 比15天前还早
            if (calendar.get(Calendar.YEAR) == currentCalendar.get(Calendar.YEAR)) { // 在今年
                return getDate(date);
            } else {
                return getDateOneYear(date);
            }
        } else if (dateL < nowL - 172800000L) { // 比今天0时还早48小时以上
            return ((nowL - dateL) / 86400000L) + "天前";
        } else if (dateL < nowL - 86400000L) { // 比今天0时还早24小时以上
            return "前天 " + getTime(date);
        } else if (dateL < nowL) { // 比今天0时还早
            return "昨天 " + getTime(date);
        } else if (dateL < nowL + 21600000L) { // 今天6点前
            return "凌晨 " + getTime(date);
        } else if (dateL < nowL + 43200000L) { // 今天12点前
            return "早上 " + getTime(date);
        } else if (dateL < nowL + 64800000L) { // 今天18点前
            return "下午 " + getTime(date);
        } else if (dateL < nowL + 86400000L) { // 明天0时前
            return "晚上 " + getTime(date);
        } else if (dateL < nowL + 172800000L) { // 晚今天0时48小时内
            return "明天 " + getTime(date);
        } else if (dateL < nowL + 259200000L) { // 晚今天0时72小时内
            return "后天 " + getTime(date);
        } else {
            return getDateOneYear(date);
        }
    }

    public static String getBaseDate(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日 HH:00", Locale.getDefault());
        return sdf.format(date);
    }
    public static String getDateOneYear(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日", Locale.getDefault());
        return sdf.format(date);
    }

    public static String getDate(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat("MM月dd日", Locale.getDefault());
        return sdf.format(date);
    }

    public static String getTime(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm", Locale.getDefault());
        return sdf.format(date);
    }

    public static String getWeek(int value) {
        switch (value) {
            case 1:
                return "周日";
            case 2:
                return "周一";
            case 3:
                return "周二";
            case 4:
                return "周三";
            case 5:
                return "周四";
            case 6:
                return "周五";
            default:
                return "周六";
        }

    }

    public static List<NaviLatLng> coverPoint(List<Double[]> mapList) {
        List<NaviLatLng> list = new ArrayList<>();
        if (mapList == null) return list;
        for (int i = 0; i < mapList.size(); i++) {
            Double[] map = mapList.get(i);
            if (map.length != 2) continue;
            list.add(new NaviLatLng(toDouble(map[0]), toDouble(map[1])));
        }
        return list;
    }

    private static double toDouble(Object o) {
        try {
            return Double.parseDouble(String.valueOf(o));
        } catch (Exception e) {
            return 0d;
        }
    }
}
