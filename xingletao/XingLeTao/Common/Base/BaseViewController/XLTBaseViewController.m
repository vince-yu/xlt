//
//  QQWBaseViewController.m
//  ShopAnalytics
//
//  Created by chenhg on 2019/4/23.
//  Copyright © 2019  . All rights reserved.
//

#import "XLTBaseViewController.h"
#import "UIColor+Helper.h"
#import "XLTCircleAnimationView.h"
#import "UIColor+XLTColorConstant.h"
#import "UIImage+UIColor.h"
#import "XLTHomeCustomHeadView.h"
#import <objc/runtime.h>
#import "XLTUserTaskManager.h"
#import "XLTTimeoutProgressView.h"

@interface XLTBaseViewController ()
@property (nonatomic, strong) MBProgressHUD *loadingView;
@end

@implementation XLTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // defaulet backgroundColor
    self.view.backgroundColor = [UIColor letaolightgreyBgSkinColor];
    
    // 处理任务
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self letaoStartTaskIfNeed];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // fix swipe back function when 3D-touch is enabled.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    });
}


- (void)letaoShowLoading {
    if (self.loadingView == nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        hud.square = YES;
        hud.backgroundView.backgroundColor = (self.loadingViewBgColor == nil ? [UIColor clearColor] : self.loadingViewBgColor);
        hud.bezelView.backgroundColor = [UIColor clearColor];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor clearColor];
        hud.mode = MBProgressHUDModeCustomView;
        // customView
        XLTCircleAnimationView *animationView = [[XLTCircleAnimationView alloc] init];
        animationView.translatesAutoresizingMaskIntoConstraints = NO;
        CGSize size = CGSizeMake(80, 80);
        NSLayoutConstraint*customViewWidthConstraint = [NSLayoutConstraint constraintWithItem:animationView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:size.width];
        NSLayoutConstraint*customViewHeightConstraint = [NSLayoutConstraint constraintWithItem:animationView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:size.height];
        [animationView addConstraint:customViewWidthConstraint];
        [animationView addConstraint:customViewHeightConstraint];
        animationView.foregroundColor = UIColorMakeRGBA(255, 130, 2, .5);
//        animationView.foregroundColor =[UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:0.5];
        animationView.defaultBackGroundColor = [UIColor clearColor];
        hud.customView = animationView;
        hud.removeFromSuperViewOnHide = YES;
        [animationView showAnimationWithType:XLTCircleAnimationTypeCircleJoin];
        self.loadingView = hud;
    } else {
        // do nothing
    }

}

- (void)letaoRemoveLoading {
    [self.loadingView hideAnimated:YES];
    self.loadingView = nil;
}

- (void)showTipMessage:(NSString*)message {
    [MBProgressHUD letaoshowTipMessageInWindow:message];
}

- (void)showToastMessage:(NSString*)message {
    [self showTipMessage:message];
}


- (void)letaoPopViewControllerWithParameters:(NSDictionary *)parameters animated:(BOOL)animated {
    if (self.navigationController.viewControllers.count > 1) {
        NSUInteger index = self.navigationController.viewControllers.count -2;
        XLTBaseViewController *targetViewController = self.navigationController.viewControllers[index];
        if (targetViewController != nil) {
            if ([targetViewController conformsToProtocol:@protocol(XLTBaseVCParametersProtocol)]) {
                targetViewController.popParameters = parameters;
            }
        }
        [self.navigationController popViewControllerAnimated:animated];
    }
}

