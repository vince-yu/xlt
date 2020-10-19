//
//  XLTAdManager.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/13.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTAdManager.h"
#import "XLTNetworkHelper.h"
#import "XLTURLConstant.h"
#import "XLTTipConstant.h"
#import "XLTBaseModel.h"
#import "XLTHomePageLogic.h"
#import "XLTUserManager.h"
#import "XLTGoodsDetailVC.h"
#import "XLTWebView.h"
#import "XLTWKWebViewController.h"
#import "XLTALiTradeWebViewController.h"
#import "XLTPopAdView.h"
#import "NSDate+Utilities.h"
#import "XLTFullScreenVideoVC.h"
#import "XLTPopTaskViewManager.h"
#import "AppDelegate+Coordinator.h"
#import "AFHTTPSessionManager.h"
#import "CZBWebViewController.h"
#import "XLTActivityVC.h"
#import "DYVideoContainerViewController.h"
#import "XLTLogManager.h"
#import "XLTAliManager.h"
#import "XLTJingDongManager.h"
#import "XLTPDDManager.h"
#import "XLTWPHManager.h"
#import "XLTGoodsDetailLogic.h"

@interface XLTAdManager ()

@property (nonatomic, strong) NSMutableArray *allSessionTask;

@property (nonatomic, copy, nullable) void(^adJumpBlock)(void);

@end

@implementation XLTAdManager

+ (instancetype)shareManager {
    static XLTAdManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _allSessionTask = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedAuthTaoBaoCompleteNotification) name:kXLTAuthTaoBaoCompleteNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedAuthTaoBaoCancelNotification) name:kXLTAuthTaoBaoCancelNotificationName object:nil];
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginViewControllerDidDismissedNotification) name:kXLTLoginViewControllerDidDismissedNotification object:nil];

    }
    return self;
}



- (void)xingletaonetwork_requestHomeAdSuccess:(void(^)(NSDictionary  * _Nonnull adInfo))success
               failure:(void(^)(NSString *errorMsg))failure {
    NSURL *baseUrl = [NSURL URLWithString:[XLTAppPlatformManager shareManager].baseApiSeverUrl];
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
    [XLTNetworkHelper configSessionManager:sessionManager];
    NSString *checkEnable = @"1";
    [sessionManager.requestSerializer setValue:checkEnable forHTTPHeaderField:@"check-enable"];
    NSString *url = kHomeAdUrl;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters = [self commonParametersAdd:parameters URLString:url sessionManager:sessionManager];
    // 日志
    [[XLTLogManager sharedInstance] logNetRequestInfo:url parameters:parameters];
    [sessionManager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
                success(model.data);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        } else {
            failure(Data_Error);
        }
        // 日志
        [[XLTLogManager sharedInstance] logNetResponseInfo:url response:responseObject error:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(Data_Error);
        // 日志
        [[XLTLogManager sharedInstance] logNetResponseInfo:url response:nil error:error];
    }];
}

- (NSMutableDictionary *)commonParametersAdd:(NSDictionary *)parameters URLString:(NSString *)URLString sessionManager:(AFHTTPSessionManager *)sessionManager {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        [result addEntriesFromDictionary:parameters];
    }
    NSURL *baseUrl = [[NSURL alloc] initWithString:[[XLTAppPlatformManager shareManager] baseApiSeverUrl]];
    NSURL *url = [NSURL URLWithString:URLString relativeToURL:baseUrl];
    NSString *urlPath = url.path;
    if ([urlPath hasPrefix:@"/"]) {
        urlPath = [urlPath substringFromIndex:1];
    }
    
    [XLTNetworkHelper generateSecrtetWithParameters:parameters path:urlPath sessionManager:sessionManager];

    return result;
}

- (void)repoAdClickWitdAdId:(NSString *)addId {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (addId) {
        [parameters setObject:addId forKey:@"id"];
    }
    [XLTNetworkHelper GET:kAdClickRepoUrl parameters:parameters success:nil failure:nil];
}


