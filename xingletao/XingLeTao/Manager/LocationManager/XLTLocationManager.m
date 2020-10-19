//
//  XLTLocationManager.m
//  XingLeTao
//
//  Created by chenhg on 2020/6/28.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "AFHTTPSessionManager.h"
#import "XLTNetworkHelper.h"
#import "XLTAppPlatformManager.h"

@interface XLTLocationManager () <CLLocationManagerDelegate>
//定位管理器
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D lastCoordinate;
@property (nonatomic, assign) CLLocationCoordinate2D lastAMapCoordinate;
@property (nonatomic, assign) BOOL isAMapConverting;
@property (nonatomic, assign) BOOL didUpdatingLocation;
@property (nonatomic, assign) BOOL isAMapConverted;

@end

@implementation XLTLocationManager

/**
 * 获取单例实例
 *
 * @return 单例实例
 */
+ (instancetype) sharedInstance {
    static XLTLocationManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
         instance = [[XLTLocationManager alloc]init];
        }
    });
    return instance;
}

/*
 懒加载初始化定位管理器
 */
- (CLLocationManager *)locationManager {
    //如果定位不可用，直接返回
    if(![CLLocationManager locationServicesEnabled]){
        return nil;
    }
    if(_locationManager == nil){
        //创建定位管理器
        _locationManager = [[CLLocationManager alloc] init];
        // 设定定位精准度
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        //设置当前类实现定位代理方法
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (void)startUpdatingLocation {
    if ([XLTAppPlatformManager shareManager].checkEnable) {
        // 先判断是否可使用定位服务
        if ([CLLocationManager locationServicesEnabled] == NO) {
            return ;
        }
        // 获取当前授权状态
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus] ;
           
        switch (status) {
            case kCLAuthorizationStatusAuthorizedWhenInUse:
            case kCLAuthorizationStatusAuthorizedAlways:
                [self.locationManager startUpdatingLocation];
                break;
            case kCLAuthorizationStatusDenied:
                // 用户拒绝使用定位，可在此引导用户开启
                break;
            case kCLAuthorizationStatusRestricted:
                // 权限受限，可引导用户开启
                break;
            case kCLAuthorizationStatusNotDetermined:
                // 未选择，一般是首次启动，根据需要发起申请
                [self.locationManager requestWhenInUseAuthorization];
                break;
            default:
                break;
        }
    }
}

- (void)stopUpdatingLocation {
    [self.locationManager stopUpdatingLocation];
}


/*
 CLLocationManagerDelegate方法：更新定位信息
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations firstObject];
    if (location.horizontalAccuracy > 0) {
        //获取当前位置经纬度
        CLLocationCoordinate2D coordinate = location.coordinate;
//        NSLog(@"latitude: %f, longitude: %f", coordinate.latitude, coordinate.longitude);
        self.lastCoordinate = coordinate;
        if (!self.isAMapConverting) {
            self.isAMapConverting = YES;
            __weak typeof(self)weakSelf = self;
            [self convertToAMapCoordinate:coordinate success:^(BOOL success, CLLocationCoordinate2D amapCoordinate) {
                if (success) {
                    weakSelf.lastAMapCoordinate = amapCoordinate;
                    weakSelf.isAMapConverted = YES;
                    [weakSelf didConvertToAMapCoordinateSuccess];
                }
                weakSelf.isAMapConverting = NO;
            }];
        }
        [self stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
            [manager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusDenied:
            // 用户拒绝使用定位，可在此引导用户开启
            break;
        case kCLAuthorizationStatusRestricted:
            // 权限受限，可引导用户开启
            break;
        case kCLAuthorizationStatusNotDetermined:
            // 未选择，在代理方法里，一般不会有这个状态，如果有m，再次发起申请
            break;
        default:
            break;
    }
}


/**
* 高德坐标系转换 https://lbs.amap.com/api/webservice/guide/api/convert
*
*/

- (void)convertToAMapCoordinate:(CLLocationCoordinate2D)coordinate success:(void(^)(BOOL success,CLLocationCoordinate2D amapCoordinate))success {
    CLLocationDegrees latitude = coordinate.latitude;
    CLLocationDegrees longitude = coordinate.longitude;
    success(YES,CLLocationCoordinate2DMake(latitude, longitude));
}

- (void)didConvertToAMapCoordinateSuccess {
    NSNumber *longitude =  [NSNumber numberWithDouble:self.lastAMapCoordinate.longitude];
    NSNumber *latitude =  [NSNumber numberWithDouble:self.lastAMapCoordinate.latitude];
    [XLTNetworkHelper setValue:[longitude stringValue] forHTTPHeaderField:@"x-lng"];
    [XLTNetworkHelper setValue:[latitude stringValue] forHTTPHeaderField:@"x-lat"];
}


- (void)updateAMapCoordinateHeaderForManager:(AFHTTPSessionManager *)sessionManager {
    if (self.isAMapConverted) {
        [self didConvertToAMapCoordinateSuccess];
    } else {
        if (self.didUpdatingLocation) {
            if (!self.isAMapConverting) {
                self.isAMapConverting = YES;
                __weak typeof(self)weakSelf = self;
                [self convertToAMapCoordinate:self.lastCoordinate success:^(BOOL success, CLLocationCoordinate2D amapCoordinate) {
                    if (success) {
                        weakSelf.lastAMapCoordinate = amapCoordinate;
                        weakSelf.isAMapConverted = YES;
                        [weakSelf didConvertToAMapCoordinateSuccess];
                    }
                    weakSelf.isAMapConverting = NO;
                }];
            }
        } else {
            [self startUpdatingLocation];
        }
    }
}

@end

