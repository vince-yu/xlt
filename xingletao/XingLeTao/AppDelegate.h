//
//  AppDelegate.h
//  XingLeTao
//
//  Created by chenhg on 2019/9/29.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTTabBarController.h"
@class XLTNavigationController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic ,strong) XLTTabBarController *tabBar;
@property (nonatomic ,strong) XLTNavigationController *mainNavigationController;

@end