- (void)letaoPopToViewController:(UIViewController *)viewController addParameters:(NSDictionary *)parameters animated:(BOOL)animated {
    XLTBaseViewController *targetViewController = (XLTBaseViewController *)viewController;
    if (targetViewController != nil) {
        if ([targetViewController conformsToProtocol:@protocol(XLTBaseVCParametersProtocol)]) {
            targetViewController.popParameters = parameters;
        }
        [self.navigationController popToViewController:targetViewController animated:animated];
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@implementation XLTBaseViewController (UINavigationBar)
- (void)letaoSetupNavigationWhiteBarWithNoLine {
    [self letaohiddenNavigationBar:NO];
        [self letaoSetupNavigationBarBgWithImage:[UIImage letaoimageWithColor:[UIColor whiteColor]]];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage letaoimageWithColor:[UIColor colorWithHex:0xFFABABAC]]];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        self.navigationController.navigationBar.translucent = NO;
        [self letaoSetupNavigationBarTitleColor:[UIColor colorWithHex:0xff333333]];
        [self letaoconfigLeftPopItemWithColor:[UIColor colorWithHex:0xff555555]];
}
- (void)letaoSetupNavigationBarDefault {
    [self letaohiddenNavigationBar:NO];
    CGSize bgImageSize = CGSizeMake(self.navigationController.navigationBar.frame.size.width, kSafeAreaInsetsTop);
    UIImage *bgImage  = [UIImage gradientColorImageFromColors:@[[UIColor colorWithHex:0xFFFF6E02],[UIColor colorWithHex:0xFFFE8516]] gradientType:0 imgSize:bgImageSize];
    [self letaoSetupNavigationBarBgWithImage:bgImage];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationController.navigationBar.translucent = YES;
    [self letaoSetupNavigationBarTitleColor:[UIColor whiteColor]];
    [self letaoconfigLeftPopItem];    
}

- (void)letaoSetupNavigationWhiteBar {
    [self letaohiddenNavigationBar:NO];
    [self letaoSetupNavigationBarBgWithImage:[UIImage letaoimageWithColor:[UIColor whiteColor]]];    
//    [self.navigationController.navigationBar setShadowImage:[UIImage letaoimageWithColor:[UIColor colorWithHex:0xFFABABAC]]];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.translucent = NO;
    [self letaoSetupNavigationBarTitleColor:[UIColor colorWithHex:0xff333333]];
    [self letaoconfigLeftPopItemWithColor:[UIColor colorWithHex:0xff555555]];
}

- (void)letaoconfigTranslucentNavigation {
    [self letaohiddenNavigationBar:NO];
    [self letaoSetupNavigationBarBgWithImage:[UIImage letaoimageWithColor:[UIColor colorWithWhite:1.0 alpha:0]]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationController.navigationBar.translucent = YES;
    [self letaoSetupNavigationBarTitleColor:[UIColor whiteColor]];
    [self letaoconfigLeftPopItem];
}

- (void)letaoconfigLeftPopItem {
    UIImage *arrow = [[UIImage imageNamed:@"xinletao_nav_left_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:arrow style:UIBarButtonItemStylePlain target:self action:@selector(letaopopViewController)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)letaoconfigLeftPopItemWithColor:(UIColor *)color {
    UIImage *arrow = [[UIImage imageNamed:@"xinletao_nav_left_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:arrow style:UIBarButtonItemStylePlain target:self action:@selector(letaopopViewController)];
    leftItem.tintColor = color;
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)letaoSetupNavigationBarBgWithColor:(UIColor *)color {
    self.navigationController.navigationBar.barTintColor = color;
}

- (void)letaoSetupNavigationBarTitleColor:(UIColor *)color {
    if (color) {
        NSDictionary *dict = @{NSForegroundColorAttributeName : color,
                               NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:18.0]
        };
        [self.navigationController.navigationBar setTitleTextAttributes:dict];
    }
}


- (void)letaoSetupNavigationBarBgWithImage:(UIImage *)image {
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}


- (UIBarButtonItem *)letaoconfigLeftBarItemWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    UIBarButtonItem *leftItem = [self letaoconfigBarItemWithImage:image target:target action:action];
    self.navigationItem.leftBarButtonItem = leftItem;
    return leftItem;
}

- (UIBarButtonItem *)letaoconfigLeftBarItemWithText:(NSString *)text target:(id)target action:(SEL)action {
    UIBarButtonItem *leftItem = [self letaoconfigBarItemWithText:text target:target action:action];
    self.navigationItem.leftBarButtonItem = leftItem;
    return leftItem;
}

- (UIBarButtonItem *)letaoconfigRightBarItemWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    UIBarButtonItem *rightItem = [self letaoconfigBarItemWithImage:image target:target action:action];
    self.navigationItem.rightBarButtonItem = rightItem;
    return rightItem;
}

- (UIBarButtonItem *)letaoconfigRightBarItemWithText:(NSString *)text target:(id)target action:(SEL)action {
    UIBarButtonItem *rightItem = [self letaoconfigBarItemWithText:text target:target action:action];
    self.navigationItem.rightBarButtonItem = rightItem;
    return rightItem;
}


- (UIBarButtonItem *)letaoconfigBarItemWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    UIImage *barButtonImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:barButtonImage style:UIBarButtonItemStylePlain target:self action:action];
    return barButtonItem;
}