- (void)xingletaonetwork_requestAdListWithPosition:(NSString *)position
                    success:(void(^)(NSArray * _Nonnull adArray))success
                    failure:(void(^)(NSString *errorMsg))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (position) {
        [parameters setObject:position forKey:@"position"];
    }
    NSURL *baseUrl = [NSURL URLWithString:[XLTAppPlatformManager shareManager].baseApiSeverUrl];
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
    [XLTNetworkHelper configSessionManager:sessionManager];
    NSString *checkEnable = XLTAppPlatformManager.shareManager.checkEnable ? @"1" : @"0";
    [sessionManager.requestSerializer setValue:checkEnable forHTTPHeaderField:@"check-enable"];
    NSString *url = kAdListUrl;
    parameters = [self commonParametersAdd:parameters URLString:url sessionManager:sessionManager];
    // 日志
    [[XLTLogManager sharedInstance] logNetRequestInfo:url parameters:parameters];
    [sessionManager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSArray class]]) {
                success(model.data);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg);
            }
        } else {
            failure(Data_Error);
        }
        // 日志
        [[XLTLogManager sharedInstance] logNetResponseInfo:url response:responseObject error:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(Data_Error);
        // 日志
        [[XLTLogManager sharedInstance] logNetResponseInfo:url response:nil error:error];
    }];
}


//- {
//    "link_type": - [                //类型：Array  必有字段  备注：连接类型
//        "2",                //类型：String  必有字段  备注：无
//        "3"                //类型：String  必有字段  备注：无
//    ],
//    "tid":"39997",                //类型：String  必有字段  备注：操作id
//    "link_url":"mock",                //类型：String  必有字段  备注：操作转链url
//    "item_source":"P",                //类型：String  必有字段  备注：平台
//    "need_code":1                //类型：Number  必有字段  备注：0 不需要口令 1 需要口令
//}


// 活动链接
- (void)xingletaonetwork_requestAdActivityWithUrl:(NSString * _Nonnull)link_url
                                        link_type:(NSArray * _Nonnull)link_type
                                              tid:(NSString * _Nonnull)tid
                                      item_source:(NSString * _Nonnull)item_source
                                          success:(void(^)(NSDictionary  * _Nonnull adInfo))success
                                          failure:(void(^)(NSString *errorMsg, NSString * _Nullable authUrl,XLTBaseModel *model))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"link_url"] = link_url;
    parameters[@"link_type"] = link_type;
    parameters[@"tid"] = tid;
    parameters[@"item_source"] = item_source;
    [parameters setObject:@1 forKey:@"need_code"];
    [XLTNetworkHelper POST:kNewGoodsCopoUrl parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
                success(model.data);
            } else {
                NSString *authUrl = nil;
                if ([model.data isKindOfClass:[NSDictionary class]]) {
                    if ([XLTGoodsDetailLogic letaoIsNeedAliAuthorizationCode:model] || [XLTGoodsDetailLogic letaoIsNeedPDDAuthorizationCode:model]) {
                        NSString *auth_url = model.data[@"auth_url"];
                        if ([auth_url isKindOfClass:[NSString class]]) {
                            authUrl = auth_url;
                        }
                    }
                }
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg,authUrl,model);
            }
        } else {
            failure(Data_Error,nil,nil);
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
        failure(Data_Error,nil,nil);
    }];
}

/*
 所有广告跳转逻辑
  public static void startWebFrag(Activity ctx, AdvertistEntity data) {
        if (TextUtils.isEmpty(data.platform) || TextUtils.isEmpty(data.url)) { //无平台或者无链接
            return;
        }
        String platform = data.platform;
        if (TextUtils.equals(platform, "C") || TextUtils.equals(platform, "B")) { // 天猫或淘宝
            UserEntity user = UserClient.getUser();
            if (null == user) { //用户未登录 先登录
                LoginFragment.Companion.start(ctx);
            } else if (user.has_bind_tb == 0) { //淘宝未授权
                  先进行淘宝授权，授权成功自动跳转到淘宝
            } else { //跳转到淘宝
                AlibcUtil.startToAli(ctx, data.url, platform);
            }
        } else if (TextUtils.equals("D", platform)) { //京东
              跳转到京东
        } else if (TextUtils.equals("G", platform)) { //商品id 进入商品详情
            GoodsDetailActivity.Companion.start(ctx, data.url);
        } else { //U：内部url，O:外部url  使用自己的WebView打开
            WebViewFrag.WebViewParam webViewParam = new WebViewFrag.WebViewParam();
            webViewParam.url = data.url;
            WebViewFrag.start(ctx, webViewParam);
        }
    }*/


