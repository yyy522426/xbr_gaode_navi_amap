//
//  CustomNaviView.m
//  xbr_gaode_navi
//
//  Created by 易林物流 on 2023/3/17.
//

#import <Foundation/Foundation.h>
#import "CustomNaviViewController.h"
#import "SpeechSynthesizer.h"

@interface CustomNaviViewController ()<AMapNaviDriveManagerDelegate, AMapNaviDriveViewDelegate>

@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;
@property (nonatomic, strong) NSArray<AMapNaviPoint *> *wayPoints;
@property (nonatomic, strong) id emulator;
@property (nonatomic, strong) UISegmentedControl *showMode;
@property (nonatomic, strong) UIButton *trafficLayerButton;
@property (nonatomic, strong) UIButton *zoomInButton;
@property (nonatomic, strong) UIButton *zoomOutButton;

@end

@implementation CustomNaviViewController



#pragma mark - Life Cycle
- (instancetype)init{
    if (self = [super init]){
        [self initDriveView];
        [self initDriveManager];
    }
    return self;
}

- (void)initDriveView {
    if (self.driveView == nil) {
        self.driveView = [[AMapNaviDriveView alloc] initWithFrame:self.view.bounds];
        self.driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.driveView setAutoZoomMapLevel:YES];
        //[self.driveView setMapViewModeType:AMapNaviViewMapModeTypeNight];
        [self.driveView setTrackingMode:AMapNaviViewTrackingModeCarNorth];
        [self.driveView setShowMoreButton:NO];
        [self.driveView setDelegate:self];
        [self.view addSubview:self.driveView];
    }
}

#pragma mark - DriveView Delegate
- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView{
    //停止导航
    [[AMapNaviDriveManager sharedInstance]  stopNavi];
    [[AMapNaviDriveManager sharedInstance]  removeDataRepresentative:self.driveView];
    
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    
    BOOL success = [AMapNaviDriveManager destroyInstance];
    NSLog(@"单例是否销毁成功 : %d",success);
    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initDriveManager {
    [[AMapNaviDriveManager sharedInstance] setDelegate:self];
    
    //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
    [[AMapNaviDriveManager sharedInstance] addDataRepresentative:self.driveView];
}

- (void)startCalculateRoute:(NSArray<AMapNaviPoint *> *)wayPoints emulator:(id)emulator
                 startPoint:(AMapNaviPoint *)startPoint endPoint:(AMapNaviPoint *)endPoint;{
    //为了方便展示,选择了固定的起终点
    self.startPoint = startPoint;
    self.endPoint   = endPoint;
    if([wayPoints count]>0) self.wayPoints= wayPoints;
    self.emulator   = emulator;
    [self calculateRoute];
}

//开始算路
#pragma mark - Route Plan
- (void)calculateRoute {
    
    //进行路径规划
    [[AMapNaviDriveManager sharedInstance] calculateDriveRouteWithStartPoints:@[self.startPoint]
                                                endPoints:@[self.endPoint]
                                                wayPoints:self.wayPoints.count>0?@[self.wayPoints]:nil
                                          drivingStrategy:AMapNaviDrivingStrategySingleDefault];
}

//算路结果回调
- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteSuccessWithType:(AMapNaviRoutePlanType)type;
{
    NSLog(@"onCalculateRouteSuccess");
 
    //算路成功后开始模拟导航
    if(((BOOL)self.emulator) == true){
        [[AMapNaviDriveManager sharedInstance] startEmulatorNavi];
    }else{
        [[AMapNaviDriveManager sharedInstance] startGPSNavi];
    }
}

//销毁
- (void)dealloc {
    [[AMapNaviDriveManager sharedInstance] stopNavi];
       [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:self.driveView];
       [[AMapNaviDriveManager sharedInstance] setDelegate:nil];
       
       BOOL success = [AMapNaviDriveManager destroyInstance];
       NSLog(@"单例是否销毁成功 : %d",success);
       
       [self.driveView removeFromSuperview];
       self.driveView.delegate = nil;
}

- (BOOL)driveManagerIsNaviSoundPlaying:(AMapNaviDriveManager *)driveManager
{
    return [[SpeechSynthesizer sharedSpeechSynthesizer] isSpeaking];
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}


@end
