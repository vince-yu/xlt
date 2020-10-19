//
//  CZBMapNavgation.m
//  CZBWebProjectDemoForOC
//
//  Created by 边智峰 on 2018/11/14.
//  Copyright © 2018 czb365.com. All rights reserved.
//

#import "CZBMapNavgation.h"
#import <CoreLocation/CoreLocation.h>
#import <WebKit/WebKit.h>
#import "WHExteriorNavicationController.h"
@implementation CZBMapNavgation

+ (void)czbMapNavigation:(NSString *)startLat startLng:(NSString *)startLng endLat:(NSString *)endLat endLng:(NSString *)endLng {
    if (startLat.doubleValue == 0 ||
        startLng.doubleValue == 0 ||
        endLat.doubleValue == 0 ||
        endLng.doubleValue == 0) {
        return;
    }
    //根据起止坐标,实现导航代码
    CLLocationCoordinate2D fromCoord = CLLocationCoordinate2DMake(startLat.doubleValue, startLng.doubleValue);
    CLLocationCoordinate2D toCoord = CLLocationCoordinate2DMake(endLat.doubleValue, endLng.doubleValue);
    [WHExteriorNavicationController quickNavication:^(WHExteriorMapType type) {
        switch (type) {
            case appleMap:
                [WHExteriorNavicationController openAppleMap:toCoord];
                break;
            case tencentMap:
                [WHExteriorNavicationController openTencentMap:toCoord origin:fromCoord mode:@"drive" coordType:@"2"];
                break;
            case gaodeMap:
                [WHExteriorNavicationController openGaodeMap:toCoord];
                break;
            case baiduMap:
                [WHExteriorNavicationController openBaiduMap:toCoord origin:fromCoord mode:@"driving" coordType:@"gcj02"];
                break;
            default:
                break;
        }
    }];
}
@end
