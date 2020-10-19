//
//  XLTUPushManager.m
//  XingLeTao
//
//  Created by chenhg on 2020/2/5.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTUPushManager.h"
#import <UMPush/UMessage.h>
#import "XLTUserManager.h"
#import "AppDelegate.h"
#import "XLTTabBarController.h"
#import "XLTWKWebViewController.h"
#import "XLTGoodsDetailVC.h"
#import "XLTCollectVC.h"
#import "XLTMyTeamVC.h"
#import "XLTIncomeVC.h"
#import "XLTUserInvateVC.h"
#import "XLTUserBalanceDrawVC.h"
#import "XLTUserBindAliPayVC.h"
#import "XLTUserWithDrawVC.h"
#import "XLTRootOrderVC.h"
#import "XLTActivityVC.h"
#import "XLTUpdateMyInviterVC.h"

@interface XLTUPushManager ()

@property (nonatomic, copy) NSString *lastPage;
@property (nonatomic, strong) NSDictionary *lastParamInfo;

@end

@implementation XLTUPushManager

+ (instancetype)shareManager {
    static XLTUPushManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(letaoLoginSuccessNotification) name:kXLTNotifiLoginSuccess object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginViewControllerDidDismissedNotification) name:kXLTLoginViewControllerDidDismissedNotification object:nil];
    }
    return self;
}


- (void)letaoLoginSuccessNotification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addAliasIfNeed];
        if (self.lastPage || self.lastParamInfo) {
            [self openPage:self.lastPage paramInfo:self.lastParamInfo];
            self.lastPage = nil;
            self.lastParamInfo = nil;
        }
    });
}

- (void)loginViewControllerDidDismissedNotification {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 登录页面关闭的时候，清理缓存信息
        self.lastPage = nil;
        self.lastParamInfo = nil;
    });
}


//绑定别名
- (void)addAliasIfNeed {
    NSString *uid = [XLTUserManager shareManager].curUserInfo._id;
    if (uid) {
        [UMessage addAlias:uid type:@"xlt" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        }];
    }
}
//移除别名
- (void)removeAliasIfNeed {
    //移除别名
    NSString *uid = [XLTUserManager shareManager].curUserInfo._id;
     if (uid) {
         [UMessage removeAlias:uid type:@"xlt" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
         }];
     }
}


#define kPassBodyKey  @"passBody"
- (void)receiveRemoteNotification:(NSDictionary *)userInfo {
    
    self.lastPage = nil;
    self.lastParamInfo = nil;

    NSDictionary *aps = userInfo[@"aps"];
    if ([aps isKindOfClass:[NSDictionary class]]) {
        NSString *passBodyText = aps[kPassBodyKey];
        if ([passBodyText isKindOfClass:[NSString class]]) {
            NSDictionary *passBodyInfo = [self dictionaryWithJSON:passBodyText];
            if ([passBodyInfo isKindOfClass:[NSDictionary class]] && passBodyInfo.count) {
                // 处理透传消息
                NSString *notificationId = [passBodyInfo[@"id"] isKindOfClass:[NSString class]] ? passBodyInfo[@"id"] : nil;
                if (notificationId) {
                    // 汇报点击事件
                    [self repoOpenRemoteNotificationEvent:notificationId];
                    NSDictionary *param = [passBodyInfo[@"param"] isKindOfClass:[NSDictionary class]] ? passBodyInfo[@"param"] : nil;
                    NSMutableDictionary *dic = @{}.mutableCopy;
                    dic[@"push_id"] = [SDRepoManager repoResultValue:notificationId];
                    dic[@"message_title"] = [SDRepoManager repoResultValue:passBodyInfo[@"title"]];
                    dic[@"message_content"] = [SDRepoManager repoResultValue:passBodyInfo[@"content"]];
                    dic[@"valid_time"] = [SDRepoManager repoResultValue:passBodyInfo[@"expire_time"]];
                    dic[@"skip_url"] = [SDRepoManager repoResultValue:param[@"url"]];
                    dic[@"skip_name"] = @"null";
                    dic[@"target_people"] = @"null";
                    dic[@"push_time"] = @"null";
//                    dic[@"push_close"] = @"null";
                    [SDRepoManager xltrepo_trackEvent:XLT_EVENT_PUSH_CLICK properties:dic];
                    
                }
                NSString *page = [passBodyInfo[@"page"] isKindOfClass:[NSString class]] ? passBodyInfo[@"page"] : nil;
                NSDictionary *param = [passBodyInfo[@"param"] isKindOfClass:[NSDictionary class]] ? passBodyInfo[@"param"] : nil;
                [self openPage:page paramInfo:param];
            }
        }
    }
}

 // 处理透传消息