- (void)adJumpWithInfo:(NSDictionary *)adInfo sourceController:(XLTBaseViewController *)
sourceController {
    if ([adInfo isKindOfClass:[NSDictionary class]]) {
        
        //  解析字段
        NSString *link_url =  ([adInfo[@"link_url"] isKindOfClass:[NSString class]] || [adInfo[@"link_url"] isKindOfClass:[NSNumber class]]) ? [NSString stringWithFormat:@"%@",adInfo[@"link_url"]] : @"";
        NSString *needLoginField = adInfo[@"needLogin"];
        NSString *needAuthField = adInfo[@"needAuth"];
        NSArray *link_type =[adInfo[@"link_type"] isKindOfClass:[NSArray class]] ? adInfo[@"link_type"] : nil;
        NSString *platform = [adInfo[@"platform"] isKindOfClass:[NSString class]] ? adInfo[@"platform"] : @"";
        NSString *direct = [NSString stringWithFormat:@"%@",adInfo[@"direct"]];
        NSString *direct_protocal = [NSString stringWithFormat:@"%@",adInfo[@"direct_protocal"]];
        NSString *tid = [NSString stringWithFormat:@"%@",adInfo[@"tid"]];
        NSNumber *open_third_app = adInfo[@"open_third_app"];
        BOOL tryNative = [open_third_app isKindOfClass:[NSNumber class]] &&  [open_third_app boolValue];
        BOOL isNeedLoginField = ([needLoginField isKindOfClass:[NSNumber class]] || [needLoginField isKindOfClass:[NSString class]]) && [needLoginField boolValue];
        BOOL isNeedAuthField= ([needAuthField isKindOfClass:[NSNumber class]] || [needAuthField isKindOfClass:[NSString class]])  && [needAuthField boolValue];
        __weak typeof(self)weakSelf = self;
        if (isNeedLoginField
            && ![[XLTUserManager shareManager] isLogined]) { // 需要登录
            [[XLTUserManager shareManager] displayLoginViewController];
        } else {
            // 清理之前可能存在block跳转
            self.adJumpBlock =  nil;
            
            NSNumber *has_bind_tb = [XLTUserManager shareManager].curUserInfo.has_bind_tb;
            if (isNeedAuthField && ![has_bind_tb boolValue]) {
                if (![[XLTUserManager shareManager] isLogined]) { // 需要登录
                    [[XLTUserManager shareManager] displayLoginViewController];
                } else { // 需要授权
                    self.adJumpBlock = ^{
                        [weakSelf adJumpWithDirect:direct tryNative:tryNative direct_protocal:direct_protocal link_url:link_url link_type:link_type tid:tid platform:platform sourceController:sourceController];
                    };
                    [self xingletaonetwork_requestTaoBaoAuthWithSourceController:sourceController];
                }
            } else {
                // 验证完成
                [self adJumpWithDirect:direct tryNative:tryNative direct_protocal:direct_protocal link_url:link_url link_type:link_type tid:tid platform:platform sourceController:sourceController];
            }
        }
    }
}





