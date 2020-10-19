//
//  XLTNetCommonParametersModel.m
//  ShopAnalytics
//
//  Created by chenhg on 2019/4/23.
//  Copyright © 2019  . All rights reserved.
//

#import "XLTNetCommonParametersModel.h"
#import "XLTUserManager.h"

@implementation XLTNetCommonParametersModel

- (instancetype)init{
    self = [super init];
    if (self) {
        self.dev_type = 2; //1 安卓  ,  2 IOS ,   3 其他
        self.client_type = 2; //1 微信小程序 , 2  APP ,  3 普通网页
        self.version = [self appVersion];
        self.userId  = [XLTUserManager shareManager].curUserInfo._id;
//        self.uuid = [self openUDID];
        self.appID = @"200201";
        self.appKey = @"HAA@OwBhZ!aZV!wmUKsG2FZjYEU!gO&&";
        self.appSource = @"2";
    }
    return self;
}

+ (instancetype)defaultModel {
    static XLTNetCommonParametersModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSString *)appNameText {
    static NSString *appName = nil;
    if (appName == nil) {
        appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    }
    if (appName == nil) {
        appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    }
    return [appName copy];
}


- (NSString *)appVersion {
    static NSString *appVersion = nil;
    if (appVersion == nil) {
        appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    }
    return [appVersion copy];
}


@end
