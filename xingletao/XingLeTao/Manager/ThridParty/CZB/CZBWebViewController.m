//
//  WebViewController.m
//  CZBWebProjectDemoForOC
//
//  Created by 边智峰 on 2018/11/14.
//  Copyright © 2018 czb365.com. All rights reserved.
//

#import "CZBWebViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <WebKit/WebKit.h>
#import "CZBInfoManager.h"

@interface CZBWebViewController ()

/**
 是否设置过userAgent
 */
@property (nonatomic, assign) BOOL isSetUserAgent;
@end

@implementation CZBWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)webViewloadRequest {
    
    NSString *jump_URLString = self.jump_URL;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:jump_URLString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    /// 设置UA
    if (!self.isSetUserAgent) {
        [CZBInfoManager setUserAgent:@"XLTIOS" webView:self.webView.wkWebView completion:^{
            [self.webView loadRequest:request];
            self.isSetUserAgent = true;
        }];
        
    } else {
        [self.webView loadRequest:request];
    }

    ////////////////************************* 需执行注册事件
    [CZBInfoManager registerWebView: self.webView.wkWebView];
    /////************************************************
}


///WebViewDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    BOOL isAllow = [CZBInfoManager webView:webView decidePolicyForNavigationAction:navigationAction];
    if (isAllow) {
        [super webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    } else {
         decisionHandler(WKNavigationActionPolicyCancel);
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self letaoconfigRightBarItemWithImage:[UIImage imageNamed:@"xlt_mine_close"] target:self action:@selector(letaoCloseViewController)];
}


- (void)letaoCloseViewController {
    [self.navigationController popViewControllerAnimated:YES];
    [self.view endEditing:YES];
}

@end
