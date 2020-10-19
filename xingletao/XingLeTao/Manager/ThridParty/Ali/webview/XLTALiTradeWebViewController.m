//
//  ALiTradeWantViewController.m
//  ALiSDKAPIDemo
//
//  Created by com.alibaba on 16/6/1.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLTALiTradeWebViewController.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import "XLTNetCommonParametersModel.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "XLTNetCommonParametersModel.h"
#import "XLTURLConstant.h"
#import "NSString+XLTMD5.h"
#import "XLTURLConstant.h"
#import "XLTUserManager.h"
#import "XLTNetworkHelper.h"


NSString *const kXLTAuthTaoBaoCompleteNotificationName = @"kXLTAuthTaoBaoCompleteNotificationName";
NSString *const kXLTAuthTaoBaoCancelNotificationName = @"kXLTAuthTaoBaoCancelNotificationName";

@interface XLTALiTradeWebViewController()

@end

@implementation XLTALiTradeWebViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _webView.scrollView.scrollEnabled = YES;
        _webView.delegate = self;
        [self.view addSubview:_webView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@授权",[[XLTAppPlatformManager shareManager] platformText:@"淘宝"]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaoSetupNavigationWhiteBar];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

- (void)letaopopViewController {
    [self.navigationController popViewControllerAnimated:YES];
    [self.view endEditing:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kXLTAuthTaoBaoCancelNotificationName object:nil];
    });
}

-(void)dealloc
{
    NSLog(@"dealloc  view");
    _webView =  nil;
}

-(void)setOpenUrl:(NSString *)openUrl {
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:openUrl]]];
}

-(UIWebView *)getWebView{
    return  _webView;
}



#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"request.URL.absoluteString is : %@",request.URL.absoluteString);
    if ([request.URL.absoluteString hasPrefix:[[XLTAppPlatformManager shareManager].baseApiSeverUrl stringByAppendingFormat:@"taobao/auth"]] ) {
        
        NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:request.URL.absoluteString];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.name) {
                parameters[obj.name] = obj.value;
            }
        }];
        [self repoAuth:request.URL.absoluteString parameters:parameters];
        return NO;
    }
    return YES;
}

- (void)repoAuth:(NSString *)repoUrl parameters:(NSDictionary *)parameters {
    __weak typeof(self)weakSelf = self;
    [XLTNetworkHelper GET:repoUrl parameters:parameters success:^(id responseObject, NSURLSessionDataTask *task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode]) {
                [weakSelf showTipMessage:@"授权成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [XLTUserManager shareManager].curUserInfo.has_bind_tb = @1;
                [[XLTUserManager shareManager] saveUserInfo];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kXLTAuthTaoBaoCompleteNotificationName object:nil];
                });

            } else {
                NSString *msg = model.message;
                if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
                    msg = Data_Error;
                }
               [weakSelf showTipMessage:msg];
            }
        } else {
           [weakSelf showTipMessage:@"授权失败"];
        }
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        [weakSelf showTipMessage:@"授权失败"];
    }];
}


@end
