#import <Flutter/Flutter.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface XbrGaodeSearchPlugin : NSObject<FlutterPlugin>

@property (nonatomic,retain) AMapSearchAPI* search;
@property (nonatomic,retain) id resultMap;
@property (nonatomic,retain) id onlyOne;
@property (nonatomic,retain) NSNumber* showFields;
@end
