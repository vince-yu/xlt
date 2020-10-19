//
//  XLTJingDongManager.m
//  XingKouDai
//
//  Created by chenhg on 2019/10/11.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTJingDongManager.h"

@implementation XLTJingDongManager

+ (instancetype)shareManager {
    static XLTJingDongManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)registerSdk {
    [[KeplerApiManager sharedKPService] asyncInitSdk:@"c82bf597dd77946e645ea8e2b904618d" secretKey:@"3247e8e1f1ca4ddcb5730609900e87ac" sucessCallback:^(){
     }failedCallback:^(NSError *error){
     }];
    [KeplerApiManager sharedKPService].JDappBackTagID = @"kpl_jdc82bf597dd77946e645ea8e2b904618d";
    [KeplerApiManager sharedKPService].isOpenByH5 = NO;
}

- (BOOL)handleOpenURL:(NSURL *)url {
     return [[KeplerApiManager sharedKPService] handleOpenURL:url];
}


- (void)openKeplerPageWithURL:(NSString *)url sourceController:(UIViewController *)
sourceController {
//     jumpType         跳转类型(默认 push) 1代表present 2代表push
    if ([url isKindOfClass:[NSString class]] && url.length > 0) {
        [[KeplerApiManager sharedKPService] openKeplerPageWithURL:url sourceController:sourceController jumpType:2 userInfo:nil];
    }
}
@end
