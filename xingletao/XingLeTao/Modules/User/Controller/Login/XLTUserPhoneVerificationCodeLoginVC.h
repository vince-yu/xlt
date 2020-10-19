//
//  XLTUserPhoneVerificationCodeLoginVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/9/30.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTUserPhoneVerificationCodeLoginVC : XLTBaseViewController
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSNumber *invitedFlag;
@property (nonatomic, assign) BOOL canSkipInvited;
@property (nonatomic, assign) BOOL isNewUser;


@end

NS_ASSUME_NONNULL_END
