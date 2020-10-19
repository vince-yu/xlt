//
//  MBProgressHUD+TipView.h
//  ShopAnalytics
//
//  Created by chenhg on 2019/4/24.
//  Copyright © 2019  . All rights reserved.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (QQWTipView)

+ (void)letaoshowTipMessageInWindow:(NSString*)message;

+ (void)letaoshowTipMessageInWindow:(NSString*)message hideAfterDelay:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END
