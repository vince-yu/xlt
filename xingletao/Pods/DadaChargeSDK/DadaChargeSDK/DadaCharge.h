//
//  DadaCharge.h
//  DadaWebProject
//
//  Created by 韦东方 on 2019/6/4.
//  Copyright © 2019 czb365.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface DadaCharge : NSObject

/**
 注册哒哒充电

 @param platformType 平台号
 @param isDebug 标记使用测试环境还是生产环境
 */
+ (void)registerWithPlatformType:(nonnull NSString *)platformType debug:(BOOL)isDebug;


/**
 打开哒哒充电

 @param viewController persent哒哒充电控制器的父控制器
 @param identifity 用户唯一标识(一般是手机号)
 */

+ (void)openDadaCharge:(nonnull UIViewController *)viewController identifity:(nonnull NSString *)identifity;

/**
打开哒哒充电(多参数)

@param viewController persent哒哒充电控制器的父控制器
@param params   配置参数(如手机号等)
*/
+ (void)openDadaCharge:(nonnull UIViewController *)viewController configParams:(nonnull NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
