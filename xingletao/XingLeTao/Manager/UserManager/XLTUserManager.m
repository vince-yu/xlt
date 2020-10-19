//
//  XLTUserManager.m
//  XLTUserManager
//
//  Created by chenhg on 2019/4/23.
//  Copyright © 2019 . All rights reserved.
//

#import "XLTUserManager.h"
#import "NSObject+YYModel.h"
#import "XLTNetworkHelper.h"
#import "AppDelegate+Coordinator.h"
#import "XLTUserSettingVC.h"
#import "XLTUserInfoLogic.h"
#import "XLTGoodsDetailVC.h"
#import "XLTWKWebViewController.h"
#import "XLTTabBarController.h"
#import "XLTUPushManager.h"

@implementation XLTUserManager
@synthesize rightModel = _rightModel;

+ (instancetype)shareManager {
    static XLTUserManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadUserInfo];
    }
    return self;
}

- (void)refreshUserInfo {
    if (self.isLogined) {
        [XLTUserInfoLogic xingletaonetwork_requestUserInfoSuccess:^(id balance) {
            
        } failure:^(NSString *errorMsg) {
            
        }];
    }
}

-(void)loginUserInfo:(XLTUserInfoModel *)userInfo {
    if (!self.isLogined) {
        // 回退界面
        [self refreshNavigationController];
    }
    self.curUserInfo = userInfo;
    self.isLogined = YES;
    [self saveUserInfo];
    
    // 设置token
    [XLTNetworkHelper setValue:userInfo.token forHTTPHeaderField:@"Authorization"];
    
    [self refreshUserInfo];
    
    // 汇报事件
    [SDRepoManager xltrepo_trackUserLogin:userInfo._id];
    
    // 设置是新人0元购状态

    [[XLTAppPlatformManager shareManager] needPopContactInstructorState:userInfo.is_new];
}

// 回退界面
- (void)refreshNavigationController {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *navigationController = (UINavigationController *)appDelegate.window.rootViewController;
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        if (navigationController.viewControllers.count > 1) {
            NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithObjects:navigationController.viewControllers.firstObject, nil];
            XLTGoodsDetailVC *vc = navigationController.viewControllers.lastObject;
            // 这些最后一个界面是这种类型保留
            if ([vc isKindOfClass:[XLTGoodsDetailVC class]]
                || [vc isKindOfClass:[XLTWKWebViewController class]]
                || [vc isKindOfClass:[XLTTabBarController class]]) {
                [viewControllers addObject:vc];
            }
            [navigationController setViewControllers:viewControllers animated:YES];
        }
    }
}
/**
 退出登录
  */
- (void)logout {
    [[XLTUPushManager shareManager] removeAliasIfNeed];
    BOOL login = self.isLogined;
    [self clearUserInfo];
    // 清理token
    [XLTNetworkHelper setValue:nil forHTTPHeaderField:@"Authorization"];
    if (login) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kXLTNotifiLogoutSuccess object:nil];
    }
    // 汇报事件
    [SDRepoManager xltrepo_trackUserLogout];
    
    // 清理新人0元购状态
    [[XLTAppPlatformManager shareManager] clearZeroBuyAdInfo];
    [[XLTAppPlatformManager shareManager] needPopContactInstructorState:@0];
}
/**
登录界面是否显示
 */
- (BOOL)isLoginViewControllerDisplay {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate isKindOfClass:[AppDelegate class]]) {
        return (appDelegate.loginNavigationViewController != nil);
    }
    return NO;
}

/**
登录界面
 */
- (void)displayLoginViewController {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate isKindOfClass:[AppDelegate class]]) {
        [appDelegate displayLoginViewController];
    }
}
/**
关闭登录界面
 */
- (void)removeLoginViewController {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate isKindOfClass:[AppDelegate class]]) {
        [appDelegate removeLoginViewController];
    }
}

- (BOOL)isInvited {
    NSNumber *invited = self.curUserInfo.invited;
    if ([invited isKindOfClass:[NSNumber class]]) {
        //         invited:0 为绑定邀请人，1已经绑定
        return [invited boolValue];
    }
    return NO;
}


#pragma mark ————— 储存用户信息 —————

#define kUserInfoCacheKey @"User.kLeTaoUserInfoCacheKey"