- (void)openPage:(NSString *)page paramInfo:(NSDictionary *)param {
    if ([page isKindOfClass:[NSString class]]){
        if ([page isEqualToString:@"openCategory"]) { // 打开首页分类界面
            [self openCategoryWithParamInfo:param];
        } else if ([page isEqualToString:@"openVipTab"]) { // 打开会员界面
            [self openVipTabWithPage:page paramInfo:param];
        } else if ([page isEqualToString:@"openCommunity"]) { // 打开发圈界面
            [self openShareFeedTabWithPage:page paramInfo:param];
        } else if ([page isEqualToString:@"openUser"]) { //  打开个人中心
            [self openUserTabWithPage:page paramInfo:param];
        } else if ([page isEqualToString:@"openWebview"]) { //  打开webview页面
            [self openWebWithPage:page paramInfo:param];
        } else if ([page isEqualToString:@"openGoodsDetail"]) { // 打开商品详情页
            [self openGoodsDetailWithPage:page paramInfo:param];
        } else if ([page isEqualToString:@"openSelfOrder"]) { // 打开我的订单页面
            [self openSelfOrderWithPage:page paramInfo:param];
        } else if ([page isEqualToString:@"openGroupOrder"]) { // 打开粉丝订单页面
            [self openGroupOrderWithPage:page paramInfo:param];
        } else if ([page isEqualToString:@"openMyCollection"]) { // 打开我的收藏页面
            [self openMyCollectionWithPage:page paramInfo:param];
        } else if ([page isEqualToString:@"openMyTeam"]) { //  打开我的粉丝页面
            [self openMyTeamWithPage:page paramInfo:param];
        } else if ([page isEqualToString:@"openIncomeReport"]) { // 打开收益报表页面
            [self openIncomeReportWithPage:page paramInfo:param];
        } else if ([page isEqualToString:@"openInvitate"]) { // 打开邀请好友页面
            [self openInvitateWithPage:page paramInfo:param];
        } else if ([page isEqualToString:@"openSelfBalance"]) { // 打开我的余额界面
            [self openSelfBalanceWithPage:page paramInfo:param];
        } else if ([page isEqualToString:@"openBindAlipay"]) { // 打开绑定支付宝页面
            [self openBindAlipayWithPage:page paramInfo:param];
        } else if ([page isEqualToString:@"openWithDraw"]) { // 提现
            [self openWithDrawWithPage:page paramInfo:param];
        } else if ([page isEqualToString:@"openActivityDetail"]) { // ACT活动页面
            [self openWithACTActivityWithPage:page paramInfo:param];
        }
    }
}

// 打开首页分类界面
- (void)openCategoryWithParamInfo:(NSDictionary *)param  {
    [self.rootNavigationController popToRootViewControllerAnimated:YES];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    XLTTabBarController *tab = delegate.tabBar;
    if (tab.viewControllers.count > 1) {
        tab.selectedIndex = 1;
    }
}

// 打开会员界面
- (void)openVipTabWithPage:(NSString *)page paramInfo:(NSDictionary *)param  {
    if (![XLTUserManager shareManager].isLogined) {
        [self openLoginWithPage:page paramInfo:param];
    } else {
        [self.rootNavigationController popToRootViewControllerAnimated:YES];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        XLTTabBarController *tab = delegate.tabBar;
        if (tab.viewControllers.count > 2) {
            tab.selectedIndex = 2;
        }
    }
}

