//
//  XLTThridPartyManager.m
//
//  Created by chenhg on 2019/4/26.
//  Copyright © 2019 . All rights reserved.
//

#import "XLTThridPartyManager.h"
#import "IQKeyboardManager.h"
#import "XLTJingDongManager.h"
#import "XLTAliManager.h"
#import "XLTShareManager.h"
#import "JMLinkService.h"
#import "XLTGoodsDetailVC.h"
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import <UserNotifications/UserNotifications.h>
#import <UMPush/UMessage.h>
#import "XLTUPushManager.h"
#import <SDWebImageWebPCoder/SDImageWebPCoder.h>
#import <SDWebImage/SDImageCodersManager.h>
#import "XLTWKWebViewController.h"
#import "AppDelegate.h"
#import "DadaCharge.h"

@interface XLTThridPartyManager ()<UNUserNotificationCenterDelegate>
@property (nonatomic ,assign) BOOL handleJMLink;

@end

@implementation XLTThridPartyManager

+ (void)load {
    [self loadIQKeyboardSettings];
}

+ (instancetype)shareManager {
    static XLTThridPartyManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

// IQKeyboardManager
+ (void)loadIQKeyboardSettings {
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 65.0;
}

- (void)registerSdks {
    [[XLTJingDongManager shareManager] registerSdk];
    [[XLTAliManager shareManager] registerSdk];
    [[XLTShareManager shareManager] registerSdk];
    [XLTUPushManager shareManager];
    if ([XLTAppPlatformManager shareManager].serverType == XLTAppPlatformServerReleaseType) {
        [DadaCharge registerWithPlatformType:@"9000106" debug:NO]; //9000106 920072701
    }else{
        [DadaCharge registerWithPlatformType:@"9000106" debug:NO];
    }
    
    
    [UMConfigure initWithAppkey:@"5dd34d910cafb29818000a64" channel:nil];
    
      // Push组件基本功能配置
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
      //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    } else {
        // Fallback on earlier versions
    }
    [UMessage registerForRemoteNotificationsWithLaunchOptions:nil Entity:entity     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            
          } else {
              
          }
        self.registerForRemoteNotificationscompled = YES;
        // 通知注册完成以后播放视频
        [[XLTAppPlatformManager shareManager] palyTeachingVideoIfNeed];

    }];
    [MobClick setCrashReportEnabled:![XLTAppPlatformManager shareManager].debugModel];;

    JMLinkConfig *config = [[JMLinkConfig alloc] init];
    config.appKey = @"db22540a5d1912d9d9f5a5e6";
//    config.advertisingId = idfaStr;
    [JMLinkService setupWithConfig:config];
    [JMLinkService registerMLinkHandlerWithKey:@"goods_detail" handler:^(NSURL *url, NSDictionary *params) {
        NSString *goodId = [params objectForKey:@"goods_id"];
        
        if ([goodId isKindOfClass:[NSString class]]
            && goodId.length > 0
            && !self.handleJMLink) {
            XLTGoodsDetailVC *goodDetailViewController = [[XLTGoodsDetailVC alloc] init];
            goodDetailViewController.letaoGoodsId = [params objectForKey:@"goods_id"];
            NSString *item_source = params[@"item_source"];
            goodDetailViewController.letaoGoodsSource = item_source;
            NSString *letaoGoodsItemId = params[@"item_id"];
            goodDetailViewController.letaoGoodsItemId = letaoGoodsItemId;

            UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            [nav pushViewController:goodDetailViewController animated:YES];
        }
        self.handleJMLink = YES;
    }];
    
    
    // webp支持
    SDImageWebPCoder *webPCoder = [SDImageWebPCoder sharedCoder];
    [[SDImageCodersManager sharedManager] addCoder:webPCoder];

}

- (BOOL)handleOpenURL:(NSURL *)url {
    [[XLTJingDongManager shareManager] handleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.scheme isEqualToString:@"xkd"]) {
        // 打开app
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UINavigationController *navigationController = (UINavigationController *)appDelegate.mainNavigationController;
        if ([navigationController isKindOfClass:[UINavigationController class]]) {
            XLTWKWebViewController *aXLTWKWebViewController = [XLTWKWebViewController new];
            aXLTWKWebViewController.xlt_navigationController = navigationController;
            [aXLTWKWebViewController webViewAskOpenPage:url.absoluteString showActivityShareButton:NO];
        }
    } else {
        [[XLTJingDongManager shareManager] handleOpenURL:url];
        [[XLTAliManager shareManager] application:application openURL:url options:options];
        [[XLTShareManager shareManager] application:application openURL:url options:options];
        [JMLinkService routeMLink:url];
    }
    return YES;
}
//通过universal link来唤起app
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler
{
    //必写
    self.handleJMLink = NO;
    return [JMLinkService continueUserActivity:userActivity];
}


//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        // 前台显示通知，所以不处理这个
//        [[XLTUPushManager shareManager] receiveRemoteNotification:userInfo];
    }else{
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}
//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        [[XLTUPushManager shareManager] receiveRemoteNotification:userInfo];
    }else{
        //应用处于后台时的本地推送接受
    }
}
+ (void)openKDWithPhone:(NSString *)phone sourceVC:(UIViewController *)vc{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic[@"platformCode"] = phone;
    if (dic.count) {
        [DadaCharge openDadaCharge:vc configParams:dic];
    }
}
@end
