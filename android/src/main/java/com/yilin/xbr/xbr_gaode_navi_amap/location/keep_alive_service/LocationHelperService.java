package com.yilin.xbr.xbr_gaode_navi_amap.location.keep_alive_service;

import android.app.Service;
import android.content.ComponentName;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.os.RemoteException;

import androidx.annotation.Nullable;

import com.yilin.xbr.xbr_gaode_navi_amap.ILocationHelperServiceAIDL;
import com.yilin.xbr.xbr_gaode_navi_amap.ILocationServiceAIDL;
import com.yilin.xbr.xbr_gaode_navi_amap.location.keep_alive_service.utils.Utils;

/**
 * Created by liangchao_suxun on 17/1/18.
 */
public class LocationHelperService extends Service {

    private Utils.CloseServiceReceiver mCloseReceiver;

    @Override
    public void onCreate() {
        super.onCreate();
        startBind();
        mCloseReceiver = new Utils.CloseServiceReceiver(this);
        registerReceiver(mCloseReceiver, Utils.getCloseServiceFilter());
    }

    @Override
    public void onDestroy() {
        if (mInnerConnection != null) {
            unbindService(mInnerConnection);
            mInnerConnection = null;
        }
        if (mCloseReceiver != null) {
            unregisterReceiver(mCloseReceiver);
            mCloseReceiver = null;
        }
        super.onDestroy();
    }

    private ServiceConnection mInnerConnection;
    private void startBind() {
        final String locationServiceName = "com.yilin.xbr.xbr_gaode_navi_amap.location.keep_alive_service.LocationService";
        mInnerConnection = new ServiceConnection() {
            @Override
            public void onServiceDisconnected(ComponentName name) {
                Intent intent = new Intent();
                intent.setAction(locationServiceName);
                startService(Utils.getExplicitIntent(getApplicationContext(), intent));
            }
            @Override
            public void onServiceConnected(ComponentName name, IBinder service) {
                ILocationServiceAIDL l = ILocationServiceAIDL.Stub.asInterface(service);
                try {
                    l.onFinishBind();
                } catch (RemoteException e) {
                    e.printStackTrace();
                }
            }
        };
        Intent intent = new Intent();
        intent.setAction(locationServiceName);
        bindService(Utils.getExplicitIntent(getApplicationContext(), intent), mInnerConnection, Service.BIND_AUTO_CREATE);
    }

    private HelperBinder mBinder;
    private class HelperBinder extends ILocationHelperServiceAIDL.Stub{
        @Override
        public void onFinishBind(int notiId) {
            startForeground(notiId, Utils.buildNotification(LocationHelperService.this.getApplicationContext()));
            stopForeground(true);
        }
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        if (mBinder == null) {
            mBinder = new HelperBinder();
        }
        return mBinder;
    }
}
