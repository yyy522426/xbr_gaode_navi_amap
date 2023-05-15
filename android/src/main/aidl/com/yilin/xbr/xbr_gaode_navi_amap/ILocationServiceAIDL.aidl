// ILocationServiceAIDL.aidl
package com.yilin.xbr.xbr_gaode_navi_amap;

// Declare any non-default types here with import statements

interface ILocationServiceAIDL {
    /** hook when other service has already binded on it */
    void onFinishBind();
}