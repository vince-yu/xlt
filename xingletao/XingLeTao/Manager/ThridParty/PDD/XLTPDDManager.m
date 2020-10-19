//
//  XLTPDDManager.m
//  PDDDemo
//
//  Created by chenhg on 2020/1/7.
//  Copyright © 2020 chenhg. All rights reserved.
//

#import "XLTPDDManager.h"
#import "XLTWKWebViewController.h"

@implementation XLTPDDManager

+ (instancetype)shareManager {
    static XLTPDDManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)openPDDPageWithURLString:(NSString *)url
                sourceController:(UIViewController *)sourceController close:(BOOL)thisVC{
    NSString *nativeUrl = [self buildNativePddUrl:url];
    [self openPDDPageWithNativeURLString:nativeUrl webURLString:url sourceController:sourceController close:thisVC];
}


- (void)openPDDPageWithNativeURLString:(NSString *)nativeUrl
                          webURLString:(NSString *)webUrl
                      sourceController:(UIViewController *)sourceController
                                 close:(BOOL)close
{
    //pddopen://?h5Url=https%3A%2F%2Fp.pinduoduo.com%2F6Y3bTiXH&backUrl=xltpddopen%3A%2F%2F&packageId=com.snqu.xingletao&appKey=36d222e228f343dfb16d6297312e970a
    //pddopen://?h5Url=https%3A%2F%2Fp.pinduoduo.com%2FrGYbQyKM&backUrl=xltpddopen%3A%2F%2F&packageId=com.snqu.xingletao&appKey=36d222e228f343dfb16d6297312e970a
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *openURL = [NSURL URLWithString:nativeUrl];
    if (@available(iOS 10.0, *)) {
        [application openURL:openURL options:@{} completionHandler:^(BOOL success) {
            if (!success) {
                [self openPDDPageWithWebURLString:webUrl sourceController:sourceController];
                
            }else{
                if (close) {
                    [sourceController.navigationController popViewControllerAnimated:NO];
                }
            }
        }];
    } else {
        // Fallback on earlier versions
        if ([application canOpenURL:openURL]) {
            [application openURL:openURL];
         } else {
            [self openPDDPageWithWebURLString:webUrl sourceController:sourceController];
        };
    }
}

- (void)openPDDPageWithWebURLString:(NSString *)webUrl
                sourceController:(UIViewController *)sourceController {
    XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
    web.shouldDecideGoodsActivity = NO;
    web.jump_URL = webUrl;
    web.title = @"拼多多";
    [sourceController.navigationController pushViewController:web animated:YES];
}


#define kPDDAppKey @"36d222e228f343dfb16d6297312e970a"

- (NSString *)buildNativePddUrl:(NSString *)url {
    if ([url isKindOfClass:[NSString class]]) {
        NSMutableString *nativePddUrl = [[NSMutableString alloc] initWithString:@"pddopen://?h5Url="];
        // h5Url Field
        [nativePddUrl appendString:[url letaoUrlEncode]];
        // backUrl Field
        [nativePddUrl appendString:[NSString stringWithFormat:@"&backUrl=%@",[@"xltpddopen://" letaoUrlEncode]]];
        // packageId Field
        NSString *packageId = [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey];
        [nativePddUrl appendString:[NSString stringWithFormat:@"&packageId=%@",packageId]];
        // appKey Field
        [nativePddUrl appendString:[NSString stringWithFormat:@"&appKey=%@",kPDDAppKey]];
        return nativePddUrl.copy;
    }
    return nil;
}
@end
