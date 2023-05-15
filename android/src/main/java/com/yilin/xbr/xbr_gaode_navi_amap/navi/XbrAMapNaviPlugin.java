package com.yilin.xbr.xbr_gaode_navi_amap.navi;
import android.content.Intent;
import androidx.annotation.NonNull;
import com.amap.api.navi.AMapNavi;
import com.amap.api.navi.NaviSetting;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;


/** XbrGaodeNaviPlugin */
public class XbrAMapNaviPlugin  {
  private static final int COLLECT_REQ_CODE = 19491001; /// I love China
  public static final int COLLECT_OK_CODE = 10011949; /// I love China

  private final ActivityPluginBinding binding;

  public XbrAMapNaviPlugin(ActivityPluginBinding binding) {
    this.binding = binding;
  }

  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if ("startNavi".equals(call.method)) {
      String title = null, subtext = null, pointsJson = null;
      Integer strategy = null;
      Boolean emulator = null;
      if (call.hasArgument("pointsJson")) pointsJson = call.argument("pointsJson");
      if (call.hasArgument("strategy")) strategy = call.argument("strategy");
      if (call.hasArgument("title")) title = call.argument("title");
      if (call.hasArgument("subtext")) subtext = call.argument("subtext");
      if (call.hasArgument("emulator")) emulator = call.argument("emulator");
      if (strategy == null) strategy = 0;
      if (emulator == null) emulator = false;
      if (pointsJson != null) {
        startNavi(strategy, emulator, title, subtext, pointsJson, result);
      } else {
        result.success("FAIL:pointsJson is null");
      }
    }
  }

  /**
   * 开始导航
   * */
  public void startNavi(Integer strategy,boolean emulator,String title,String subtext,String pointsJson,Result result) {
    Intent intent = new Intent(binding.getActivity(), CustomNaviActivity.class);
    intent.putExtra("pointsJson",pointsJson);
    intent.putExtra("strategy",strategy);
    intent.putExtra("title",title);
    intent.putExtra("subtext",subtext);
    intent.putExtra("emulator",emulator);
    binding.getActivity().startActivityForResult(intent,9998);
    binding.addActivityResultListener((requestCode, resultCode, data) -> {
      if (requestCode == COLLECT_REQ_CODE) {
        if (result != null) {
          if (resultCode == 9998) {
            boolean complete = data.getBooleanExtra("nav_complete", false);
            result.success(complete?"SUCCESS":"FAIL");
            return false;
          }
          result.success("ERR");
        }
      }
      return false;
    });
  }


}
