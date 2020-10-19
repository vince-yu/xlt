//
//  XLTAliPayManager.m
//  XingKouDai
//
//  Created by chenhg on 2019/10/11.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTAliManager.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import "XLTAppPlatformManager.h"
#import "XLTUIConstant.h"
#import <Foundation/Foundation.h>
#import "XLTALiTradeWebViewController.h"
#import "XLTNetCommonParametersModel.h"
#import "XLTNetworkHelper.h"
#import "XLTURLConstant.h"
#import "XLTTipConstant.h"
#import "XLTBaseModel.h"
#import "XLTUserManager.h"
#import "XLTWKWebViewController.h"
#import "MBProgressHUD+TipView.h"

@interface XLTAliManager () <UIWebViewDelegate>
@property (nonatomic, assign) BOOL has_bind_tb;

@end


@implementation XLTAliManager

+ (instancetype)shareManager {
    static XLTAliManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#define kAlibcTradeSDKAppKey @"27647443"
- (void)registerSdk {
    [[AlibcTradeSDK sharedInstance] setIsvVersion:[XLTAppPlatformManager shareManager].appVersion];
    [[AlibcTradeSDK sharedInstance] setIsvAppName:@"星乐桃"];
    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:NO];
    [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
        NSLog(@"百川初始化成功");
    } failure:^(NSError *error) {
        NSLog(@"百川初始化失败");
    }];
    AlibcTradeTaokeParams *taokeParams = [[AlibcTradeTaokeParams alloc] init];
    taokeParams.pid = @"mm_492050103_687500054_109800700144"; //mm_XXXXX为你自己申请的阿里妈妈淘客pid，一定得填写，不然无法初始化
    [[AlibcTradeSDK sharedInstance] setTaokeParams:taokeParams];
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [[AlibcTradeSDK sharedInstance] application:application openURL:url options:options];
}


- (void)openAliTrandPageWithURLString:(NSString *)url sourceController:(UIViewController *)
sourceController
                        authorized:(BOOL)authorization {
    // 打开跳转淘宝商品之前，清楚剪贴板
    if (authorization) { // 已经授权，清楚剪贴板
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = @"";
    }
    [self openPageWithURLString:url sourceController:sourceController authorization:authorization];
    /*
    if (authorization) {
        [self openPageWithURLString:url sourceController:sourceController authorization:authorization completion:completion failure:failure];
    } else {
        [[ALBBSDK sharedInstance] setAuthOption:NormalAuth];
        [[ALBBSDK sharedInstance] auth:sourceController successCallback:^(ALBBSession *session) {
            [self repoAuthSession:session url:url completion:^(NSDictionary *info) {
                
            } failed:^(NSString *errorMsg) {
                failure(@"登录失败");
            }];
        } failureCallback:^(ALBBSession *session, NSError *error) {
            failure(@"登录失败");
        }];
    }*/
}




- (void)openPageWithURLString:(NSString *)url sourceController:(UIViewController *)
sourceController
                     authorization:(BOOL)authorization {

    XLTALiTradeWebViewController *web = nil;
    AlibcTradeShowParams *showParam = [[AlibcTradeShowParams alloc] init];
    showParam.nativeFailMode = AlibcNativeFailModeNone;
    showParam.openType = AlibcOpenTypeNative;
//    showParam.isNeedPush = YES;
    showParam.isNeedCustomNativeFailMode = YES;
//    showParam.linkKey = @"taobao";
    if(!authorization) {
        web = [[XLTALiTradeWebViewController alloc] init];
    }

    NSInteger result = [[AlibcTradeSDK sharedInstance].tradeService openByUrl:url identity:@"trade" webView:web.webView parentController:sourceController showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {

    } tradeProcessFailedCallback:^(NSError * _Nullable error) {

    }];
    if(web) {
        [sourceController.navigationController pushViewController:web animated:YES];
    } else {
//        
//                  -1:  入参出错
//                  -2:  此URL需要使用openByCode 通过code来进行页面打开
//                  -3:  打开页面失败
//        *         -4:  sdk初始化失败
//        *         -5:  该版本SDK已被废弃，需要升级
//        *         -6:  sdk不允许唤端
        if (result < 0) {
            BOOL tbopen =  [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tbopen://"]];
            if (!tbopen && result == -3) {
                XLTWKWebViewController *vc = [[XLTWKWebViewController alloc] init];
                vc.jump_URL = url;
                vc.shouldDecideGoodsActivity = NO;
                [sourceController.navigationController pushViewController:vc animated:YES];
                if ([XLTAppPlatformManager shareManager].checkEnable) {
                    [MBProgressHUD letaoshowTipMessageInWindow:@"请下载淘宝app购买，避免漏单，若漏单请通过\"找回订单\"找回" hideAfterDelay:2.5];
                }
            } else {
                // 提示错误信息
                NSString *message = nil;
                if (result == -1) {
                    message = @"入参出错";
                } else if (result == -2) {
                    message = @"此URL需要使用openByCode 通过code来进行页面打开";
                } else if (result == -3) {
                    message = @"打开页面失败";
                } else if (result == -4) {
                    message = @"sdk初始化失败";
                } else if (result == -5) {
                    message = @"该版本SDK已被废弃，需要升级";
                } else if (result == -6) {
                    message = @"sdk不允许唤端";
                } else {
                    message = @"其他";
                }
                [MBProgressHUD letaoshowTipMessageInWindow:[NSString stringWithFormat:@"打开淘宝失败：%@，code：%ld",message,(long)result]];
            }
        }
    }
}



- (NSURLSessionTask *)xingletaonetwork_requestTaoBaoAuthUrlSuccess:(void(^)(NSString * _Nonnull authUrl, NSURLSessionDataTask * _Nonnull task))success
failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure {
  NSURLSessionTask *task = [XLTNetworkHelper GET:kTaoboAuthUrl parameters:nil success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSString class]]) {
                success(model.data,task);
            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
                failure(msg,task);
            }
        } else {
            failure(Data_Error,task);
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
        failure(Data_Error,task);
    }];
    return task;
}
@end
