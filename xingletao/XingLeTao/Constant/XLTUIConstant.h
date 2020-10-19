//
//  XLTUIConstant.h
//  ShopAnalytics
//
//  Created by chenhg on 2019/4/23.
//  Copyright © 2019  . All rights reserved.
//

#ifndef XLTUIConstant_h
#define XLTUIConstant_h

#import "UIColor+XLTColorConstant.h"
#import "UIFont+XLTFontConstant.h"

#define kStatusBarHeight  ((![[UIApplication sharedApplication] isStatusBarHidden] ) ? [[UIApplication sharedApplication] statusBarFrame].size.height : (iPhoneX_All?44.f:20.f))

#define kNavigationBarHeight 44.0
#define kSafeAreaInsetsTop (kStatusBarHeight + kNavigationBarHeight)

#define kScreenWidth                    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight                    [UIScreen mainScreen].bounds.size.height
#define kScreen_iPhone375Scale(A) ceil(kScreenWidth/375.0*A)

#define kPlaceholderLargeImage [UIImage imageNamed:@"xinletao_placeholder_loading_large"]
#define kPlaceholderSmallImage [UIImage imageNamed:@"xinletao_placeholder_loading_small"]
#define kStorePlaceholderImage [UIImage imageNamed:@"xinletao_gooddetail_store_placeholder"]
#define kIconPlaceholderImage [UIImage imageNamed:@"xinletao_icon_placeholder"]

//字体类型 苹方字体在iOS 9.0以后才引入
static NSString * const kSDPFRegularFont = @"PingFangSC-Regular"; //常规字体
static NSString * const kSDPFBoldFont = @"PingFangSC-Semibold"; //粗体
//static NSString * const kSDPFSemibolFont = @"PingFangSC-Semibold"; // 中粗体
static NSString * const kSDPFMediumFont = @"PingFangSC-Medium"; //黑体
static NSString * const kSDPFLightFont = @"PingFangSC-Light"; //细体
static NSString * const kSDPFUltralightFont = @"PingFangSC-Ultraligh"; //极细体
static NSString * const kSDPFThinFont = @"PingFangSC-Thin"; //纤细体

//weakSelf and strongSelf
#ifndef    weakify

#define weakify(x) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")

#endif

#ifndef    strongify

#define strongify(x) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")

#endif

#define XLT_WeakSelf        @weakify(self);
#define XLT_StrongSelf      @strongify(self);

#define iPhoneX_All ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)
#define kNavBarHeight 44.0
#define kTopHeight (kStatusBarHeight + kNavBarHeight)
#define kTabBarHeight (iPhoneX_All ? 83.0 : 49.0)
#define kBottomSafeHeight (iPhoneX_All? 34.0f:0.0f)

#pragma mark 通知
#define kXLTNotifiLoginSuccess @"kXLTNotifiLoginSuccess"
#define kXLTNotifiLogoutSuccess @"kXLTNotifiLogoutSuccess"

#define kXLTLoginViewControllerDidDismissedNotification @"kXLTLoginViewControllerDidDismissedNotification"
#define kLetaoCheckEnableChangedNotification @"kLetaoCheckEnableChangedNotification"

#define kXLTUpdateMyInviterNotifications @"kkXLTUpdateMyInviterNotifications"
#endif /* QQWUIConstant_h */
