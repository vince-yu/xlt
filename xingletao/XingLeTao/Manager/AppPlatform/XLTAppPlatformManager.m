//
//  XLTAppPlatformManager.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/1.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTAppPlatformManager.h"
#import "XLTQRCodeScanLogic.h"
#import "XLTGoodsInfoAlertVC.h"
#import "XLTGoodsDetailLogic.h"
#import "AppDelegate+Coordinator.h"
#import "XLTNetworkHelper.h"
#import "UIViewController+XLTPresent.h"
#import "XLTAlertViewController.h"
#import "XLTHomePageLogic.h"
#import "XLTPopTaskViewManager.h"
#import "XLTUserManager.h"
#import "XLTUserTipMessageView.h"
#import "XLTGoodsSearchReultVC.h"
#import "XLTSearchViewController.h"
#import "XLTGoodsSearchPopVC.h"
#import "XLTAppVersionsUpdateManager.h"
#import "XLTThridPartyManager.h"
#import "XLTUserTaskManager.h"
#import "XLTNavigationController.h"
#import "XLTWKWebViewController.h"
#import "XLTUserInviteVC.h"

@interface XLTAppPlatformManager ()<XLTUserTipMessageViewDelegate>

@property (nonatomic, strong) XLTQRCodeScanLogic *letaoQRCodeLogic;
@property (nonatomic, strong) XLTGoodsDetailLogic *goodDetailLogic;
@property (nonatomic ,strong) XLTUserTipMessageView *binWXView;
@property (nonatomic, strong) NSArray *xinletaoWebDomainList;

@property (nonatomic ,strong) XLTUserInviteVC *inviteVC;

@end

@implementation XLTAppPlatformManager

+ (instancetype)shareManager {
    static XLTAppPlatformManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isLimitModel = NO;
        _checkEnable = [self localCheckEnableStaus];
        
        _goodsPlatformConfigInfo = [self lastSupportGoodsPlatformValue];
        // 设置suportPlatformInfo
        [self reloadSuportPlatformInfo];
        
        _serverType = XLTAppPlatformServerReleaseType;
        _letaoPasteboardChangeCount = [self fetchPasteboardChangeCount];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(pasteboardChangedNotification:)
         name:UIPasteboardChangedNotification
         object:nil];
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(pasteboardChangedNotification:)
         name:UIPasteboardRemovedNotification
         object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];

        // 注册shareManager
        [XLTAppVersionsUpdateManager shareManager];

    }
    return self;
}

- (void)checkPasteboardGoodsInfo {
    if (![self isPLZLTop]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        NSInteger changeCount = pasteboard.changeCount;
        NSString *result = [pasteboard.string copy];
        if ([result isKindOfClass:[NSString class]] && result.length > 0) {
            if (changeCount != self.letaoPasteboardChangeCount) {
                [self checkPasteboardGoodsWithText:result];
            }
        }
    }
}

// 批量转链接
- (BOOL)isPLZLTop {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    XLTWKWebViewController *web = appDelegate.mainNavigationController.viewControllers.lastObject;
    if ([web isKindOfClass:[XLTWKWebViewController class]]) {
        return ([web.jump_URL containsString:kXLTZhuanLianH5Url]);
    }
    return NO;
}


- (void)applicationWillResignActive:(NSNotification*)notification {
    [self savePasteboardChangeCount];
    [self saveSupportGoodsPlatformValue];
}

- (void)pasteboardChangedNotification:(NSNotification*)notification {
    UIPasteboard *pasteboard = [notification object];
    if ([pasteboard isKindOfClass:[UIPasteboard class]]
        && [pasteboard.name isEqualToString:UIPasteboardNameGeneral]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.letaoPasteboardChangeCount = pasteboard.changeCount;
        });
    }
}

- (void)xingletaonetwork_requestConfig {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self xingletaonetwork_requestLimitModelStatus:nil];
        [self requestXinletaoWebDomain];
    });
}


- (void)setServerType:(XLTAppPlatformServerType)serverType {
    _serverType = serverType;
    
    [XLTNetworkHelper setBaseUrl:[self baseApiSeverUrl]];
}

- (NSString *)baseH5SeverUrl {
    if (self.serverType == XLTAppPlatformServerTestType) {
        return kXLTTestH5SeverUrl;
    } else if (self.serverType == XLTAppPlatformServerBetaType) {
        return kXLTPreProductH5SeverUrl;
    }  else  {
        return kXLTProductH5SeverUrl;
    }
}

