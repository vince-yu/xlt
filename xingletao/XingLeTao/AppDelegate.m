//
//  AppDelegate.m
//  XingLeTao
//
//  Created by chenhg on 2019/9/29.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Coordinator.h"
#import "XLTThridPartyManager.h"
#import "JMLinkService.h"
#import "XLTAppPlatformManager.h"
#import "XLTUserManager.h"
#import <UMPush/UMessage.h>
#import "XLTUPushManager.h"
#import "SDRepoManager.h"
#import "XLTAdManager.h"
#import <SndoADSDK/SndoADSDK.h>
#import "XLTWKWebViewController.h"

@interface AppDelegate ()<SndoSplashAdViewDelegate>
@property (nonatomic ,strong) SndoSplashAdView *splash;
@property (nonatomic ,strong) UIWindow *adWindow;
@property (nonatomic ,strong) UIView *splashBottomView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 注册深度数据
    [SDRepoManager xltrepo_startWithLaunchOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

//    [XLTAppPlatformManager shareManager].debugModel = YES;
//    [XLTAppPlatformManager shareManager].serverType = XLTAppPlatformServerTestType;

    [[XLTAppPlatformManager shareManager] xingletaonetwork_requestConfig];
    [self addCheckEnableStateObserver];
    [self displayRootViewControllerForLaunching];
    [[XLTThridPartyManager shareManager] registerSdks];
    

    [self.window makeKeyAndVisible];
    
    if ([XLTAppPlatformManager shareManager].checkEnable) {
        //测试用广告位2wg5v42bnj8e
        self.splash = [[SndoSplashAdView alloc] initWithPlacementId:@"2wtk4balwylc"];
        self.splash.showCountDownTime = YES;
        self.splash.countDownTime = 4;
        self.splash.isHorizontal = YES;
        self.splash.delegate = self;
        self.splash.customHandleClick = YES;
        [self.splash loadAd];
        [self.splash showAdInWindow:self.adWindow withBottomView:self.splashBottomView skipView:nil];
    }
    
    
    return YES;
}
- (UIView *)splashBottomView{
    if (!_splashBottomView) {
        _splashBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160 + kBottomSafeHeight)];
        UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 111, 117)];
        logoImageView.image = [UIImage imageNamed:@"splash_bottom_logo"];
        _splashBottomView.backgroundColor = [UIColor whiteColor];
        [_splashBottomView addSubview:logoImageView];
        
        logoImageView.center = _splashBottomView.center;
    }
    return _splashBottomView;
}
- (UIWindow *)adWindow{
    if (!_adWindow) {
        _adWindow = [[UIWindow alloc] initWithFrame:self.window.bounds];
        _adWindow.backgroundColor = [UIColor clearColor];
        _adWindow.hidden = YES;
        _adWindow.windowLevel = (UIWindowLevelStatusBar -1.0);
        UIViewController *rootVc = [[UIViewController alloc] init];
        rootVc.view.backgroundColor = [UIColor clearColor];
        _adWindow.rootViewController = [[UIViewController alloc] init];
        
    }
    return _adWindow;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
//    [[XLTUserManager shareManager] saveUserInfo];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    /// 解析剪贴板平商品信息
    [[XLTAppPlatformManager shareManager] checkPasteboardGoodsInfo];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[XLTAppPlatformManager shareManager] xingletaonetwork_requestLimitModelStatus:nil];
        [[XLTAppPlatformManager shareManager] requestSupportGoodsPlatform];
        [[XLTAdManager shareManager] fetchAndPopZeroBuyAdIfNeed];
        
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [[XLTUserManager shareManager] refreshUserInfo];
    });
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [[XLTThridPartyManager shareManager] application:application openURL:url options:options];
    return YES;
}
//通过universal link来唤起app
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler API_AVAILABLE(ios(8.0))
{
    //必写
    [[XLTThridPartyManager shareManager] application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
    return YES;
}


//token 获取
//友盟疑似hook
//iOS10以下使用这两个方法接收通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        [UMessage didReceiveRemoteNotification:userInfo];
        [[XLTUPushManager shareManager] receiveRemoteNotification:userInfo];
    }
     completionHandler(UIBackgroundFetchResultNewData);
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[XLTUPushManager shareManager] addAliasIfNeed];
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"deviceToken:%@",hexToken);
    /*
    if ([XLTAppPlatformManager shareManager].debugModel) {
        [UIPasteboard generalPasteboard].string = hexToken;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DeviceToken已经复制" message:hexToken delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }*/
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
    
    NSLog(@"Regist fail%@",error);
    
}


- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAll;
//    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark ADDelegate
/**
 *  用户点击广告
 */
- (void)userClickedAd:(SndoSplashAdView *)splash withCurrentURL:(NSString *)currentUrl{
    XLTWKWebViewController *vc = [[XLTWKWebViewController alloc] init];
    vc.jump_URL = currentUrl;
    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    [nav pushViewController:vc animated:YES];
    self.adWindow.hidden = YES;
}
/**
 *  广告展示结束
 */
- (void)adViewfinish:(SndoSplashAdView *)splash{
    self.adWindow.hidden = YES;
}
/**
 *  广告加载完并成功
 */
- (void)successAdLoadView:(SndoSplashAdView *)splash{
    self.adWindow.hidden = NO;
}
@end
