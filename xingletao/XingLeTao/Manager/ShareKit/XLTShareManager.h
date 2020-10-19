//
//  XLTShareManager.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/12.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTShareManager : NSObject
+ (instancetype)shareManager;

- (void)registerSdk;

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;
/*
- (void)authWithPlatform:(UMSocialPlatformType)platformType completionBlock:(void (^ __nullable)(id result, NSError *error))completionBlock;

- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType completionBlock:(void (^ __nullable)(id result, NSError *error))completionBlock;

- (void)shareWebPage:(NSString *)webpageUrl
               title:(NSString *)title
            describe:(NSString *)describe
            thumbURL:(id)thumbURL
        platformType:(UMSocialPlatformType)platformType
          completion:(UMSocialRequestCompletionHandler)completion;

- (void)shareImage:(UIImage *)shareImage                platformType:(UMSocialPlatformType)platformType
        completion:(UMSocialRequestCompletionHandler)completion;

-(BOOL) isInstall:(UMSocialPlatformType)platformType;

//微信会话分享小程序
- (void)shareMinProgramToPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title descr:(NSString *)descr thumbImage:(UIImage *)thumbImage hdImage:hdImage webUrl:(NSString *)webUrl programId:(NSString *)programId programPath:(NSString *)programPath  withShareResultBlock:(UMSocialRequestCompletionHandler)shareResultBlock;


- (void)shareText:(NSString *)text
     platformType:(UMSocialPlatformType)platformType
       completion:(UMSocialRequestCompletionHandler)completion;*/
@end

NS_ASSUME_NONNULL_END