// 打开发圈界面
- (void)openShareFeedTabWithPage:(NSString *)page paramInfo:(NSDictionary *)param  {
    if (![XLTUserManager shareManager].isLogined) {
        [self openLoginWithPage:page paramInfo:param];
    } else {
        [self.rootNavigationController popToRootViewControllerAnimated:YES];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        XLTTabBarController *tab = delegate.tabBar;
        if (tab.viewControllers.count > 3) {
            tab.selectedIndex = 3;
        }
    }
}


//  打开个人中心
- (void)openUserTabWithPage:(NSString *)page paramInfo:(NSDictionary *)param {
    [self.rootNavigationController popToRootViewControllerAnimated:YES];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    XLTTabBarController *tab = delegate.tabBar;
    if (tab.viewControllers.count > 0) {
        tab.selectedIndex = tab.viewControllers.count -1;
    }
}

//  打开webview页面
- (void)openWebWithPage:(NSString *)page paramInfo:(NSDictionary *)param  {
    if ([param isKindOfClass:[NSDictionary class]]) {
        NSString *url = param[@"url"];
        if ([url isKindOfClass:[NSString class]] && url.length > 0) {
            XLTWKWebViewController *web =  [[XLTWKWebViewController alloc] init];
            web.jump_URL = url;
            web.title = @"星乐桃";
            [self.rootNavigationController pushViewController:web animated:YES];
        }
    }
}

//  打开商品详情
- (void)openGoodsDetailWithPage:(NSString *)page paramInfo:(NSDictionary *)param  {
    if ([param isKindOfClass:[NSDictionary class]]) {
        NSString *letaoGoodsId = param[@"id"];
        NSString *item_source = param[@"item_source"];
        NSString *item_id = param[@"item_id"];
        if ([letaoGoodsId isKindOfClass:[NSString class]] && letaoGoodsId.length > 0) {
            XLTGoodsDetailVC *goodDetailViewController = [[XLTGoodsDetailVC alloc] init];
            goodDetailViewController.letaoGoodsId = letaoGoodsId;
            goodDetailViewController.letaoIsCustomPlate = NO;
            goodDetailViewController.letaoGoodsSource = item_source;
            NSString *letaoGoodsItemId = item_id;
            goodDetailViewController.letaoGoodsItemId = letaoGoodsItemId;

            [self.rootNavigationController pushViewController:goodDetailViewController animated:YES];
        }
    }
}


// 我的订单
- (void)openSelfOrderWithPage:(NSString *)page paramInfo:(NSDictionary *)param  {
    if (![XLTUserManager shareManager].isLogined) {
        [self openLoginWithPage:page paramInfo:param];
    } else {
        XLTRootOrderVC *vc = [[XLTRootOrderVC alloc] init];
        [self.rootNavigationController pushViewController:vc animated:YES];
    }
}

// 打开粉丝订单页面
- (void)openGroupOrderWithPage:(NSString *)page paramInfo:(NSDictionary *)param {
    if (![XLTUserManager shareManager].isLogined) {
        [self openLoginWithPage:page paramInfo:param];
    } else {
        XLTRootOrderVC *vc = [[XLTRootOrderVC alloc] init];
        [self.rootNavigationController pushViewController:vc animated:YES];
    }
}


// 打开我的收藏页面
- (void)openMyCollectionWithPage:(NSString *)page paramInfo:(NSDictionary *)param  {
    if (![XLTUserManager shareManager].isLogined) {
        [self openLoginWithPage:page paramInfo:param];
    } else {
        XLTCollectVC *vc = [[XLTCollectVC alloc] init];
        [self.rootNavigationController pushViewController:vc animated:YES];
    }

}

// 打开我的粉丝页面
- (void)openMyTeamWithPage:(NSString *)page paramInfo:(NSDictionary *)param  {
    if (![XLTUserManager shareManager].isLogined) {
        [self openLoginWithPage:page paramInfo:param];
    } else {
        if (![XLTUserManager shareManager].isInvited) {
            if ([XLTAppPlatformManager shareManager].checkEnable) {
                // 邀请页面
                [MBProgressHUD letaoshowTipMessageInWindow:@"请先设置上级邀请码"];
                XLTUpdateMyInviterVC *updateMyInviterVC = [[XLTUpdateMyInviterVC alloc] init];
                [self.rootNavigationController pushViewController:updateMyInviterVC animated:YES];
                return;
            }
        }
        XLTMyTeamVC *vc = [[XLTMyTeamVC alloc] init];
        [self.rootNavigationController pushViewController:vc animated:YES];
    }
}

