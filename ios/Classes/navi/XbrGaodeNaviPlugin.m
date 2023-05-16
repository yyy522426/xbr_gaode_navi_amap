#import "XbrGaodeNaviPlugin.h"
#import "CustomNaviViewController.h"

@implementation XbrGaodeNaviPlugin
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"startNavi" isEqualToString:call.method]){
      NSString* pointsJson = call.arguments[@"pointsJson"];
      id emulator = call.arguments[@"emulator"];
      NSData *data = [pointsJson dataUsingEncoding:NSUTF8StringEncoding];
      //用数组来接收
      NSArray *pointArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
      //点位也是一个数组 起点数组
      NSArray<NSNumber *>* sp = [pointArr firstObject];
      //点位也是一个数组 终点 [0-lat,1-lon]
      NSArray<NSNumber *>* ep = [pointArr lastObject];
      //起点对象
      AMapNaviPoint* origin =[AMapNaviPoint locationWithLatitude:sp[0].doubleValue longitude:sp[1].doubleValue];
      //终点对象
      AMapNaviPoint* destination =[AMapNaviPoint locationWithLatitude:ep[0].doubleValue longitude:ep[1].doubleValue];
      //构造途径点对象集合
      NSMutableArray<AMapNaviPoint *> *waypoints = [NSMutableArray arrayWithCapacity:pointArr.count-2];
      if (pointArr.count > 2) {
         //遍历跳开起点和终点
         for (NSInteger i=1; i<pointArr.count-1;i++) {
             NSArray<NSNumber *>* wp = [pointArr objectAtIndex:i];
             AMapNaviPoint* wc =[AMapNaviPoint locationWithLatitude:wp[0].doubleValue longitude:wp[1].doubleValue];
             [waypoints addObject:wc];
         }
      }
      CustomNaviViewController* controller = [[CustomNaviViewController alloc]init];
      [controller startCalculateRoute:waypoints emulator:emulator startPoint:origin endPoint:destination];
      
      UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
      navi.navigationBarHidden = true;
      navi.modalPresentationStyle = UIModalPresentationFullScreen;
      [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navi animated:YES completion:nil];
  }
}


@end