- (UIBarButtonItem *)letaoconfigBarItemWithText:(NSString *)text target:(id)target action:(SEL)action {
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStylePlain target:target action:action];
    return barButtonItem;
}

- (void)letaohiddenNavigationBar:(BOOL)hidden {
    [self.navigationController setNavigationBarHidden:hidden animated:YES];
}

- (void)letaopopViewController {
    [self.navigationController popViewControllerAnimated:YES];
    [self.view endEditing:YES];
}
@end


@implementation XLTBaseViewController (BackToTopButton)

/**
*  滚动时是否显示BackToTop按钮，需要在scrollViewDidScroll:中调用
*
*  @param scrollView   滑动视图
*  @param show 是否显示
*/
- (void)xlt_scrollViewDidScroll:(UIScrollView *)scrollView needAutoShowBackToTop:(BOOL)show {
    BOOL shouldShow = show && (scrollView.contentOffset.y >= kScreenHeight);
    if (shouldShow) {
        [self displayBackToTopButtonOnScrollView:scrollView];
    } else {
        [self removeBackToTopButton];
    }
}


- (void)displayBackToTopButtonOnScrollView:(UIScrollView *)scrollView {
    if (self.backToTopButton == nil) {
        UIButton *backToTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backToTopButton setImage:[UIImage imageNamed:@"xlt_backtopbutton"] forState:UIControlStateNormal];
        backToTopButton.layer.masksToBounds = YES;
        backToTopButton.layer.cornerRadius = 28.0;
        [backToTopButton addTarget:self action:@selector(xltBackToTopButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:backToTopButton];
        self.backToTopButton = backToTopButton;
    }
    self.backToTopButton.frame = CGRectMake(scrollView.bounds.size.width - 42 - 22 , scrollView.bounds.size.height - 56 -30 + scrollView.contentOffset.y, 56, 56);
    self.backToTopButton.hidden = NO;
}

- (void)removeBackToTopButton {
    self.backToTopButton.hidden = YES;
}

- (void)xltBackToTopButtonAction {
    if (self.xltBackToTopButtonCallback) {
        self.xltBackToTopButtonCallback();
    }
}


#pragma mark - propertys

const char kXKLTBackToTopButtonKey;
- (UIButton *)backToTopButton {
    UIButton *backToTopButton = objc_getAssociatedObject(self, &kXKLTBackToTopButtonKey);
    return backToTopButton;
}