// 打开收益报表页面
- (void)openIncomeReportWithPage:(NSString *)page paramInfo:(NSDictionary *)param  {
    if (![XLTUserManager shareManager].isLogined) {
        [self openLoginWithPage:page paramInfo:param];
    } else {
        XLTIncomeVC *vc = [[XLTIncomeVC alloc] init];
        [self.rootNavigationController pushViewController:vc animated:YES];
    }
}

// 打开邀请好友页面
- (void)openInvitateWithPage:(NSString *)page paramInfo:(NSDictionary *)param  {
    if (![XLTUserManager shareManager].isLogined) {
        [self openLoginWithPage:page paramInfo:param];
    } else {
        if (![XLTUserManager shareManager].isInvited) {
            if ([XLTAppPlatformManager shareManager].checkEnable) {
                // 邀请页面
                [MBProgressHUD letaoshowTipMessageInWindow:@"请先设置上级邀请码"];
                XLTUpdateMyInviterVC *updateMyInviterVC = [[XLTUpdateMyInviterVC alloc] init];
                [self.rootNavigationController pushViewController:updateMyInviterVC animated:YES];
                return;
            }
        }
        XLTUserInvateVC *vc = [[XLTUserInvateVC alloc] init];
        [self.rootNavigationController pushViewController:vc animated:YES];
    }
}

// 打开我的余额界面
- (void)openSelfBalanceWithPage:(NSString *)page paramInfo:(NSDictionary *)param  {
    if (![XLTUserManager shareManager].isLogined) {
        [self openLoginWithPage:page paramInfo:param];
    } else {
        XLTUserBalanceDrawVC *vc = [[XLTUserBalanceDrawVC alloc] init];
        [self.rootNavigationController pushViewController:vc animated:YES];
    }
}

// 打开我的余额界面
- (void)openBindAlipayWithPage:(NSString *)page paramInfo:(NSDictionary *)param  {
    if (![XLTUserManager shareManager].isLogined) {
        [self openLoginWithPage:page paramInfo:param];
    } else {
        XLTUserBindAliPayVC *vc = [[XLTUserBindAliPayVC alloc] init];
        [self.rootNavigationController pushViewController:vc animated:YES];
    }
}

// 打开提现界面
- (void)openWithDrawWithPage:(NSString *)page paramInfo:(NSDictionary *)param  {
    if (![XLTUserManager shareManager].isLogined) {
        [self openLoginWithPage:page paramInfo:param];
    } else {
        XLTUserWithDrawVC *vc = [[XLTUserWithDrawVC alloc] init];
        [self.rootNavigationController pushViewController:vc animated:YES];
    }
}

// 打开提现界面
- (void)openWithACTActivityWithPage:(NSString *)page paramInfo:(NSDictionary *)param  {
    if (![XLTUserManager shareManager].isLogined) {
        [self openLoginWithPage:page paramInfo:param];
    } else {
        NSString *acCode = param[@"code"];
        if ([acCode isKindOfClass:[NSString class]] && acCode.length > 0) {
            XLTActivityVC *vc = [[XLTActivityVC alloc] init];
            vc.acCode = acCode;
            [self.rootNavigationController pushViewController:vc animated:YES];
        }
    }
}


- (UINavigationController *)rootNavigationController {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *navigationController = (UINavigationController *)delegate.window.rootViewController;
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        return navigationController;
    } else {
        return nil;
    }
}

// 打开登录界面
- (void)openLoginWithPage:(NSString *)page paramInfo:(NSDictionary *)param  {
    if (![XLTUserManager shareManager].isLogined) {
        [[XLTUserManager shareManager] displayLoginViewController];
        self.lastParamInfo = param;
        self.lastPage = page;
        [self showTipMessageIfNeedLoginForPage:page];
    }
}

