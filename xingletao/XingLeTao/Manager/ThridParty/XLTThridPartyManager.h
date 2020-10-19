//
//  XLTThridPartyManager.h
//
//  Created by chenhg on 2019/4/26.
//  Copyright © 2019 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface XLTThridPartyManager : NSObject

@property (nonatomic ,assign) BOOL registerForRemoteNotificationscompled;

+ (instancetype)shareManager;

- (void)registerSdks;


- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler;



@end

NS_ASSUME_NONNULL_END
