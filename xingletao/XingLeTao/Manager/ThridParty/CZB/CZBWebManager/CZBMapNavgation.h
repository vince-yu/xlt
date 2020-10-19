//
//  CZBMapNavgation.h
//  CZBWebProjectDemoForOC
//
//  Created by 边智峰 on 2018/11/14.
//  Copyright © 2018 czb365.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZBMapNavgation : NSObject

/**
 网页中的导航事件

 @param startLat 起始位置纬度
 @param startLng 起始位置经度
 @param endLat 目的地纬度
 @param endLng 目的地经度
 */
+ (void)czbMapNavigation:(NSString *)startLat startLng:(NSString *)startLng endLat:(NSString *)endLat endLng:(NSString *)endLng;
@end

NS_ASSUME_NONNULL_END
