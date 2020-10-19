//
//  XLTAliPayManager.h
//  XingKouDai
//
//  Created by chenhg on 2019/10/11.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface XLTAliManager : NSObject

+ (instancetype)shareManager;

- (void)registerSdk;

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;

- (void)openAliTrandPageWithURLString:(NSString *)url sourceController:(UIViewController *)
sourceController
                        authorized:(BOOL)authorization;


- (NSURLSessionTask *)xingletaonetwork_requestTaoBaoAuthUrlSuccess:(void(^)(NSString * _Nonnull authUrl, NSURLSessionDataTask * _Nonnull task))success
failure:(void(^)(NSString *errorMsg,NSURLSessionDataTask * task))failure ;

@end

NS_ASSUME_NONNULL_END