- (void)adJumpWithDirect:(NSString *)direct
               tryNative:(BOOL)tryNative
         direct_protocal:(NSString *)direct_protocal
                link_url:(NSString *)link_url
               link_type:(NSArray *)link_type
                     tid:(NSString *)tid
                platform:(NSString *)platform
        sourceController:(XLTBaseViewController *)sourceController {
    if ([direct integerValue] == 2) { // 需要转链接
        __weak typeof(self)weakSelf = self;
        [self xingletaonetwork_requestAdActivityWithUrl:link_url link_type:link_type tid:tid item_source:platform success:^(NSDictionary * _Nonnull adInfo) {
            NSString *nativeUrl = adInfo[@"app_url"];
            if (tryNative && [nativeUrl isKindOfClass:[NSString class]] && nativeUrl.length > 0) {
                // 使用活动中的direct_protocal
                if (![weakSelf tryOpenTbPddScheme:nativeUrl sourceController:sourceController]) {
                    NSString *activityUrl = adInfo[@"click_url"];
                    if ([nativeUrl hasPrefix:@"http"]) {
                        [weakSelf openWebViewControllerWithUrl:activityUrl sourceController:sourceController];
                    } else {
                        [weakSelf webViewOpenApplicationWithNativeUrl:nativeUrl webUrl:activityUrl sourceController:sourceController];
                    }
                }
            } else {
                NSString *activityUrl = adInfo[@"click_url"];
                if ([activityUrl isKindOfClass:[NSString class]]) {
                    [weakSelf openWebViewControllerWithUrl:activityUrl sourceController:sourceController];
                }
            }

        } failure:^(NSString *errorMsg, NSString * _Nullable authUrl,XLTBaseModel *model) {
            if ([XLTGoodsDetailLogic letaoIsNeedPDDAuthorizationCode:model]) {
                [[XLTPDDManager shareManager] openPDDPageWithURLString:authUrl sourceController:self close:NO];
            }else{
                [MBProgressHUD letaoshowTipMessageInWindow:errorMsg];
            }
            
        }];
    } else {
        [self adJumpWithDirectProtocal:direct_protocal sourceController:sourceController];
    }
}

- (void)adJumpWithDirectProtocal:(NSString *)direct_protocal
                sourceController:(XLTBaseViewController *)sourceController {
    // 是否是app打开京、淘宝和拼多多
    if (![self tryOpenTbPddScheme:direct_protocal sourceController:sourceController]) {
        // 打开app
        XLTWKWebViewController *aXLTWKWebViewController = [XLTWKWebViewController new];
        aXLTWKWebViewController.xlt_navigationController = sourceController.navigationController;
        [aXLTWKWebViewController webViewAskOpenPage:direct_protocal showActivityShareButton:NO];
    }
}

- (BOOL)tryOpenTbPddScheme:(NSString *)direct_protocal sourceController:(XLTBaseViewController *)sourceController {
    if ([direct_protocal hasPrefix:@"xkd://app/openTaobao"]
        || [direct_protocal hasPrefix:@"xkd://app/openJd"]
        || [direct_protocal hasPrefix:@"xkd://app/openPdd"]) {
        NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:direct_protocal];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.name) {
                parameters[obj.name] = obj.value;
            }
        }];
        NSString *openURLString = parameters[@"param"];
        if (openURLString.length) {
            if ([direct_protocal hasPrefix:@"xkd://app/openTaobao"]) {
                [[XLTAliManager shareManager] openAliTrandPageWithURLString:openURLString sourceController:sourceController authorized:YES];
            } else if ([direct_protocal hasPrefix:@"xkd://app/openJd"]) {
                [[XLTJingDongManager shareManager] openKeplerPageWithURL:openURLString sourceController:sourceController];
            } else if ([direct_protocal hasPrefix:@"xkd://app/openPdd"]) {
                [[XLTPDDManager shareManager] openPDDPageWithURLString:openURLString sourceController:sourceController close:NO];
            }
        }
        return YES;
    } else {
        return NO;
    }
}