- (NSString *)baseACH5SeverUrl {
    if (self.serverType == XLTAppPlatformServerTestType) {
        return kXLTTestACH5SeverUrl;
    } else if (self.serverType == XLTAppPlatformServerBetaType) {
        return kXLTPreProductACH5SeverUrl;
    }  else  {
        return kXLTProductACH5SeverUrl;
    }
}

- (NSString *)baseApiSeverUrl {
    if (self.serverType == XLTAppPlatformServerTestType) {
        return kXLTTestApiSeverUrl;
    } else if (self.serverType == XLTAppPlatformServerBetaType) {
        return kXLTPreProductApiSeverUrl;
    }  else {
        return kXLTProductApiSeverUrl;
    }
}


- (NSString *)repoApiSeverUrl {
    if (self.serverType == XLTAppPlatformServerTestType) {
        return kXLTTestRepoSeverUrl;
    } else if (self.serverType == XLTAppPlatformServerBetaType) {
        return kXLTPreProductRepoSeverUrl;
    }  else {
        return kXLTProductRepoSeverUrl;
    }
}

- (NSString *)appVersion {
    static NSString *appVersion = nil;
    if (appVersion == nil) {
        appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    }
    return [appVersion copy];
}

- (void)checkPasteboardGoodsWithText:(NSString *)result {
    if (self.letaoQRCodeLogic == nil) {
        self.letaoQRCodeLogic = [[XLTQRCodeScanLogic alloc] init];
    }
    __weak typeof(self) weakSelf = self;
    if (result.length < 1001) {
        // 调用goods/de-code接口解析
        [self.letaoQRCodeLogic decodeResultForCodeText:result success:^(XLTBaseModel *model) {
            [weakSelf letaoDidDecodedGoods:model scanText:result];
        } failure:^(NSString * _Nonnull errorMsg) {
            [weakSelf letaoDidDecodedGoodsFailure:errorMsg scanText:result];
        }];
    }
}


#define kGoodPasteboardKey @"AppPlatformManager.kGoodPasteboardKey"
#define kPasteboardChangeCount @"AppPlatformManager.kPasteboardChangeCount"

- (NSString *)lastGoodsPasteboardValue {
    NSString *lastPasteboardValue = [[NSUserDefaults standardUserDefaults] objectForKey:kGoodPasteboardKey];
    if ([lastPasteboardValue isKindOfClass:[NSString class]]) {
        return lastPasteboardValue;
    }
    return nil;
}

