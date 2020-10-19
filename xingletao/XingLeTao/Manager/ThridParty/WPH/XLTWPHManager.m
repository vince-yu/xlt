//
//  XLTWPHManager.m
//  WPHDemo
//
//  Created by chenhg on 2020/1/7.
//  Copyright © 2020 chenhg. All rights reserved.
//

#import "XLTWPHManager.h"
#import "XLTWKWebViewController.h"

@implementation XLTWPHManager

+ (instancetype)shareManager {
    static XLTWPHManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)openWPHPageWithNativeURLString:(NSString * _Nullable)nativeUrl
                               itemUrl:(NSString * _Nullable)itemUrl
                      sourceController:(UIViewController *)sourceController {
    if ([nativeUrl isKindOfClass:[NSString class]]) {
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *openURL = [NSURL URLWithString:nativeUrl];
        if (@available(iOS 10.0, *)) {
            [application openURL:openURL options:@{} completionHandler:^(BOOL success) {
                if (!success) {
                    [self openWPHPageWithWebURLString:itemUrl sourceController:sourceController];
                }
            }];
        } else {
            // Fallback on earlier versions
            if ([application canOpenURL:openURL]) {
                [application openURL:openURL];
             } else {
                [self openWPHPageWithWebURLString:itemUrl sourceController:sourceController];
            };
        }
    } else {
        [self openWPHPageWithWebURLString:itemUrl sourceController:sourceController];
    }
}

- (void)openWPHPageWithWebURLString:(NSString *)webUrl
                sourceController:(UIViewController *)sourceController {
    if ([webUrl isKindOfClass:[NSString class]]) {
        XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
        web.shouldDecideGoodsActivity = NO;
        web.jump_URL = webUrl;
        web.title = @"唯品会";
        [sourceController.navigationController pushViewController:web animated:YES];
    }
}


//#define kWPHAppKey @"4dc61019"

@end
