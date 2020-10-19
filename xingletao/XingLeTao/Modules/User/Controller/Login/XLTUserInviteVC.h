//
//  XLTUserInviteVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/10.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN


@class XLTUserInfoModel;
@interface XLTUserInviteVC : XLTBaseViewController

@property (nonatomic, strong) XLTUserInfoModel *userInfo;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *verificationCode;
@property (nonatomic ,assign) BOOL isAlter;
@property (nonatomic, assign) BOOL canSkip;
- (void)show;
- (void)dissMiss;
@end

NS_ASSUME_NONNULL_END
