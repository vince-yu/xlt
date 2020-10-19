//
//  AppDelegate+Coordinator.m
//  XingLeTao
//
//  Created by chenhg on 2019/9/29.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "AppDelegate+Coordinator.h"
#import "XLTUserLoginVC.h"
#import "XLTHomePageVC.h"
#import "XLTNavigationController.h"
#import "XLTUserManager.h"
#import <objc/runtime.h>
#import "XLTTabBarController.h"
#import "XLTUserCentreVC.h"
#import "XLTCategoryListVC.h"
#import "XLTAppPlatformManager.h"
#import "XLTShareFeedContainerVC.h"
#import "XLTVipVC.h"
#import "XLTFullScreenSJVideoVC.h"
#import "XLTIntroViewController.h"
#import "XLTUpdateMyInviterVC.h"
#import "MBProgressHUD+TipView.h"
#import "XLTInvetorAlterView.h"
#import "XLTPrivilegeViewController.h"

@implementation AppDelegate (Coordinator)

- (void)addCheckEnableStateObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedLetaoCheckEnableChangedNotification) name:kLetaoCheckEnableChangedNotification object:nil];
}

- (void)receivedLetaoCheckEnableChangedNotification {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *viewControllers = [self.tabBar.viewControllers mutableCopy];
        if (![XLTAppPlatformManager shareManager].checkEnable) {
            if (viewControllers.count > 2) {
                XLTVipVC *vipVC = viewControllers[2];
                if ([vipVC isKindOfClass:[XLTVipVC class]]) {
                    [viewControllers removeObject:vipVC];
                }
            }
           
        } else {
            if (viewControllers.count > 2) {
                XLTVipVC *vipVC = viewControllers[2];
                if (![vipVC isKindOfClass:[XLTVipVC class]]) {
                    vipVC = [self createVipVC];
                    [viewControllers insertObject:vipVC atIndex:2];
                }
            }
        }
        self.tabBar.viewControllers = viewControllers;
    });
}