- (void)saveGoodsPasteboardValue:(NSString *)string {
    if (string) {
        [[NSUserDefaults standardUserDefaults] setObject:string forKey:kGoodPasteboardKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)savePasteboardChangeCount {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:self.letaoPasteboardChangeCount] forKey:kPasteboardChangeCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)fetchPasteboardChangeCount {
    NSNumber *letaoPasteboardChangeCount = [[NSUserDefaults standardUserDefaults] objectForKey:kPasteboardChangeCount];
    if ([letaoPasteboardChangeCount isKindOfClass:[NSNumber class]]) {
        return [letaoPasteboardChangeCount integerValue];
    } else {
        return 0;
    }
}


- (void)letaoDidDecodedGoods:(XLTBaseModel *)model scanText:(NSString *)scanText{
    if ([model.xlt_rcode isKindOfClass:[NSString class]]
        || [model.xlt_rcode isKindOfClass:[NSNumber class]]) {
        NSDictionary *result = model.data;
        NSString *need_search = result[@"need_search"];
        NSString *item_source = result[@"item_source"];
        BOOL needSearch = ([need_search isKindOfClass:[NSNumber class]] && [need_search boolValue]);
        if ([model.xlt_rcode integerValue] == 0) {
            NSString *goodsId = result[@"goods_id"];
            if ([goodsId isKindOfClass:[NSString class]] && goodsId.length > 0) {
                [self letaoNeedPopGoodsViewController:result];
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = @"";
                
                //汇报
                NSMutableDictionary *dic = @{}.mutableCopy;
                dic[@"good_id"] = [SDRepoManager repoResultValue:result[@"_id"]];
                dic[@"good_name"] = [SDRepoManager repoResultValue:result[@"item_title"]];
                NSString *paste_content = [UIPasteboard generalPasteboard].string;
                dic[@"paste_content"] = [SDRepoManager repoResultValue:paste_content];
                dic[@"xlt_item_search_keyword"] = [SDRepoManager repoResultValue:scanText];
                dic[@"xlt_item_source"] = [SDRepoManager repoResultValue:result[@"item_source"]];
                dic[@"xlt_item_firstcate_title"] = @"null";
                dic[@"xlt_item_thirdcate_title"] = @"null";
                dic[@"xlt_item_secondcate_title"] = @"null";
                [SDRepoManager xltrepo_trackEvent:XLT_EVENT_POPUP properties:dic];
                
            }
        } else if ([model.xlt_rcode integerValue] == 502) {
            NSString *messageString = nil;
            if ([model.message isKindOfClass:[NSString class]] && model.message.length > 0) {
                messageString = model.message;
            } else {
                messageString = @"暂无该商品";
            }
            XLTAlertViewController *alertViewController = [[XLTAlertViewController alloc] init];
            [alertViewController letaoPresentWithSourceVC:[UIApplication sharedApplication].keyWindow.rootViewController title:@"提示" message:messageString messageTextAlignment:NSTextAlignmentCenter sureButtonText:@"知道了" cancelButtonText:nil];
            // 更新changeCount不在提示
            self.letaoPasteboardChangeCount = [UIPasteboard generalPasteboard].changeCount;

        } else if (needSearch) {
            // 搜索弹窗
            [self letaoNeedPopSearchViewControllerWithScanText:scanText item_source:item_source];
            // 更新changeCount不在提示
            self.letaoPasteboardChangeCount = [UIPasteboard generalPasteboard].changeCount;
        } else {
            // do nothing
        }
        
        if ([model.xlt_rcode integerValue] != 0) {
            [[XLTRepoDataManager shareManager] umeng_repoPasteboardError:scanText failureCode:model.xlt_rcode];
        }
    }
}

- (void)letaoDidDecodedGoodsFailure:(NSString * _Nonnull)errorMsg scanText:(NSString *)scanText {
    // do nothing
    [[XLTRepoDataManager shareManager] umeng_repoPasteboardError:scanText failureCode:nil];
}

- (void)letaoPopGoodsViewController:(NSDictionary *)goodsDetail {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate isKindOfClass:[AppDelegate class]]) {
        if ([appDelegate.window.rootViewController isKindOfClass:[UIViewController class]]) {
            XLTGoodsInfoAlertVC *goodsPopViewController = [[XLTGoodsInfoAlertVC alloc] init];
            [goodsPopViewController letaoPresentWithSourceVC:appDelegate.window.rootViewController itemInfo:goodsDetail];
            [[XLTPopTaskViewManager shareManager] clearPopedViews];
            [[XLTPopTaskViewManager shareManager] addPopedView:goodsPopViewController];
            
            // 汇报剪贴板商品任务完成
            [[XLTUserTaskManager shareManager] letaoRepoPasteboardTaskInfo];
        }
    }
}

- (void)letaoNeedPopGoodsViewController:(NSDictionary *)goodsDetail  {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate isKindOfClass:[AppDelegate class]]) {
        if ([appDelegate.window.rootViewController isKindOfClass:[UIViewController class]]) {
            if (appDelegate.window.rootViewController.presentedViewController != nil) {
                [appDelegate.window.rootViewController dismissViewControllerAnimated:NO completion:^{
                    [self letaoPopGoodsViewController:goodsDetail];
                }];
            } else {
                [self letaoPopGoodsViewController:goodsDetail];
            }
        }
    }
}

- (void)letaoPopSearchViewControllerWithScanText:(NSString *)scanText item_source:(NSString *)item_source {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate isKindOfClass:[AppDelegate class]]) {
        if ([appDelegate.window.rootViewController isKindOfClass:[UIViewController class]]) {
            XLTGoodsSearchPopVC *popViewController = [[XLTGoodsSearchPopVC alloc] init];
            __weak typeof(self)weakSelf = self;
            popViewController.popViewControllerSearchAction = ^(NSString *searchText) {
                 [weakSelf startSearchWithScanText:searchText item_source:item_source];
             };
            [popViewController presentWithSourceViewController:appDelegate.window.rootViewController searchText:scanText];
            [[XLTPopTaskViewManager shareManager] clearPopedViews];
            [[XLTPopTaskViewManager shareManager] addPopedView:popViewController];
            
            // 汇报剪贴板商品任务完成
            [[XLTUserTaskManager shareManager] letaoRepoPasteboardTaskInfo];
        }
    }
}

