package com.yilin.xbr.xbr_gaode_navi_amap.navi;

import android.content.Intent;
import android.graphics.Rect;
import android.os.Bundle;
import android.text.SpannableString;
import android.text.SpannableStringBuilder;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.amap.api.maps.AMap;
import com.amap.api.navi.AMapNaviView;
import com.amap.api.navi.enums.NaviType;
import com.amap.api.navi.model.AMapCalcRouteResult;
import com.amap.api.navi.model.AMapCarInfo;
import com.amap.api.navi.model.AMapNaviLocation;
import com.amap.api.navi.model.NaviInfo;
import com.amap.api.navi.model.NaviLatLng;
import com.amap.api.navi.view.DriveWayView;
import com.amap.api.navi.view.NextTurnTipView;
import com.amap.api.navi.view.OverviewButtonView;
import com.amap.api.navi.view.TrafficButtonView;
import com.amap.api.navi.view.TrafficProgressBar;
import com.amap.api.navi.view.ZoomInIntersectionView;
import com.google.gson.reflect.TypeToken;
import com.yilin.xbr.xbr_gaode_navi_amap.R;
import com.yilin.xbr.xbr_gaode_navi_amap._code.GsonUtil;
import com.yilin.xbr.xbr_gaode_navi_amap.navi.utils.DensityUtils;
import com.yilin.xbr.xbr_gaode_navi_amap.navi.utils.NaviUtil;

import java.util.Date;
import java.util.List;


public class CustomNaviActivity extends BaseNaviActivity {
    private NextTurnTipView myNextTurnTipView;
    private TextView textNextRoadDistance;
    private TextView textNextRoadDistanceUnit;
    private TextView textNextRoadName;
    private TrafficProgressBar myTrafficProgressBar;
    private DriveWayView myDriveWayView;
    private ZoomInIntersectionView zoomInIntersectionView;
    private OverviewButtonView overviewButtonView;
    private TrafficButtonView trafficButtonView;
    private LinearLayout subInfoViewLayout;
    private Button lockInfoBtn;
    private TextView navLoadNameTextView;
    private LinearLayout navSpeedView;
    private TextView navSpeedTextView;
    private Button exitBtn;
    private LinearLayout exitBtnGroup;
    private ImageView gpsStateView;
    private TextView distanceInfo;
    private TextView timerInfo;
    private TextView titleView;
    private TextView subTitleView;