- (XLTVipVC *)createVipVC {
    XLTVipVC *vipVC = [[XLTVipVC alloc] init];
    UITabBarItem *vipTabBarItem = [[UITabBarItem alloc]initWithTitle:@"会员" image:[[UIImage imageNamed:@"tabBar_vip_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"tabBar_vip_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self setupTitleColorAttributesForTabBarItem:vipTabBarItem];
    vipVC.tabBarItem = vipTabBarItem;
    return vipVC;
}

- (void)displayRootViewControllerForLaunching {
    if ([XLTAppPlatformManager.shareManager isFristInstall]) {
        if (self.mainNavigationController == nil) {
            self.mainNavigationController = [[XLTNavigationController alloc] init];
        }
        XLTIntroViewController *introViewController =  [[XLTIntroViewController alloc] init];
        self.mainNavigationController.viewControllers = @[introViewController].mutableCopy;
        self.window.rootViewController = self.mainNavigationController;
        
    } else {
        if (self.mainNavigationController == nil) {
            self.mainNavigationController = [[XLTNavigationController alloc] init];
        }
        //  删除introViewController
        NSMutableArray *viewControllers = self.mainNavigationController.viewControllers.mutableCopy;
        if (viewControllers == nil) {
            viewControllers = [NSMutableArray array];
        }
        [self.mainNavigationController.viewControllers enumerateObjectsUsingBlock:^(UIViewController *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[XLTIntroViewController class]]) {
                [viewControllers removeObject:obj];
            }
         }];
        
        XLTHomePageVC *homeViewController = [[XLTHomePageVC alloc] init];
         UITabBarItem *homeTabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:[[UIImage imageNamed:@"tabBar_home_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"tabBar_home_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
         [self setupTitleColorAttributesForTabBarItem:homeTabBarItem];
         homeViewController.tabBarItem = homeTabBarItem;
         
         // 特权
         XLTPrivilegeViewController *categoryGoodsListViewController = [[XLTPrivilegeViewController alloc] init];
        categoryGoodsListViewController.needBack = YES;
        categoryGoodsListViewController.jump_URL = kXLTTQJCH5Url;
//        categoryGoodsListViewController.fullScreen = YES;
         UITabBarItem *categoryTabBarItem = [[UITabBarItem alloc]initWithTitle:@"特权" image:[[UIImage imageNamed:@"tabBar_tq_nomal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"tabBar_tq_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
         [self setupTitleColorAttributesForTabBarItem:categoryTabBarItem];
         categoryGoodsListViewController.tabBarItem = categoryTabBarItem;
         
         // 圈子
         XLTShareFeedContainerVC *shareFeedContainerVC = [[XLTShareFeedContainerVC alloc] init];
         UITabBarItem *shareFeedTabBarItem = [[UITabBarItem alloc]initWithTitle:@"发圈" image:[[UIImage imageNamed:@"tabBar_circle_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"tabBar_circle_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
         [self setupTitleColorAttributesForTabBarItem:shareFeedTabBarItem];
         shareFeedContainerVC.tabBarItem = shareFeedTabBarItem;
         
         // 我的
         XLTUserCentreVC *mineViewController = [[XLTUserCentreVC alloc] init];
         UITabBarItem *mineTabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:[[UIImage imageNamed:@"tabBar_mine_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"tabBar_mine_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
         [self setupTitleColorAttributesForTabBarItem:mineTabBarItem];
         mineViewController.tabBarItem = mineTabBarItem;
         
         XLTTabBarController *tabBarController = [[XLTTabBarController alloc] init];
         tabBarController.delegate = self;
         if (@available(iOS 10.0, *)) {
             [tabBarController.tabBar setUnselectedItemTintColor:[UIColor colorWithHex:0xFF1F0B10]];
         } else {
             // Fallback on earlier versions
         }
         tabBarController.tabBar.translucent = NO;
         if (![XLTAppPlatformManager shareManager].checkEnable) {
             tabBarController.viewControllers = @[homeViewController,
                                                  categoryGoodsListViewController,
                                                  shareFeedContainerVC,
                                                  mineViewController];
         } else {
             tabBarController.viewControllers = @[homeViewController,
                                                  categoryGoodsListViewController,
                                                  [self createVipVC],
                                                  shareFeedContainerVC,
                                                  mineViewController];
         }

        self.tabBar = tabBarController;
        
        if (viewControllers.count > 0) {
            [viewControllers insertObject:self.tabBar atIndex:0];
        } else {
            [viewControllers addObject:self.tabBar];
        }
        self.mainNavigationController.viewControllers = viewControllers;
        self.window.rootViewController = self.mainNavigationController;
    }
 
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)displayLoginViewController {
    if (self.videoNavigationViewController) {
        // 正在播放视频，暂时不处理
        return;
    }
    if(![self loginNavigationViewController]) {
        XLTUserLoginVC *loginViewController = [[XLTUserLoginVC alloc] initWithNibName:@"XLTUserLoginVC" bundle:[NSBundle mainBundle]];
        XLTNavigationController *navigationController = [[XLTNavigationController alloc] initWithRootViewController:loginViewController];
        [navigationController setNavigationBarHidden:YES];
        [self.window addSubview:navigationController.view];
        [self presentNavigationControllerAnimation:navigationController];
        [self setLoginNavigationViewController:navigationController];
    }
}

- (void)removeLoginViewController {
    XLTNavigationController *navigationController = [self loginNavigationViewController];
    if (navigationController) {
        [self dimissNavigationControllerAnimation:navigationController forKey:@"removeLoginViewController"];
    }
}



- (void)presentNavigationControllerAnimation:(XLTNavigationController *)navigationController {
    if ([navigationController isKindOfClass:[XLTNavigationController class]]) {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
        [navigationController.view.layer addAnimation:transition forKey:nil];
    }
}

- (void)dimissNavigationControllerAnimation:(XLTNavigationController *)navigationController forKey:(NSString *)animationKey {
    if ([navigationController isKindOfClass:[XLTNavigationController class]]) {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.delegate = self;
        if (animationKey) {
            [transition setValue:animationKey forKey:@"dimissIndicate"];
        }
        transition.type = kCATransitionReveal;
        transition.subtype = kCATransitionFromBottom;
        [navigationController.view.layer addAnimation:transition forKey:nil];
        navigationController.view.hidden = YES;
       }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *dimissIndicate = [anim valueForKey:@"dimissIndicate"];
    if ([dimissIndicate isKindOfClass:[NSString class]]) {
        if([dimissIndicate isEqualToString:@"removeLoginViewController"]) {
            [self.loginNavigationViewController.view removeFromSuperview];
            [self setLoginNavigationViewController:nil];
            //发送登录页面关闭通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kXLTLoginViewControllerDidDismissedNotification object:nil userInfo:nil];
            // 显示强制微信登录
            [[XLTAppPlatformManager shareManager] showbindWXTipViewIfNeed];
        } else if([dimissIndicate isEqualToString:@"removeVideoViewController"]) {
            [self.videoNavigationViewController.view removeFromSuperview];
            [self setVideoNavigationViewController:nil];
        }
    }
}


#pragma mark - loginNavigationViewController
const char kLloginNavigationViewControllerKey;
- (XLTNavigationController *)loginNavigationViewController {
    XLTNavigationController *loginNavigationViewController = objc_getAssociatedObject(self.window, &kLloginNavigationViewControllerKey);
    return loginNavigationViewController;
}

- (void)setLoginNavigationViewController:(XLTNavigationController  *)loginNavigationViewController {
    objc_setAssociatedObject(self.window, &kLloginNavigationViewControllerKey, loginNavigationViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - adNavigationViewController
const char kAdNavigationViewController;
- (XLTNavigationController *)adNavigationViewController {
    XLTNavigationController *adNavigationViewController = objc_getAssociatedObject(self.window, &kAdNavigationViewController); 
    return adNavigationViewController;
}

- (void)setAdNavigationViewController:(XLTNavigationController *)adNavigationViewController {
    objc_setAssociatedObject(self.window, &kAdNavigationViewController, adNavigationViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - adNavigationViewController
const char kVideoNavigationViewController;
- (XLTNavigationController *)videoNavigationViewController {
    XLTNavigationController *videoNavigationViewController = objc_getAssociatedObject(self.window, &kVideoNavigationViewController);
    return videoNavigationViewController;
}

- (void)setVideoNavigationViewController:(XLTNavigationController *)videoNavigationViewController{
    objc_setAssociatedObject(self.window, &kVideoNavigationViewController, videoNavigationViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)displayVideoNavigationViewController {
    XLTFullScreenSJVideoVC *videoViewController = [[XLTFullScreenSJVideoVC alloc] init];
    XLTNavigationController *navigationController = [[XLTNavigationController alloc] initWithRootViewController:videoViewController];
    [navigationController setNavigationBarHidden:YES];
    [self.window addSubview:navigationController.view];
    [self presentNavigationControllerAnimation:navigationController];
    [self setVideoNavigationViewController:navigationController];
}

- (void)removeVideoNavigationViewController {
    XLTNavigationController *navigationController = [self videoNavigationViewController];
    if (navigationController) {
        [self dimissNavigationControllerAnimation:navigationController forKey:@"removeVideoViewController"];
    }
}




- (void)setupTitleColorAttributesForTabBarItem:(UITabBarItem *)tabBarItem {
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHex:0xFF1F0B10], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor letaomainColorSkinColor], NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
   
}

#pragma mark -  UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    // 汇报事件
    NSUInteger pageIndex = [tabBarController.viewControllers indexOfObject:viewController];
    NSDictionary *properties = nil;
    switch (pageIndex) {
        case 0:
            properties = @{@"xlt_item_title":@"首页"};
            break;
        case 1:
            properties = @{@"xlt_item_title":@"分类"};
            break;
        case 2:
            properties = @{@"xlt_item_title":@"会员"};
            break;
        case 3:
            properties = @{@"xlt_item_title":@"发圈"};
            break;
        case 4:
            properties = @{@"xlt_item_title":@"我的"};
            break;
            
        default:
            break;
    }
    if (properties != nil) {
        [SDRepoManager xltrepo_trackEvent:XLT_EVENT_HOME_TAB properties:properties];
    }

    // 双击我的
    if (pageIndex == tabBarController.selectedIndex
        && pageIndex == tabBarController.viewControllers.count - 1) {
        XLTUserCentreVC *userCentreVC = (XLTUserCentreVC *)viewController;
        if ([userCentreVC isKindOfClass:[XLTUserCentreVC class]]) {
            [userCentreVC pagerViewScrolToTop];
        }
    }
    
    // 双击首页
      if (pageIndex == tabBarController.selectedIndex
          && pageIndex == 0) {
          XLTHomePageVC *homePageVC = (XLTHomePageVC *)viewController;
          if ([homePageVC isKindOfClass:[XLTHomePageVC class]]) {
              [homePageVC pagerViewScrolToTop];
          }
      }
    
    
    if ([viewController isKindOfClass:[XLTShareFeedContainerVC class]] || [viewController isKindOfClass:[XLTVipVC class]] || [viewController isKindOfClass:[XLTPrivilegeViewController class]]) {
        if (![XLTUserManager shareManager].isLogined) {
            [[XLTUserManager shareManager] displayLoginViewController];
            return NO;
        } else  if (![XLTUserManager shareManager].isInvited) {
            if ([XLTAppPlatformManager shareManager].checkEnable) {
                // 邀请页面
                [MBProgressHUD letaoshowTipMessageInWindow:@"请先设置上级邀请码"];
                XLTUpdateMyInviterVC *updateMyInviterVC = [[XLTUpdateMyInviterVC alloc] init];
                [self.mainNavigationController pushViewController:updateMyInviterVC animated:YES];
                return NO;
            }
        }
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[XLTUserCentreVC class]]) {
        // 有上级微信号，才显示
        NSString *tutor_wechat_show_uid = [XLTUserManager shareManager].curUserInfo.tutor_wechat_show_uid;

        if ([tutor_wechat_show_uid isKindOfClass:[NSString class]] && tutor_wechat_show_uid.length > 0) {
            [[XLTAppPlatformManager shareManager] increasePopContactInstructorCountIfNeed];
            if ([[XLTAppPlatformManager shareManager] isNeedPopContactInstructor]) {
                NSString *avatar = [XLTUserManager shareManager].curUserInfo.tutor_inviter_avatar;
                if (![avatar isKindOfClass:[NSString class]]) {
                    avatar = @"";
                }
                
                NSString *userName = [XLTUserManager shareManager].curUserInfo.userNameInfo;
                if (![userName isKindOfClass:[NSString class]]) {
                     userName = @"";
                }
                
                __weak typeof(self)weakSelf = self;
                [XLTInvetorAlterView showNamalAlterWithTitle:[@"嗨，" stringByAppendingString:userName] content:@"我是你的专属导师，加我微信可领免费课程一对一指导~快来加我的微信吧" weixin:tutor_wechat_show_uid avtor:avatar leftBlock:^{
                    [[XLTAppPlatformManager shareManager] needPopContactInstructorState:@0];
                } rightBlock:^{
                    [[XLTAppPlatformManager shareManager] needPopContactInstructorState:@0];
                    [MBProgressHUD letaoshowTipMessageInWindow:@"复制成功"];
                    [UIPasteboard generalPasteboard].string = tutor_wechat_show_uid;
                    [weakSelf openWXAction];
                }];
            }
        }
    }
}

- (void)openWXAction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSURL *weixinURL = [NSURL URLWithString:@"weixin://"];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:weixinURL options:@{} completionHandler:nil];
        } else {
            // Fallback on earlier versions
            [[UIApplication sharedApplication] openURL:weixinURL];
        }
    });
}
@end