- (void)letaoNeedPopSearchViewControllerWithScanText:(NSString *)scanText item_source:(NSString *)item_source {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate isKindOfClass:[AppDelegate class]]) {
        if ([appDelegate.window.rootViewController isKindOfClass:[UIViewController class]]) {
            if (appDelegate.window.rootViewController.presentedViewController != nil) {
                [appDelegate.window.rootViewController dismissViewControllerAnimated:NO completion:^{
                    [self letaoPopSearchViewControllerWithScanText:scanText item_source:item_source];
                }];
            } else {
                [self letaoPopSearchViewControllerWithScanText:scanText item_source:item_source];
            }
        }
    }
}

- (void)startSearchWithScanText:(NSString *)scanText item_source:(NSString *)item_source{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate isKindOfClass:[AppDelegate class]]) {
        UINavigationController *navigationController = (UINavigationController *)appDelegate.window.rootViewController;
        if ([navigationController isKindOfClass:[UINavigationController class]]) {
            NSMutableArray *viewControllers = navigationController.viewControllers.mutableCopy;
            XLTSearchViewController *searchViewController = [[XLTSearchViewController alloc] init];
            searchViewController.letaoPasteboardSearchText = scanText;
            searchViewController.item_source = item_source;
            [viewControllers addObject:searchViewController];
            
            XLTGoodsSearchReultVC *reultViewController = [[XLTGoodsSearchReultVC alloc] init];
            reultViewController.pasteboardSearchText = scanText;
            reultViewController.letaoSearchText = scanText;
            reultViewController.item_source = item_source;
            [viewControllers addObject:reultViewController];
                        
            [navigationController setViewControllers:viewControllers animated:YES];
            [[XLTRepoDataManager shareManager] repoSearchActionWithKeyword:scanText];
        }
    }

}

// 订单分享提示

#define kOrderShareTipSwitch @"AppPlatformManager.kOrderShareTipSwitch"

- (BOOL)isOrderShareTipSwitchOff {
    NSNumber *off = [[NSUserDefaults standardUserDefaults] objectForKey:kOrderShareTipSwitch];
    return ([off isKindOfClass:[NSNumber class]] && [off boolValue]);
}

- (void)orderShareTipSwitchOff:(BOOL)off {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:off] forKey:kOrderShareTipSwitch];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 订单分享提示


#define kLocalCheckEnableKey @"AppPlatformManager.kLocalCheckEnableKey"

- (void)setCheckEnable:(BOOL)checkEnable {
    if (_checkEnable != checkEnable) {
        _checkEnable = checkEnable;
        [self saveCheckEnableStaus:checkEnable];
//        if (checkEnable) {
//            [XLTNetworkHelper setValue:@"0" forHTTPHeaderField:@"check-enable"];
//        } else {
//            [XLTNetworkHelper setValue:@"1" forHTTPHeaderField:@"check-enable"];
//        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kLetaoCheckEnableChangedNotification object:nil];
       
    }
}

- (BOOL)localCheckEnableStaus {
    NSNumber *status = [[NSUserDefaults standardUserDefaults] objectForKey:kLocalCheckEnableKey];
    if (![status isKindOfClass:[NSNumber class]]) {
        return NO;
    } else {
        return ([status isKindOfClass:[NSNumber class]] && [status boolValue]);
    }
}

- (void)saveCheckEnableStaus:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:status] forKey:kLocalCheckEnableKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)xingletaonetwork_requestLimitModelStatus:(nullable void(^)(void))completeBlock{
    [XLTNetworkHelper GET:kClientVersionStateUrl parameters:nil success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
                NSNumber *enable = model.data[@"enable"];
                if ([enable isKindOfClass:[NSNumber class]]) {
                    
                    self.checkEnable = (self.debugModel ? YES : [enable boolValue]);
                    [self palyTeachingVideoIfNeed];
                    [self showbindWXTipViewIfNeed];
                    if (completeBlock) {
                        completeBlock();
                    }
                }
            }
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
    }];
}


