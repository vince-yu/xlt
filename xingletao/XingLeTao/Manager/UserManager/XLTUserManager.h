//
//  XLTUserManager.h
//
//  Created by chenhg on 2019/4/23.
//  Copyright © 2019 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLTUserInfoModel.h"
#import "XLTUserCentreVC.h"
#import "XLTVipRightsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTUserManager : NSObject

//当前用户信息
@property (nonatomic, nullable, strong) XLTUserInfoModel *curUserInfo;
//用户权益信息
@property (nonatomic ,nullable ,strong) XLTVipRightsModel *rightModel;
@property (nonatomic ,nullable ,copy) NSString *currentVipLevelBg;
//登录状态
@property (nonatomic, assign) BOOL isLogined;

//是否有邀请人状态
@property (nonatomic, assign) BOOL isInvited;

//注销账号原因
@property (nonatomic ,copy , nullable) NSArray *reasonArray;

//是否是用微信登录
@property (nonatomic ,assign) BOOL isWXLogin;

+ (instancetype)shareManager;

/**
 登录
 
 @param userInfo 登录userInfo
 */
-(void)loginUserInfo:(XLTUserInfoModel *)userInfo;


/**
saveUserInfo
*/
-(void)saveUserInfo;


-(void)refreshUserInfo;

/**
 退出登录
 
 */
- (void)logout;

/**
登录界面
 */
- (void)displayLoginViewController;
/**
关闭登录界面
 */
- (void)removeLoginViewController;

/**
登录界面是否显示
 */
- (BOOL)isLoginViewControllerDisplay;
@end

NS_ASSUME_NONNULL_END