static id XLTUserInfoJSONObjectByRemovingKeysWithNullValues(id JSONObject, NSJSONReadingOptions readingOptions) {
    if ([JSONObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[(NSArray *)JSONObject count]];
        for (id value in (NSArray *)JSONObject) {
            [mutableArray addObject:XLTUserInfoJSONObjectByRemovingKeysWithNullValues(value, readingOptions)];
        }

        return (readingOptions & NSJSONReadingMutableContainers) ? mutableArray : [NSArray arrayWithArray:mutableArray];
    } else if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:JSONObject];
        for (id <NSCopying> key in [(NSDictionary *)JSONObject allKeys]) {
            id value = (NSDictionary *)JSONObject[key];
            if (!value || [value isEqual:[NSNull null]]) {
                [mutableDictionary removeObjectForKey:key];
            } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                mutableDictionary[key] = XLTUserInfoJSONObjectByRemovingKeysWithNullValues(value, readingOptions);
            }
        }

        return (readingOptions & NSJSONReadingMutableContainers) ? mutableDictionary : [NSDictionary dictionaryWithDictionary:mutableDictionary];
    }

    return JSONObject;
}
-(void)saveUserInfo {
    if (self.curUserInfo) {
        @try {
            NSDictionary *curUserInfo = [self.curUserInfo modelToJSONObject];
            NSDictionary * userInfo = XLTUserInfoJSONObjectByRemovingKeysWithNullValues(curUserInfo, 0);

            if (userInfo) {
                [[NSUserDefaults standardUserDefaults] setObject:userInfo.copy forKey:kUserInfoCacheKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
        } @catch (NSException *exception) {
            NSLog(@"saveUserInfo exception :%@",exception);
        } @finally {
        }
      
    }
}



#pragma mark ————— 加载缓存的用户信息 —————
-(BOOL)loadUserInfo {
    NSDictionary * curUserInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfoCacheKey];;
    if (curUserInfo) {
        XLTUserInfoModel *userInfo = [XLTUserInfoModel modelWithJSON:curUserInfo];
        if ([userInfo isKindOfClass:[XLTUserInfoModel class]]) {
            if (userInfo._id != nil) {
                self.curUserInfo = userInfo;
                self.isLogined = YES;
                return YES;
            }
        }
    }
    return NO;
}
- (NSString *)currentVipLevelBg{
    if (self.rightModel.list.count < self.rightModel.level.intValue) {
        return nil;
    }
    XLTVipRightItem *item = [self.rightModel.list objectAtIndex:self.rightModel.level.intValue - 1];
    return item.icon;
}
- (XLTVipRightsModel *)rightModel{
    if (_rightModel == nil) {
        _rightModel = [self getCacheWithRightFile];
    }
    return _rightModel;
}
- (void)setRightModel:(XLTVipRightsModel *)rightModel{
    _rightModel = rightModel;
    [self saveRightListToFile:_rightModel];
}
- (void)saveRightListToFile:(id )model{
//    参数:(1)指定文件夹,(2)设置查找域,(3)是否使用详细路径

    NSString*documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject];

//    (2)拼接上要存储的文件路径(前面自动加上/),如果没有此文件系统会自动创建一个

    NSString*newFielPath = [documentsPath stringByAppendingPathComponent:@"right.txt"];

//    (3)将内容存储到指定文件路径

//    NSError*error =nil;

//    字符串写入本地文件参数:(1)要存储内容的文件路径,(2)是否使用原子特性,(3)存储格式
    NSData *data = [model modelToJSONData];
    BOOL isSucceed = [data writeToFile:newFielPath atomically:YES];
    if (!isSucceed) {
        NSLog(@"save right error!");
    }
    
}
- (XLTVipRightsModel *)getCacheWithRightFile{
    NSString*documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject];

    //    (2)拼接上要存储的文件路径(前面自动加上/),如果没有此文件系统会自动创建一个

    NSString*newFielPath = [documentsPath stringByAppendingPathComponent:@"right.txt"];
    NSString *str = [NSString stringWithContentsOfFile:newFielPath encoding:NSUTF8StringEncoding error:nil];
    XLTVipRightsModel *model = [XLTVipRightsModel modelWithJSON:str];
    return model;
}
#pragma mark ————— 清除缓存的用户信息 —————
-(void)clearUserInfo{
    self.curUserInfo = nil;
    self.isLogined = NO;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserInfoCacheKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
