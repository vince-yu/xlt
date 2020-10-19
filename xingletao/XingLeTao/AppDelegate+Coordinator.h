//
//  AppDelegate+Coordinator.h
//  XingLeTao
//
//  Created by chenhg on 2019/9/29.
//  Copyright © 2019 snqu. All rights reserved.
//



#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class XLTNavigationController;

@interface AppDelegate (Coordinator) <CAAnimationDelegate, UITabBarControllerDelegate>

- (void)displayRootViewControllerForLaunching;


- (void)displayLoginViewController;

- (void)removeLoginViewController;

- (void)displayVideoNavigationViewController;

- (void)removeVideoNavigationViewController;

@property (nonatomic, assign, nullable) XLTNavigationController *loginNavigationViewController;

@property (nonatomic, assign, nullable) XLTNavigationController *adNavigationViewController;

@property (nonatomic, assign, nullable) XLTNavigationController *videoNavigationViewController;

- (void)addCheckEnableStateObserver;
@end

NS_ASSUME_NONNULL_END
