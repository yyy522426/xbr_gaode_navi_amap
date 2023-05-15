#import "XbrGaodeNaviAmapPlugin.h"
#import "AMapFlutterFactory.h"

@implementation XbrGaodeNaviAmapPlugin{
  NSObject<FlutterPluginRegistrar>* _registrar;
  FlutterMethodChannel* _channel;
  NSMutableDictionary* _mapControllers;
}

@implementation XbrGaodeNaviAmapPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  //#### 公共方法注册通道
  FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"xbr_gaode_navi_amap" binaryMessenger:[registrar messenger]];
  XbrGaodeNaviAmapPlugin* instance = [[XbrGaodeNaviAmapPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
  //#### 地图：注册视图控件
  AMapFlutterFactory* aMapFactory = [[AMapFlutterFactory alloc] initWithRegistrar:registrar];
  [registrar registerViewFactory:aMapFactory withId:@"com.yilin.xbr.amap" gestureRecognizersBlockingPolicy: FlutterPlatformViewGestureRecognizersBlockingPolicyWaitUntilTouchesEnded];
  //#### 定位：設置事件通道
  FlutterEventChannel *eventChanel = [FlutterEventChannel eventChannelWithName:@"xbr_gaode_location_stream" binaryMessenger:[registrar messenger]];
  [eventChanel setStreamHandler:[[AMapFlutterStreamManager sharedInstance] streamHandler]];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