- (void)webActivityJumpWithInfo:(NSDictionary *)adInfo
               sourceController:(XLTBaseViewController *)sourceController {
    
    /*
    if ([adInfo isKindOfClass:[NSDictionary class]]) {
        NSNumber *isAuth = adInfo[@"isAuth"];
        BOOL isAuthValid = ([isAuth isKindOfClass:[NSNumber class]] || [isAuth isKindOfClass:[NSString class]]) && [isAuth boolValue];
        if (isAuthValid) {
            [self adJumpWithInfo:adInfo sourceController:sourceController];
            return;
        }
    }
    
    // 直接跳转
    if ([adInfo isKindOfClass:[NSDictionary class]]) {
        NSString *platform = adInfo[@"platform"];
        NSString *url = [NSString stringWithFormat:@"%@",adInfo[@"url"]];;
        BOOL isPlatformValid = [platform isKindOfClass:[NSString class]] && platform.length > 0;
        BOOL isUrlValid = url.length > 0;
        NSString *title = adInfo[@"title"];
        if (isPlatformValid && isUrlValid) {
            if ([platform isEqualToString:@"G"]) { // 商品详情
                NSString *goodId = url;
                if (goodId) {
                    XLTGoodsDetailVC *goodDetailViewController = [[XLTGoodsDetailVC alloc] init];
                    goodDetailViewController.letaoGoodsId = goodId;
                    NSString *item_source = adInfo[@"item_source"];
                    goodDetailViewController.letaoGoodsSource = item_source;
                    NSString *letaoGoodsItemId = adInfo[@"item_id"];
                    goodDetailViewController.letaoGoodsItemId = letaoGoodsItemId;
                    [sourceController.navigationController pushViewController:goodDetailViewController animated:YES];
                }
            } else {
                if (isUrlValid) {
                    XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
                    web.jump_URL = url;
                    if ([title isKindOfClass:[NSString class]] && title.length > 0) {
                        web.title = title;
                    }
                    [sourceController.navigationController pushViewController:web animated:YES];

                }
            }
        } else {
            // do nothing
        }
    }*/
}

