//
//  WHExteriorNavicationController.m
//  CZBWebProjectDemoForOC
//
//  Created by 边智峰 on 2018/11/14.
//  Copyright © 2018 czb365.com. All rights reserved.
//

#import "WHExteriorNavicationController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface WHExteriorNavicationController()

@end

@implementation WHExteriorNavicationController

/// 获取最顶层的控制器并返回
///
/// - Returns: 返回目前处于present最顶层的控制器
- (UIViewController *)aboveViewController {
    UIViewController *aboveController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (aboveController.presentedViewController != nil) {
        aboveController = aboveController.presentedViewController;
    }
    return aboveController;
}

/// 根据传入地图类型,判断是否安装地图软件
///
/// - Parameter mapType: 地图类型
/// - Returns: 地图是否安装,bool值
+ (BOOL)canOpen:(WHExteriorMapType)mapType {
    if (mapType == appleMap) {
        return true;
    }
    NSArray *mapTypeArray = @[@"baidumap://", @"iosamap://", @"appleMap://", @"qqmap://"];
    NSURL *url = [[NSURL alloc] initWithString: mapTypeArray[mapType]];
    return [[UIApplication sharedApplication] canOpenURL:url];
}

/// 打开腾讯地图 进行导航
///
/// - Parameters:
///   - destination: 目的地坐标
///   - origin: 起始位置坐标,必选 否则不能开始导航
///   - mode: 驾驶模式,公交：bus, 驾车：drive（默认）, 步行：walk（仅适用移动端）
///   - coordType: 1 GPS（默认）; 2 腾讯坐标,火星坐标
+ (void)openTencentMap:(CLLocationCoordinate2D)destination origin:(CLLocationCoordinate2D)origin mode:(NSString *)mode coordType:(NSString *)coordType {
    //model default drive coordType default 2
    if ([WHExteriorNavicationController canOpen:tencentMap]) {
        
        NSString *originValue = [NSString stringWithFormat:@"%lf,%lf", origin.latitude, origin.longitude];
        NSString *destinationValue = [NSString stringWithFormat:@"%lf,%lf", destination.latitude, destination.longitude];
        NSString *src = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
        NSString *urlString = [NSString stringWithFormat:@"qqmap://map/routeplan?type=%@&fromcoord=%@&tocoord=%@&policy=0&referer=%@", mode, originValue, destinationValue, src];
        [WHExteriorNavicationController openMap:urlString];
    } else {
        NSLog(@"无法打开腾讯地图");
    }
}

/// 打开高德地图进行导航
///
/// - Parameters:
///   - destination: 目的地坐标
///   - origin: 起始坐标
///   - mode: 导航模式,驾车：mode=car,公交:：mode=bus；步行：mode=walk；骑行：mode=ride；
///   - coordType: 坐标系类型,坐标系参数coordinate=gaode,表示高德坐标（gcj02坐标），coordinate=wgs84,表示wgs84坐标（GPS原始坐标）
+ (void)openGaodeMap:(CLLocationCoordinate2D)destination {
    if ([WHExteriorNavicationController canOpen:gaodeMap]) {
        NSString *src = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
        NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=&lat=%lf&lon=%lf&dev=0&style=2", src, destination.latitude, destination.longitude];
        [WHExteriorNavicationController openMap:urlString];
    } else {
        NSLog(@"无法打开高德地图");
    }
}
/// 打开百度地图 进行导航
///
/// - Parameters:
///   - destination: 目的地坐标
///   - origin: 起始位置坐标
///   - mode: 导航模式,固定为transit、driving（默认）、navigation、walking，riding分别表示公交、驾车、导航、步行和骑行
///   - coordType: 允许的值为bd09ll、bd09mc、gcj02、wgs84（默认）。bd09ll表示百度经纬度坐标，bd09mc表示百度墨卡托坐标，gcj02表示经过国测局加密的坐标，wgs84表示gps获取的坐标。
+ (void)openBaiduMap:(CLLocationCoordinate2D)destination origin:(CLLocationCoordinate2D)origin mode:(NSString *)mode coordType:(NSString *)coordType {
    //model default driving coordType default gcj02
    if ([WHExteriorNavicationController canOpen:baiduMap]) {
        NSString *originValue = [NSString stringWithFormat:@"%lf,%lf", origin.latitude, origin.longitude];
        NSString *destinationValue = [NSString stringWithFormat:@"%lf,%lf", destination.latitude, destination.longitude];
        NSString *src = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
        NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=%@&destination=%@&mode=%@&src=%@&coord_type=%@", originValue, destinationValue, mode, src, coordType];
        [WHExteriorNavicationController openMap:urlString];
    } else {
        NSLog(@"无法打开百度地图");
    }
}
/// 打开苹果地图进行导航
///
/// - Parameters:
///   - destination: 目的地坐标
///   - mode: 导航模式,MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsDirectionsModeWalking, MKLaunchOptionsDirectionsModeTransit
+ (void)openAppleMap:(CLLocationCoordinate2D)destination {
    if ([WHExteriorNavicationController canOpen:appleMap]) {
        MKPlacemark *destinationPlaceMark = [[MKPlacemark alloc] initWithCoordinate:destination addressDictionary:nil];
        MKMapItem *destinationMapItem = [[MKMapItem alloc] initWithPlacemark:destinationPlaceMark];
        destinationMapItem.name = @"目的地";
        MKMapItem *originLocation = [MKMapItem mapItemForCurrentLocation];
        originLocation.name = @"我的位置";
        [MKMapItem openMapsWithItems: @[originLocation, destinationMapItem] launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:true]}];
    } else {
        NSLog(@"无法打开苹果地图");
    }
}

/// 根据urlString, 打开对应的应用
+ (void)openMap: (NSString *)urlString {
    NSString *uString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSURL *url = [[NSURL alloc] initWithString:uString];
    [UIApplication.sharedApplication openURL:url];
}


+ (void)quickNavication:(void(^)(WHExteriorMapType))callBack {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择导航方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if ([WHExteriorNavicationController canOpen:appleMap]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            callBack(appleMap);
        }]];
    }
    if ([WHExteriorNavicationController canOpen:baiduMap]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            callBack(baiduMap);
        }]];
    }
    if ([WHExteriorNavicationController canOpen:gaodeMap]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            callBack(gaodeMap);
        }]];
    }
    if ([WHExteriorNavicationController canOpen:tencentMap]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"腾讯地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            callBack(tencentMap);
        }]];
    }
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler: nil]];
    [[[WHExteriorNavicationController new] aboveViewController] presentViewController:alertController animated:true completion:nil];
}
@end