- (void)requestXinletaoWebDomain {
    [XLTNetworkHelper GET:@"config/safe-domain" parameters:nil responseCache:^(id responseCache) {
        if ([responseCache isKindOfClass:[NSDictionary class]]) {
            NSDictionary *cacheInfo = responseCache;
            NSArray *xinletaoWebDomainList = cacheInfo[@"data"];
            if ([xinletaoWebDomainList isKindOfClass:[NSArray class]] && xinletaoWebDomainList.count > 0) {
                self.xinletaoWebDomainList = xinletaoWebDomainList;
            }
        }
    } success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSArray class]]) {
                self.xinletaoWebDomainList = model.data;
            }
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
    }];
}

- (BOOL)isXinletaoWebDomain:(NSString *)webDomain {
    __block BOOL isXinletaoWebDomain = NO;
    if ([self.xinletaoWebDomainList isKindOfClass:[NSArray class]] && self.xinletaoWebDomainList.count > 0) {
        [self.xinletaoWebDomainList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSString class]] && [webDomain isKindOfClass:[NSString class]]) {
                if ([webDomain containsString:obj]) {
                    isXinletaoWebDomain = YES;
                    *stop = YES;
                }
            }
        }];
    }
    return isXinletaoWebDomain;
}

- (BOOL)isXinletaoSafeWebDomain:(NSString *)webDomain {
    if ([self.xinletaoWebDomainList isKindOfClass:[NSArray class]] && self.xinletaoWebDomainList.count > 0) {
        return [self isXinletaoWebDomain:webDomain];
    } else {
        return YES;
    }
}

- (void)showbindWXTipViewIfNeed {
    if (self.checkEnable
        && [XLTUserManager shareManager].curUserInfo
        &&![XLTUserManager shareManager].curUserInfo.wechat_info.boolValue
        && ![XLTAppPlatformManager shareManager].debugModel
        //&& ![XLTUserManager shareManager].isLoginViewControllerDisplay
        ) {
           // 正常并且登录了
        if (_binWXView == nil) {
            _binWXView = [[XLTUserTipMessageView alloc] initWithNib];
            _binWXView.delegate = (id)self;
            _binWXView.type = XLTUserTipTypeBindWeiXin;
        }
        [_binWXView show];
    } else {
        [self.binWXView dissMiss];
//        [self showbindInviterVC];
    }
}
- (void)showbindInviterVC{
    if (self.checkEnable
            && [XLTUserManager shareManager].isLogined
            &&![XLTUserManager shareManager].curUserInfo.invited.boolValue
            &&![XLTUserManager shareManager].curUserInfo.canSkipInvited.boolValue
//            && [XLTAppPlatformManager shareManager].debugModel
            && ![XLTUserManager shareManager].isLoginViewControllerDisplay) {
        if (_inviteVC == nil) {
            _inviteVC = [[XLTUserInviteVC alloc] init];
            _inviteVC.isAlter = YES;
        }
        [_inviteVC show];
        
    }else{
        [_inviteVC dissMiss];
    }
}
- (NSString *)platformText:(NSString *)text {
    if ([text isKindOfClass:[NSString class]]) {
        return text;
    } else {
        return nil;
    }
}

/*
- (void)xingletaonetwork_requestIcon11Status {
    [XLTNetworkHelper GET:kIcon11StatusUrl parameters:nil success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
                NSNumber *logo = model.data[@"logo"];
                if ([logo isKindOfClass:[NSNumber class]] || [logo isKindOfClass:[NSString class]]) {
                    if ([logo integerValue] == 1) {
//                        [self changeAppIconName:@"appIcon11"];
                    } else if ([logo integerValue] == 2) {
                        [self changeAppIconName:@"appIcon12"];
                    }  else {
                        [self changeAppIconName:nil];
                    }
                }
            }
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
    }];
}

- (void)changeAppIconName:(NSString * _Nullable)iconName {
    if (@available(iOS 10.3, *)) {
        if ([UIApplication sharedApplication].alternateIconName == iconName
            || [[UIApplication sharedApplication].alternateIconName isEqualToString:iconName]) {
            // do nothing
        } else {
            if ([[UIApplication sharedApplication] supportsAlternateIcons]) {
                [[UIApplication sharedApplication] setAlternateIconName:iconName completionHandler:^(NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"更换app图标发生错误了 ： %@",error);
                    }
                }];
            }
        }

    }
}*/
#pragma mark UserTipMessageViewDelegate
- (void)userTipMessageViewDiDDissMiss {
    self.binWXView = nil;
}

#pragma mark - 商品支持平台

