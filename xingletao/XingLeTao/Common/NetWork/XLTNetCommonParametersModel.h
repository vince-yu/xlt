//
//  XLTNetCommonParametersModel.h
//  ShopAnalytics
//
//  Created by chenhg on 2019/4/23.
//  Copyright © 2019  . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+YYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTNetCommonParametersModel : NSObject

// system
@property (nonatomic, assign) NSInteger dev_type;//1 安卓  ,  3 IOS ,   3 其他
@property (nonatomic, assign) NSInteger client_type;//1 微信小程序 , 2  APP ,  3 普通网页

@property (nonatomic, copy) NSString *version;//当前APP版本

// user
@property(nonatomic,copy) NSString *userId;//用户ID

// device
@property (nonatomic,copy) NSString *uuid;//设备号

// appId
@property (nonatomic,copy) NSString *appID;
@property (nonatomic,copy) NSString *appKey;
@property (nonatomic,copy) NSString *appSource;
+ (instancetype)defaultModel;

@end

NS_ASSUME_NONNULL_END