- (void)showTipMessageIfNeedLoginForPage:(NSString *)page {
    if ([page isKindOfClass:[NSString class]]) {
        if ([page isEqualToString:@"openCategory"]) { // 打开首页分类界面
            
        } else if ([page isEqualToString:@"openVipTab"]) { // 打开会员界面
            [self showTipMessage:@"请先登录，然后打开会员页面"];
        } else if ([page isEqualToString:@"openCommunity"]) { // 打开发圈界面
            [self showTipMessage:@"请先登录，然后打开发圈页面"];
        } else if ([page isEqualToString:@"openUser"]) { //  打开个人中心

        } else if ([page isEqualToString:@"openWebview"]) { //  打开webview页面

        } else if ([page isEqualToString:@"openGoodsDetail"]) { // 打开商品详情页

        } else if ([page isEqualToString:@"openSelfOrder"]) { // 打开我的订单页面
            [self showTipMessage:@"请先登录，然后打开我的订单页面"];
        } else if ([page isEqualToString:@"openGroupOrder"]) { // 打开粉丝订单页面
            [self showTipMessage:@"请先登录，然后打开粉丝订单页面"];
        } else if ([page isEqualToString:@"openMyCollection"]) { // 打开我的收藏页面
            [self showTipMessage:@"请先登录，然后打开我的收藏页面"];
        } else if ([page isEqualToString:@"openMyTeam"]) { //  打开我的粉丝页面
            [self showTipMessage:@"请先登录，然后打开我的粉丝页面"];
        } else if ([page isEqualToString:@"openIncomeReport"]) { // 打开收益报表页面
            [self showTipMessage:@"请先登录，然后打开我的收益页面"];
        } else if ([page isEqualToString:@"openInvitate"]) { // 打开邀请好友页面
            [self showTipMessage:@"请先登录，然后打开我的邀请页面"];
        } else if ([page isEqualToString:@"openSelfBalance"]) { // 打开我的余额界面
            [self showTipMessage:@"请先登录，然后打开我的余额页面"];
        } else if ([page isEqualToString:@"openBindAlipay"]) { // 打开绑定支付宝页面
            [self showTipMessage:@"请先登录，然后绑定支付宝"];
        } else if ([page isEqualToString:@"openWithDraw"]) { // 提现
            [self showTipMessage:@"请先登录，然后打开提现页面"];
        } else if ([page isEqualToString:@"openActivityDetail"]) { // 提现
            [self showTipMessage:@"请先登录，然后打开活动中间页面"];
        }
    }
}
- (void)showTipMessage:(NSString*)message {
    [MBProgressHUD letaoshowTipMessageInWindow:message];
}



/*
page=openApp 打开app
page=openCategory 打开分类界面
page=openVipTab 打开会员界面
page=openCommunity 打开发圈界面
page=openUser 打开个人中心
page=openWebview打开webview页面 参数：url
page=openGoodsDetail 打开商品详情页  参数id:商品id  item_source
page=openSelfOrder 打开我的订单页面
page=openGroupOrder 打开粉丝订单页面
page=openMyCollection 打开我的收藏页面
page=openMyTeam 打开我的粉丝页面
page=openIncomeReport 打开收益报表页面
page=openInvitate 打开邀请好友页面
page=openSelfBalance 打开我的余额界面
page=openBindAlipay 打开绑定支付宝页面

消息协议：
打开app
{"title":"通知栏标题","content":"通知栏内容",page:"openApp"}
比如打开商品详情页
{"title":"通知栏标题","content":"通知栏内容",page:"openGoodsDetail",param:{"id":"","item_source":""}}
*/

- (NSDictionary *)dictionaryWithJSON:(id)json {
    if (!json || json == (id)kCFNull) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    return dic;
}

// 汇报通知点击
- (void)repoOpenRemoteNotificationEvent:(NSString *)notificationId {
    if (notificationId) {
        NSDictionary *parameters = @{@"id":notificationId};
        [XLTNetworkHelper POST:@"/v2/umeng/report" parameters:parameters success:^(id responseObject,NSURLSessionDataTask * task) {
        } failure:^(NSError *error,NSURLSessionDataTask * task) {
        }];
    }
}
@end
