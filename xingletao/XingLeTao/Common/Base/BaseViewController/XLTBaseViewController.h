//
//  XLTBaseViewController.h
//  ShopAnalytics
//
//  Created by chenhg on 2019/4/23.
//  Copyright © 2019  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTTipConstant.h"
#import "UIColor+Helper.h"
#import "XLTNetworkHelper.h"
#import "MBProgressHUD+TipView.h"
#import "XLTUIConstant.h"
#import "UIColor+XLTColorConstant.h"

NS_ASSUME_NONNULL_BEGIN

/**
* 参数parameters设置协议
*/

@protocol XLTBaseVCParametersProtocol <NSObject>

@required
/// pop给上个页面的参数
@property (nonatomic, copy) NSDictionary *popParameters;
/// 扩展参数
@property (nonatomic, copy) NSDictionary *extenParameters;

@end


@interface XLTBaseViewController : UIViewController <XLTBaseVCParametersProtocol>

// 这个有bug，有可能不生效，需要重写letaoShowLoading方法，并在super前，暂时没时间修改
@property (nonatomic, strong) UIColor *loadingViewBgColor;

- (void)letaoShowLoading;

- (void)letaoRemoveLoading;

- (void)showTipMessage:(NSString*)message;

- (void)showToastMessage:(NSString*)message;


/// pop给上个页面的参数
@property (nonatomic, copy, nullable) NSDictionary *popParameters;
/// 扩展参数
@property (nonatomic, copy, nullable) NSDictionary *extenParameters;

/**
*  POP当前ViewController
*
*  @param parameters  设置到popParameters
*  @param animated 动画
*/

- (void)letaoPopViewControllerWithParameters:(NSDictionary *)parameters animated:(BOOL)animated;

/**
*  POP 到指定ViewController
*
*  @param viewController  指定ViewController
*  @param parameters  设置到popParameters
*  @param animated 动画
*/

- (void)letaoPopToViewController:(UIViewController *)viewController addParameters:(NSDictionary *)parameters animated:(BOOL)animated;

@end


@interface XLTBaseViewController (UINavigationBar)

// 默认设置
- (void)letaoSetupNavigationBarDefault;
- (void)letaoSetupNavigationWhiteBar;
- (void)letaoconfigTranslucentNavigation;
- (void)letaoSetupNavigationWhiteBarWithNoLine;
- (void)letaoconfigLeftPopItem;

- (void)letaoconfigLeftPopItemWithColor:(UIColor *)color;

- (void)letaoSetupNavigationBarBgWithColor:(UIColor *)color;

- (void)letaoSetupNavigationBarTitleColor:(UIColor *)color;

- (void)letaoSetupNavigationBarBgWithImage:(UIImage *)image;



- (UIBarButtonItem *)letaoconfigLeftBarItemWithImage:(UIImage *)image target:(id)target action:(SEL)action;

- (UIBarButtonItem *)letaoconfigLeftBarItemWithText:(NSString *)text target:(id)target action:(SEL)action;

- (UIBarButtonItem *)letaoconfigRightBarItemWithImage:(UIImage *)image target:(id)target action:(SEL)action;

- (UIBarButtonItem *)letaoconfigRightBarItemWithText:(NSString *)text target:(id)target action:(SEL)action;


- (void)letaohiddenNavigationBar:(BOOL)hidden;

@end


@interface XLTBaseViewController (BackToTopButton)

///BackToTop按钮
@property (nonatomic, assign, nullable) UIButton *backToTopButton;


///BackToTop按钮点击事件
@property (nonatomic, copy) void(^xltBackToTopButtonCallback)(void);

/**
*  滚动时是否显示BackToTop按钮，需要在scrollViewDidScroll:中调用
*
*  @param scrollView   滑动视图
*  @param show 是否显示
*/
- (void)xlt_scrollViewDidScroll:(UIScrollView *)scrollView needAutoShowBackToTop:(BOOL)show;


@end



@interface XLTBaseViewController (TaskInfo)
/// 任务信息数据
@property (nonatomic, strong, nullable) NSDictionary *taskInfo;
/**
*  任务开始，如果存在任务的话
*/
- (void)letaoStartTaskIfNeed;

@end

NS_ASSUME_NONNULL_END
