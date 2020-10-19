//
//  CZBInfoManager.m
//  CZBWebProjectDemoForOC
//
//  Created by 边智峰 on 2018/11/14.
//  Copyright © 2018 czb365.com. All rights reserved.
//

#import "CZBInfoManager.h"
#import "CZBMapNavgation.h"

static NSString *mapNavigation = @"CZBMapNavi";
static NSString *wechatPayConfig = @"CZBWXPayConfig";

@interface CZBInfoManager()<WKScriptMessageHandler>
@property (nonatomic, copy) NSMutableDictionary *czbExtraHead;
@end

static CZBInfoManager *instance = nil;
@implementation CZBInfoManager

+ (CZBInfoManager *)shared {
    if (instance == nil) {
        instance = [[CZBInfoManager alloc] init];
    }
    return instance;
}

+ (id)allocWithZone:(struct _NSZone*)zone {
    if (instance == nil) {
        instance = [super allocWithZone:zone];
    }
    return instance;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return instance;
}

- (NSMutableDictionary *)czbExtraHead {
    if (!_czbExtraHead) {
        _czbExtraHead = [NSMutableDictionary new];
    }
    return _czbExtraHead;
}

+ (void)registerWebView:(WKWebView *)webView {

    [webView.configuration.userContentController addScriptMessageHandler:[CZBInfoManager shared] name:mapNavigation];
    [webView.configuration.userContentController addScriptMessageHandler:[CZBInfoManager shared] name:wechatPayConfig];
    NSString *js = [NSString stringWithFormat:@"window.czb = {setExtraInfoHead: function(key,value){window.webkit.messageHandlers.%@.postMessage({'key': key, 'value': value});},startNavigate: function(startLat,startLng,endLat,endLng){window.webkit.messageHandlers.%@.postMessage([''+startLat, ''+startLng, ''+endLat, ''+endLng]);}}", wechatPayConfig, mapNavigation];
    WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:true];
    [webView.configuration.userContentController addUserScript:script];
}

- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    if (message.name == wechatPayConfig && [message.body isKindOfClass:NSDictionary.class]) {
        if (message.body[@"key"] != nil && message.body[@"value"] != nil) {
            self.czbExtraHead[message.body[@"key"]] = message.body[@"value"];
        }
    } else if (message.name == mapNavigation && [message.body isKindOfClass: NSArray.class]) {
        NSArray *arr = (NSArray *)message.body;
        if (arr.count < 4) { return; }
        if (_delegate != nil) {
            [_delegate czbNavigation:arr[0] startLng:arr[1] endLat:arr[2] endLng:arr[3]];
        }else{
            [CZBMapNavgation czbMapNavigation:arr[0] startLng:arr[1] endLat:arr[2] endLng:arr[3]];
        }
    }
}

+ (BOOL)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction {
    if ([navigationAction.request.URL.absoluteString hasPrefix: @"weixin"]) {
        if ([[UIApplication sharedApplication] canOpenURL:navigationAction.request.URL]) {
            [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
            return false;
        }
    }
    if ([navigationAction.request.URL.absoluteString hasPrefix: @"alipay"]) {

        if ([[UIApplication sharedApplication] canOpenURL:navigationAction.request.URL]) {
            [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
            return false;
        }
    }
    if ([CZBInfoManager shared].czbExtraHead.count > 0) {
        NSMutableURLRequest *request = (NSMutableURLRequest *)navigationAction.request;
        [[CZBInfoManager shared].czbExtraHead enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [request setValue:obj forHTTPHeaderField:key];
        }];
        [[CZBInfoManager shared].czbExtraHead removeAllObjects];
        [webView loadRequest:request];
        return false;
    }
    return true;
}

+ (void)setUserAgent:(NSString *)userAgent webView:(WKWebView *)webView completion:(void(^)(void))completion {
    if (@available(iOS 12.0, *)) {
        NSString *baseAgent = [webView valueForKey:@"applicationNameForUserAgent"];
        NSString *newUserAgent = [NSString stringWithFormat:@"%@%@",baseAgent, userAgent];
        [webView setValue:newUserAgent forKey:@"applicationNameForUserAgent"];

        completion();
        
    } else {
        [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError * _Nullable error) {
            NSString *str = [NSString stringWithFormat:@"%@%@", result, userAgent];
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:str, @"UserAgent", nil];
            [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (@available(iOS 9.0, *)) {
                [webView setCustomUserAgent:str];
            } else {
                [webView setValue:str forKey:@"applicationNameForUserAgent"];
            }
            
            completion();
        }];
    }
}

@end