- (void)setBackToTopButton:(UIButton *)backToTopButton{
    objc_setAssociatedObject(self, &kXKLTBackToTopButtonKey, backToTopButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



const char kXKLTBackToTopButtonCallbackKey;
- (void (^)(void))xltBackToTopButtonCallback {
    id xltBackToTopButtonCallback = objc_getAssociatedObject(self, &kXKLTBackToTopButtonCallbackKey);
    return xltBackToTopButtonCallback;
}

- (void)setXltBackToTopButtonCallback:(void (^)(void))xltBackToTopButtonCallback {
    objc_setAssociatedObject(self, &kXKLTBackToTopButtonCallbackKey, xltBackToTopButtonCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);

}
@end



@implementation XLTBaseViewController (TaskInfo)

const char kXKLTTaskInfoKey;
- (NSDictionary *)taskInfo {
    NSDictionary *taskInfo = objc_getAssociatedObject(self, &kXKLTTaskInfoKey);
    return taskInfo;
}

- (void)setTaskInfo:(NSDictionary *)taskInfo {
     objc_setAssociatedObject(self, &kXKLTTaskInfoKey, taskInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)letaoStartTaskIfNeed {
    if ([self.taskInfo isKindOfClass:[NSDictionary class]] && self.taskInfo.count > 0) {
        // 开始任务
        NSNumber *type = self.taskInfo[@"type"];
        if ([type isKindOfClass:[NSString class]] || [type isKindOfClass:[NSNumber class]]) {
            if ([type integerValue] == 1) {
                // type: 1浏览商品
                [self letaoNeedStartBrowseTaskInfo:self.taskInfo];
            } else if ([type integerValue] == 2) {
                // type: 2分享
                // do nothing
            }
        }
    }
}



- (void)letaoNeedStartBrowseTaskInfo:(NSDictionary *)taskInfo {
    [self letaoNeedStartBrowseTaskInfo:taskInfo toView:self.view];
}

- (void)letaoNeedStartBrowseTaskInfo:(NSDictionary *)taskInfo toView:(UIView *)view {
    if ([self.taskInfo isKindOfClass:[NSDictionary class]]) {
         NSString *taskId = taskInfo[@"id"];
        if (taskId) {
            __weak typeof(self)weakSelf = self;
            [[XLTUserTaskManager shareManager] letaofetchTaskSatusWithId:taskId success:^(NSDictionary *info,XLTBaseModel *model) {
                NSNumber *status = [info objectForKey:@"user_status"];
                if ([status isKindOfClass:[NSNumber class]] || [status isKindOfClass:[NSString class]]) {
                    if (status.intValue == 3) { // 成功
                        // 用户参加状态 1-未参与任务 2-已参加已完成任务 3-已参加未完成任务
                        [weakSelf letaoStartBrowseTaskInfo:taskInfo toView:view];
                    }
                }
            } failure:^(NSString * _Nonnull errorMsg) {
                
            }];
        }
    }
}

- (void)letaoStartBrowseTaskInfo:(NSDictionary *)taskInfo toView:(UIView *)view {
    if ([self.taskInfo isKindOfClass:[NSDictionary class]]) {
        // 浏览任务
        NSNumber *countDownNumber = taskInfo[@"countDown"];
        CGFloat countDown = ([countDownNumber isKindOfClass:[NSNumber class]] || [countDownNumber isKindOfClass:[NSString class]]) ? [countDownNumber floatValue] : 10.0;
        NSString *reward  = taskInfo[@"reward"];
        NSString *money = [NSString stringWithFormat:@"+%@",reward];
        NSMutableAttributedString *progressText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",money]];
        [progressText addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:25.0],
                                      NSForegroundColorAttributeName:[UIColor letaomainColorSkinColor]
        } range:NSMakeRange(0, progressText.length)];
        
        NSMutableAttributedString *timeoutText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已获得\n%@",money]];
        [timeoutText addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFFFA902]
        } range:NSMakeRange(0, timeoutText.length)];

        [timeoutText addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:12.0]
        } range:NSMakeRange(0, 3)];
        
        [timeoutText addAttributes:@{NSFontAttributeName:[UIFont letaoMediumBoldFontWithSize:22.0]
        } range:NSMakeRange(timeoutText.length - money.length, money.length)];
        
        XLTTimeoutProgressView *progressView = [XLTTimeoutProgressView showProgressViewAddedTo:self.view timeout:countDown progressText:progressText timeoutText:timeoutText];
        progressView.taskInfo = taskInfo;
    }
}
@end
