//
//  XLTShareManager.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/12.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTShareManager.h"
#import "XLTAppPlatformManager.h"
#import "UIImage+XLTCompress.h"
#import "WechatAuthSDK.h"
#import "WXApi.h"


@implementation XLTShareManager

+ (instancetype)shareManager {
    static XLTShareManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)registerSdk {
    [WXApi registerApp:@"wxc86d77c4531c88df" universalLink:@"https://sagqk0.jmlk.co"];
}



- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
    return YES;
}

- (void)onResp:(BaseResp*)resp {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kWxinAuthRespNotificationName" object:resp];
}


@end
