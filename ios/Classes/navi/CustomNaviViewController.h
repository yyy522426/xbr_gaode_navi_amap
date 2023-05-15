#import <Flutter/Flutter.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <UIKit/UIKit.h>

@protocol  DriveNaviViewControllerDelegate;
@interface CustomNaviViewController : UIViewController

//驾驶地图视图
@property(nonatomic,strong) AMapNaviDriveView *driveView;
//控制器
@property(nonatomic,weak) id<DriveNaviViewControllerDelegate> delegate;

- (void)startCalculateRoute:(NSArray *)wayPoints emulator:(id) emulator startPoint:(AMapNaviPoint *)startPoint endPoint:(AMapNaviPoint *)endPoint;

@end