- (void)requestSupportGoodsPlatform {
    [XLTNetworkHelper GET:kSupportGoodsPlatformUrl parameters:nil success:^(id responseObject,NSURLSessionDataTask * task) {
        if(responseObject != nil) {
            XLTBaseModel *model = [XLTBaseModel automaticParserDataWithJSON:responseObject];
            if ([model isCorrectCode] && [model.data isKindOfClass:[NSDictionary class]]) {
                if (![self.goodsPlatformConfigInfo isEqualToDictionary:model.data]) {
                    self.goodsPlatformConfigInfo = model.data;
                }
            }
        }
    } failure:^(NSError *error,NSURLSessionDataTask * task) {
    }];
}

// 商品平台
#define kSupportGoodsPlatformConfig @"AppPlatformManager.kSupportGoodsPlatformConfig"
- (NSDictionary *)lastSupportGoodsPlatformValue {
    NSDictionary *supportGoodsPlatform = [[NSUserDefaults standardUserDefaults] objectForKey:kSupportGoodsPlatformConfig];
    if ([supportGoodsPlatform isKindOfClass:[NSDictionary class]]) {
        return supportGoodsPlatform;
    }
    return nil;
}

- (void)saveSupportGoodsPlatformValue {
    @try {
        NSDictionary * supportGoodsPlatformInfo = XLTAppPlatformJSONObjectByRemovingKeysWithNullValues(self.goodsPlatformConfigInfo, 0);
        [[NSUserDefaults standardUserDefaults] setObject:supportGoodsPlatformInfo forKey:kSupportGoodsPlatformConfig];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)setGoodsPlatformConfigInfo:(NSDictionary *)goodsPlatformConfigInfo {
    if (_goodsPlatformConfigInfo != goodsPlatformConfigInfo) {
        _goodsPlatformConfigInfo = goodsPlatformConfigInfo;
        [self saveSupportGoodsPlatformValue];
        // 设置suportPlatformInfo
        [self reloadSuportPlatformInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kSupportGoodsPlatformValueNotification" object:nil];
    }
}

- (void)reloadSuportPlatformInfo {
    // 设置suportPlatformInfo
    NSMutableDictionary *suportPlatformInfo = [NSMutableDictionary dictionary];
    if ([self.goodsPlatformConfigInfo isKindOfClass:[NSDictionary class]]) {
        [self.goodsPlatformConfigInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSArray * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSArray class]]) {
                [obj enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull platformInfo, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([platformInfo isKindOfClass:[NSDictionary class]]) {
                        NSString *name = platformInfo[@"name"];
                        NSString *code = platformInfo[@"code"];
                        if (name && code) {
                            suportPlatformInfo[code] = name;
                        }
                    }
                }];
               
            }
        }];
    }
    self.suportPlatformInfo = suportPlatformInfo;
}


static id XLTAppPlatformJSONObjectByRemovingKeysWithNullValues(id JSONObject, NSJSONReadingOptions readingOptions) {
    if ([JSONObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[(NSArray *)JSONObject count]];
        for (id value in (NSArray *)JSONObject) {
            [mutableArray addObject:XLTAppPlatformJSONObjectByRemovingKeysWithNullValues(value, readingOptions)];
        }

        return (readingOptions & NSJSONReadingMutableContainers) ? mutableArray : [NSArray arrayWithArray:mutableArray];
    } else if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:JSONObject];
        for (id <NSCopying> key in [(NSDictionary *)JSONObject allKeys]) {
            id value = (NSDictionary *)JSONObject[key];
            if (!value || [value isEqual:[NSNull null]]) {
                [mutableDictionary removeObjectForKey:key];
            } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                mutableDictionary[key] = XLTAppPlatformJSONObjectByRemovingKeysWithNullValues(value, readingOptions);
            }
        }

        return (readingOptions & NSJSONReadingMutableContainers) ? mutableDictionary : [NSDictionary dictionaryWithDictionary:mutableDictionary];
    }

    return JSONObject;
}


/**
*  首页支持商品平台
*  @param position   1:首页，2：分平台搜索，3：订单中心，4：收益表报、我的收益
*  @return 返回的支持商品平台对象(NSDictionary)，
*/
- (NSArray *)supportGoodsPlatformArrayForPosition:(NSString *)position {
    if ([position isKindOfClass:[NSString class]]) {
        return [self.goodsPlatformConfigInfo objectForKey:position];
    } else {
         return @[];
    }
}