- (void)cancelAllRequest {
    @synchronized (self) {
        [self.allSessionTask enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [self.allSessionTask removeAllObjects];
    }
}


- (void)xingletaonetwork_requestTaoBaoAuthWithSourceController:(XLTBaseViewController *)
sourceController {
    [self cancelAllRequest];
    
    NSURLSessionTask *sessionTask = [[XLTAliManager shareManager] xingletaonetwork_requestTaoBaoAuthUrlSuccess:^(NSString * _Nonnull authUrl, NSURLSessionDataTask * _Nonnull task) {
        if ([self.allSessionTask containsObject:task]) {
            [self.allSessionTask removeObject:task];
            [[XLTAliManager shareManager] openAliTrandPageWithURLString:authUrl sourceController:sourceController authorized:NO];
        }
    } failure:^(NSString * _Nonnull errorMsg, NSURLSessionDataTask * _Nonnull task) {
        if ([self.allSessionTask containsObject:task]) {
            [self.allSessionTask removeObject:task];
            [MBProgressHUD letaoshowTipMessageInWindow:errorMsg];
        }
    }];
    sessionTask ? [self.allSessionTask  addObject:sessionTask] : nil ;
}


- (void)receivedAuthTaoBaoCompleteNotification {
    if (self.adJumpBlock) {
        self.adJumpBlock();
        self.adJumpBlock = nil;
    }
}

- (void)receivedAuthTaoBaoCancelNotification {
    self.adJumpBlock = nil;
}


- (void)popAdWithInfo:(NSArray *)adInfo {
    if ([adInfo isKindOfClass:[NSArray class]] && adInfo.count > 0) {
        NSNumber *per = @0;
        NSDictionary *fristAdInfo = adInfo.firstObject;
        if ([fristAdInfo isKindOfClass:[NSDictionary class]]
            && [fristAdInfo[@"per"] isKindOfClass:[NSNumber class]]) {
            per = fristAdInfo[@"per"];
        }
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

        if (![[XLTPopTaskViewManager shareManager] havePopedViews]
            && !appDelegate.videoNavigationViewController){
            NSDate *popAdShowDate = [self popAdShowDate];
            if (![popAdShowDate isKindOfClass:[NSDate class]]) {
                XLTPopAdView *adView = [[XLTPopAdView alloc] init];
                [[XLTPopTaskViewManager shareManager] addPopedView:adView];
                [adView updateAdInfo:adInfo];
            } else {
                NSTimeInterval aTimeInterval = [popAdShowDate timeIntervalSince1970] + [per longLongValue];
                NSDate *expireDate = [NSDate dateWithTimeIntervalSince1970:aTimeInterval];
                NSComparisonResult result = [expireDate compare:[NSDate date]];
                if (result == NSOrderedAscending
                    || result == NSOrderedSame) {
                    XLTPopAdView *adView = [[XLTPopAdView alloc] init];
                    [[XLTPopTaskViewManager shareManager] addPopedView:adView];
                    [adView updateAdInfo:adInfo];
                }
            }
        }
    }
}

- (void)openWebViewControllerWithUrl:(NSString *)url
                    sourceController:(UIViewController *)sourceController {
    if ([url isKindOfClass:[NSString class]] && url.length > 0) {
        XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
        web.disableTbPddVphScheme = YES;
        web.jump_URL = url;
        web.showActivityShareButton = YES;
        [sourceController.navigationController pushViewController:web animated:YES];
    }
}

- (void)webViewOpenApplicationWithNativeUrl:(NSString *)nativeUrl webUrl:(NSString *)webUrl sourceController:(UIViewController *)sourceController {
    if ([nativeUrl isKindOfClass:[NSString class]] && nativeUrl.length > 0) {
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *openURL = [NSURL URLWithString:nativeUrl];
        if (@available(iOS 10.0, *)) {
            [application openURL:openURL options:@{} completionHandler:^(BOOL success) {
                if (!success) {
                    [self openWebViewControllerWithUrl:webUrl sourceController:sourceController];
                }
            }];
        } else {
            // Fallback on earlier versions
            if ([application canOpenURL:openURL]) {
                [application openURL:openURL];
             } else {
                 [self openWebViewControllerWithUrl:webUrl sourceController:sourceController];
            };
        }
    }
}


#define kXLTAdManagerPopAdShowDate @"XLTAdManager.popAdShowDate"

- (void)savePopAdShowDate:(NSDate *)date {
    if (date) {
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:kXLTAdManagerPopAdShowDate];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSDate *)popAdShowDate {
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:kXLTAdManagerPopAdShowDate];
    if ([date isKindOfClass:[NSDate class]]) {
        return date;
    }
    return nil;
}



- (void)loginViewControllerDidDismissedNotification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fetchAndPopZeroBuyAdIfNeed];
    });
}



- (void)fetchAndPopZeroBuyAdIfNeed {    
    // 设置是新人0元购状态
    if ([XLTUserManager shareManager].isLogined) {
        if (![[XLTAppPlatformManager shareManager] todayZeroBuyAdShowState]) {
            [self xingletaonetwork_requestAdListWithPosition:@"10003" success:^(NSArray * _Nonnull adArray) {
                [self popZeroBuyAdIWithInfo:adArray];
            } failure:^(NSString * _Nonnull errorMsg) {
                
            }];
        }
    }
}

- (void)popZeroBuyAdIWithInfo:(NSArray *)adArray {
    if ([adArray isKindOfClass:[NSArray class]] && adArray.count > 0) {
        NSDictionary *fristAdInfo = adArray.firstObject;
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

        if (![[XLTPopTaskViewManager shareManager] havePopedGoodsInfoAlertVC]
            && !appDelegate.videoNavigationViewController) {
            [[XLTPopTaskViewManager shareManager] clearPopedViews];
            
            XLTPopAdView *adView = [[XLTPopAdView alloc] init];
            adView.isZeroBuyAd = YES;
            [[XLTPopTaskViewManager shareManager] addPopedView:adView];
            [adView updateAdInfo:@[fristAdInfo]];
        }
    } else {
        // 没数据今天不在请求了
        [[XLTAppPlatformManager shareManager] makeLocalZeroBuyAddDateInfo];
    }
}

@end