    private boolean navComplete = false;
    private boolean mavTypeEmu = false;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_custom_navi);
        mAMapNaviView = (AMapNaviView) findViewById(R.id.custom_navi_view);
        mAMapNaviView.onCreate(savedInstanceState);
        mAMapNaviView.setAMapNaviViewListener(this);
        //路口转向提示
        myNextTurnTipView = findViewById(R.id.my_icon_next_turn_tip);
        textNextRoadDistance =  findViewById(R.id.text_next_road_distance);
        textNextRoadDistanceUnit =  findViewById(R.id.text_next_road_distance_unit);
        textNextRoadName = findViewById(R.id.text_next_road_name);
        //路况条
        myTrafficProgressBar =findViewById(R.id.my_traffic_progress_bar);
        //交通车道线
        myDriveWayView= findViewById(R.id.my_drive_way_view);
        //路口放大图
        zoomInIntersectionView= findViewById(R.id.my_zoom_intersection_view);
        //内置按钮
        overviewButtonView= findViewById(R.id.nav_overview_button_view);
        trafficButtonView= findViewById(R.id.nav_traffic_button_view);
        //道路名称
        navLoadNameTextView =  findViewById(R.id.nav_load_name);
        //速度/文字
        navSpeedView = findViewById(R.id.nav_speed_view);
        navSpeedTextView =  findViewById(R.id.nav_speed_text_view);
        //信号
        gpsStateView =  findViewById(R.id.gps_state_view);
        //底部 2X
        subInfoViewLayout = findViewById(R.id.sub_info_views);
        distanceInfo= findViewById(R.id.distance_info);
        timerInfo = findViewById(R.id.timer_info);
        lockInfoBtn = findViewById(R.id.lock_info_btn);
        exitBtn = findViewById(R.id.exit_btn);
        exitBtnGroup = findViewById(R.id.exit_btn_group);
        titleView = findViewById(R.id.title);
        subTitleView = findViewById(R.id.subtitle);

        mAMapNaviView.getMap().setMapType(AMap.MAP_TYPE_NAVI);//
        if (mAMapNavi!=null && mAMapNavi.getNaviSetting()!=null){
            mAMapNavi.getNaviSetting().setScreenAlwaysBright(false);
        }
        initCustomView();
    }

    public void initCustomView(){
        //关闭原生UI
        //设置布局完全不可见
        mAMapNaviView.getViewOptions().setLayoutVisible(false);
        // 设置是否显示路口放大图(路口模型图)(实景图)
        mAMapNaviView.getViewOptions().setModeCrossDisplayShow(true);
        mAMapNaviView.getViewOptions().setRealCrossDisplayShow(true);
        mAMapNaviView.getViewOptions().setRouteListButtonShow(true);
        mAMapNaviView.getViewOptions().setAutoLockCar(true);
        mAMapNaviView.getViewOptions().setAutoChangeZoom(true);
        mAMapNaviView.getViewOptions().setAfterRouteAutoGray(true);
        mAMapNaviView.getViewOptions().setCrossLocation(new Rect(0,30,260,300), getCrossLocation());
        mAMapNaviView.getViewOptions().setPointToCenter(0.5, 0.65);
        //设置自定义转向
        mAMapNaviView.setLazyNextTurnTipView(myNextTurnTipView);
        //路况条
        mAMapNaviView.setLazyTrafficProgressBarView(myTrafficProgressBar);
        //车道线
        mAMapNaviView.setLazyDriveWayView(myDriveWayView);
        //实景图
        mAMapNaviView.setLazyZoomInIntersectionView(zoomInIntersectionView);
        mAMapNaviView.setLazyOverviewButtonView(overviewButtonView);
        mAMapNaviView.setLazyTrafficButtonView(trafficButtonView);
        ///设置锁车
        lockInfoBtn.setOnClickListener(v -> mAMapNaviView.setShowMode(1));
        ///退出和确认退出
        exitBtn.setOnClickListener(view -> {
            exitBtnGroup.setVisibility(View.VISIBLE);
            exitBtn.setVisibility(View.INVISIBLE);

            mAMapNaviView.setShowMode(3);
            subInfoViewLayout.setVisibility(View.INVISIBLE);
            lockInfoBtn.setVisibility(View.INVISIBLE);
        });
        exitBtnGroup.findViewById(R.id.qx_exit_btn).setOnClickListener(view -> {
            exitBtnGroup.setVisibility(View.INVISIBLE);
            exitBtn.setVisibility(View.VISIBLE);

            subInfoViewLayout.setVisibility(View.INVISIBLE);
            lockInfoBtn.setVisibility(View.VISIBLE);
        });
        exitBtnGroup.findViewById(R.id.sure_exit_btn).setOnClickListener(view -> {
            Intent intent = new Intent();//数据是使用Intent返回
            intent.putExtra("nav_complete", navComplete);//把返回数据存入Intent
            this.setResult(XbrAMapNaviPlugin.COLLECT_OK_CODE,intent);//设置返回数据
            finish();
        });
        //设置导航数据
        String pointsJson =  getIntent().getStringExtra("pointsJson");
        List<Double[]> mapPoints = GsonUtil.fromJson(pointsJson, new TypeToken<List<Double[]>>() {});
        List<NaviLatLng> naviLatLngList = NaviUtil.coverPoint(mapPoints);
        if (naviLatLngList.size() >= 2){
            sList.add(naviLatLngList.get(0));
            eList.add(naviLatLngList.get(naviLatLngList.size()-1));
        }
        //设置内容
        String title = getIntent().getStringExtra("title");
        if (title==null) titleView.setVisibility(View.GONE);
        titleView.setText(title);
        String subTitle = getIntent().getStringExtra("subtext");
        if (subTitle==null) {
            subTitleView.setVisibility(View.GONE);
            distanceInfo.setTextSize(16);
            timerInfo.setTextSize(14);
        }
        subTitleView.setText(subTitle);
        //虚拟导航
        mavTypeEmu = getIntent().getBooleanExtra("emulator",false);
    }

    @Override
    public void onBackPressed() {
//        super.onBackPressed();
        exitBtnGroup.setVisibility(View.VISIBLE);
        exitBtn.setVisibility(View.INVISIBLE);

        mAMapNaviView.setShowMode(3);
        subInfoViewLayout.setVisibility(View.INVISIBLE);
        lockInfoBtn.setVisibility(View.INVISIBLE);
    }

    @Override
    public void onNaviInfoUpdate(NaviInfo naviInfo) {
        navLoadNameTextView.setText(naviInfo.getCurrentRoadName());
        //更新下一路口 路名及 距离
        textNextRoadName.setText(naviInfo.getNextRoadName());
        String formatKM = NaviUtil.formatKMUnit(naviInfo.getCurStepRetainDistance());
        textNextRoadDistance.setText(formatKM.split(",")[0]);
        textNextRoadDistanceUnit.setText(formatKM.split(",")[1]);

        SpannableString kmSpan = NaviUtil.formatKMSpan(naviInfo.getPathRetainDistance());
        SpannableStringBuilder formatTimeSecSpan = NaviUtil.formatTimeSecSpan((long) naviInfo.getPathRetainTime());
        distanceInfo.setText(new SpannableStringBuilder().append(kmSpan).append(", ").append(formatTimeSecSpan));

        String autoTime = NaviUtil.getAutoTime(NaviUtil.addTimeSec(new Date(), naviInfo.getPathRetainTime()));
        timerInfo.setText(String.format("预计%s到达", autoTime));
    }

    @Override
    public void onArriveDestination() {
        //到达目的地
        navComplete = true;
        distanceInfo.setText("已到达目的地");
        timerInfo.setText("您已成功抵达目的地");
    }

    @Override
    public void onLocationChange(AMapNaviLocation location) {
        //当前位置回调
        navSpeedTextView.setText(String.valueOf((int)location.getSpeed()));
    }

    @Override
    public void onNaviViewShowMode(int showMode){
        //showMode 1-锁车态 2-全览态 3-普通态
        if (showMode == 1) {
            subInfoViewLayout.setVisibility(View.VISIBLE);
            lockInfoBtn.setVisibility(View.INVISIBLE);
            navSpeedView.setVisibility(View.VISIBLE);

            exitBtnGroup.setVisibility(View.INVISIBLE);
            exitBtn.setVisibility(View.VISIBLE);
        }else if (showMode == 3){
            subInfoViewLayout.setVisibility(View.INVISIBLE);
            lockInfoBtn.setVisibility(View.VISIBLE);
            navSpeedView.setVisibility(View.INVISIBLE);
        }
    }


    @Override
    public void onGpsSignalWeak(boolean b) {
        gpsStateView.setImageResource(b?R.drawable.gps_bad:R.drawable.gps_goods);
    }

    public Rect getCrossLocation(){
        RelativeLayout naviSdkAutoNaviPortLeftWidget = findViewById(R.id.navi_sdk_autonavi_port_leftwidget);
        int h = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
        naviSdkAutoNaviPortLeftWidget.measure(0, h);
        int height = naviSdkAutoNaviPortLeftWidget.getMeasuredHeight();
        /// spRect:竖屏
        return new Rect(0,height, DensityUtils.getScreenWidth(getApplicationContext()),
            DensityUtils.dp2px(getApplicationContext(),300));
    }

    @Override
    public void onInitNaviSuccess() {
        super.onInitNaviSuccess();
        int strategy =  getIntent().getIntExtra("strategy",-1);//策略
        if (strategy==-1){
            try {
                strategy = mAMapNavi.strategyConvert(true, false, false, false, false);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        AMapCarInfo carInfo = new AMapCarInfo();
        carInfo.setCarNumber("京DFZ588");
        mAMapNavi.setCarInfo(carInfo);
        mAMapNavi.calculateDriveRoute(sList, eList, mWayPointList, strategy);
    }

    @Override
    public void onCalculateRouteSuccess(AMapCalcRouteResult aMapCalcRouteResult) {
        super.onCalculateRouteSuccess(aMapCalcRouteResult);
        mAMapNavi.startNavi(mavTypeEmu?NaviType.EMULATOR:NaviType.GPS);
    }
}