/**
*  首页支持商品平台
*
*  @return 返回的支持商品平台对象(NSDictionary)，
*/
- (NSArray *)supportGoodsPlatformArrayForHome {
    return [self supportGoodsPlatformArrayForPosition:@"1"];
}

/**
*  订单中心支持商品平台
*
*  @return 返回的支持商品平台对象(NSDictionary)，
*/

- (NSArray *)supportGoodsPlatformArrayForOrder {
    return [self supportGoodsPlatformArrayForPosition:@"3"];
}


/**
*  搜索支持商品平台
*
*  @return 返回的支持商品平台对象(NSDictionary)，
*/

- (NSArray *)supportGoodsPlatformArrayForSearch {
    return [self supportGoodsPlatformArrayForPosition:@"2"];
}


/**
*  收益表报、我的收益支持商品平台
*
*  @return 返回的支持商品平台对象(NSDictionary)，
*/

- (NSArray *)supportGoodsPlatformArrayForMyIncome {
    return [self supportGoodsPlatformArrayForPosition:@"4"];
}



- (NSString *)letaoSourceTextForType:(NSString *)type {
    if ([type isKindOfClass:[NSString class]] && [self.suportPlatformInfo isKindOfClass:[NSDictionary class]]) {
        NSString *sourceText = self.suportPlatformInfo[type];
        if ([sourceText isKindOfClass:[NSString class]] && sourceText.length > 0) {
            return sourceText;
        } else {
            return [self letaoSourceLocalTextForType:type];
        }
    }
    return nil;
}


#define kPlatformTaobao @"淘宝"
#define kPlatformTmao @"天猫"
#define kPlatformJdong @"京东"
#define kPlatformpPdduoduo @"拼多多"
#define kPlatformVpinghui @"唯品会"
#define kPlatformTyou @"加油"
#define kPlatformSuning @"苏宁"
- (NSString *)letaoSourceLocalTextForType:(NSString *)type {
    if ([type isKindOfClass:[NSString class]]) {
        if ([type isEqualToString:XLTTaobaoPlatformIndicate]) {
            return [[XLTAppPlatformManager shareManager] platformText:kPlatformTaobao];
        } else if ([type isEqualToString:XLTTianmaoPlatformIndicate]) {
            return [[XLTAppPlatformManager shareManager] platformText:kPlatformTmao];
        } else if ([type isEqualToString:XLTJindongPlatformIndicate]) {
            return [[XLTAppPlatformManager shareManager] platformText:kPlatformJdong];
        } else if ([type isEqualToString:XLTPDDPlatformIndicate]) {
            return [[XLTAppPlatformManager shareManager] platformText:kPlatformpPdduoduo];
        } else if ([type isEqualToString:XLTVPHPlatformIndicate]) {
            return [[XLTAppPlatformManager shareManager] platformText:kPlatformVpinghui];
        } else if ([type isEqualToString:XLTCZBPlatformIndicate]) {
            return [[XLTAppPlatformManager shareManager] platformText:kPlatformTyou];
        } else if ([type isEqualToString:XLTSuNingPlatformIndicate]) {
            return [[XLTAppPlatformManager shareManager] platformText:kPlatformSuning];
        }
    }
    return nil;
}

#define kDidPalyTeachingVideo @"AppPlatformManager.kDidPalyTeachingVideo"

- (BOOL)isDidPalyTeachingVideo {
    NSNumber *off = [[NSUserDefaults standardUserDefaults] objectForKey:kDidPalyTeachingVideo];
    return ([off isKindOfClass:[NSNumber class]] && [off boolValue]);
}

- (void)didPalyTeachingVideo:(BOOL)flag {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:flag] forKey:kDidPalyTeachingVideo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#define kXLTInstalledFlag @"AppPlatformManager.kXLTInstalledFlag"

- (BOOL)isFristInstall {
//    return YES;
    NSNumber *isInstalledFlag = [[NSUserDefaults standardUserDefaults] objectForKey:kXLTInstalledFlag];
    BOOL isFristInstall = !([isInstalledFlag isKindOfClass:[NSNumber class]] && [isInstalledFlag boolValue]);
    if (isFristInstall) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kXLTInstalledFlag];
            [[NSUserDefaults standardUserDefaults] synchronize];
        });
    }

    return isFristInstall;
}

