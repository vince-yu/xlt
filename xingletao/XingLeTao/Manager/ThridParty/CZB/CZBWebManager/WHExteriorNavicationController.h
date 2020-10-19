//
//  WHExteriorNavicationController.h
//  CZBWebProjectDemoForOC
//
//  Created by 边智峰 on 2018/11/14.
//  Copyright © 2018 czb365.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, WHExteriorMapType) {
    baiduMap,//默认从0开始
    gaodeMap,
    appleMap,
    tencentMap,
};

@interface WHExteriorNavicationController : NSObject
+ (void)quickNavication:(void(^)(WHExteriorMapType))callBack;
+ (void)openTencentMap:(CLLocationCoordinate2D)destination origin:(CLLocationCoordinate2D)origin mode:(NSString *)mode coordType:(NSString *)coordType;
+ (void)openGaodeMap:(CLLocationCoordinate2D)destination;
+ (void)openBaiduMap:(CLLocationCoordinate2D)destination origin:(CLLocationCoordinate2D)origin mode:(NSString *)mode coordType:(NSString *)coordType;
+ (void)openAppleMap:(CLLocationCoordinate2D)destination;
@end

NS_ASSUME_NONNULL_END