#pragma mark -  获取平台来源分享模板

/*
static id XLTSONObjectByRemovingKeysWithNullValues(id JSONObject, NSJSONReadingOptions readingOptions) {
    if ([JSONObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[(NSArray *)JSONObject count]];
        for (id value in (NSArray *)JSONObject) {
            [mutableArray addObject:XLTSONObjectByRemovingKeysWithNullValues(value, readingOptions)];
        }

        return (readingOptions & NSJSONReadingMutableContainers) ? mutableArray : [NSArray arrayWithArray:mutableArray];
    } else if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:JSONObject];
        for (id <NSCopying> key in [(NSDictionary *)JSONObject allKeys]) {
            id value = (NSDictionary *)JSONObject[key];
            if (!value || [value isEqual:[NSNull null]]) {
                [mutableDictionary removeObjectForKey:key];
            } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                mutableDictionary[key] = XLTSONObjectByRemovingKeysWithNullValues(value, readingOptions);
            }
        }

        return (readingOptions & NSJSONReadingMutableContainers) ? mutableDictionary : [NSDictionary dictionaryWithDictionary:mutableDictionary];
    }

    return JSONObject;
}*/

#define kUserAgreementKey @"AppPlatformManager.kUserAgreementKey"

- (BOOL)isAgreedUserAgreement {
    NSNumber *isAgreedFlag = [[NSUserDefaults standardUserDefaults] objectForKey:kUserAgreementKey];
    BOOL isAgreed = ([isAgreedFlag isKindOfClass:[NSNumber class]] && [isAgreedFlag boolValue]);
    return isAgreed;
}

- (void)agreedUserAgreement:(BOOL)flag {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:flag] forKey:kUserAgreementKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#define kLocalZeroBuyAddDateInfo @"AppPlatformManager.kLocalZeroBuyAddDateInfo"

- (void)clearZeroBuyAdInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLocalZeroBuyAddDateInfo];
}

- (BOOL)todayZeroBuyAdShowState {
    NSNumber *timeIntervalNumber = [[NSUserDefaults standardUserDefaults] objectForKey:kLocalZeroBuyAddDateInfo];
    if ([timeIntervalNumber isKindOfClass:[NSNumber class]]) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeIntervalNumber longLongValue]];
        return [date isToday];
    }
    return NO;
}

- (void)makeLocalZeroBuyAddDateInfo {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedLongLong:[[NSDate date] timeIntervalSince1970]] forKey:kLocalZeroBuyAddDateInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#define kNeedPopContactInstructorKey @"AppPlatformManager.kNeedPopContactInstructorKey"
- (BOOL)isNeedPopContactInstructor {
    NSNumber *isNeedPopFlag = [[NSUserDefaults standardUserDefaults] objectForKey:kNeedPopContactInstructorKey];
    BOOL isNeedPop = ([isNeedPopFlag isKindOfClass:[NSNumber class]] && [isNeedPopFlag integerValue] >= 2);
    return isNeedPop;
}

- (void)needPopContactInstructorState:(NSNumber *)state {
    if ([state isKindOfClass:[NSNumber class]]) {
        [[NSUserDefaults standardUserDefaults] setObject:state forKey:kNeedPopContactInstructorKey];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
}

- (void)increasePopContactInstructorCountIfNeed {
    NSNumber *isNeedPopFlag = [[NSUserDefaults standardUserDefaults] objectForKey:kNeedPopContactInstructorKey];
    BOOL canIncrease = ([isNeedPopFlag isKindOfClass:[NSNumber class]] && [isNeedPopFlag boolValue]);
    if (canIncrease) {
        NSUInteger contactInstructorCount = 1;
        contactInstructorCount += [isNeedPopFlag integerValue];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedInteger:contactInstructorCount] forKey:kNeedPopContactInstructorKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)palyTeachingVideoIfNeed {
   /*
    if (self.debugModel) {
        return;
    }
    if (_checkEnable && [XLTThridPartyManager shareManager].registerForRemoteNotificationscompled) {
        if (![self isDidPalyTeachingVideo]) {
            [self didPalyTeachingVideo:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                if ([appDelegate isKindOfClass:[AppDelegate class]]) {
                    [appDelegate displayVideoNavigationViewController];
                    [[XLTPopTaskViewManager shareManager] clearPopedAdView];
                }
            });
        }
    }*/
}


@end
