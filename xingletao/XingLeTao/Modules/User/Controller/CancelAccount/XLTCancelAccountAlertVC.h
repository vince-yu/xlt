//
//  XLTCancelAccountAlertVC.h
//  XingLeTao
//
//  Created by chenhg on 2020/6/5.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTCancelAccountAlertVC : XLTBaseViewController
@property (nonatomic ,copy) void(^cancelBlock)(void);
@property (nonatomic ,copy) void(^dismisBlock)(void);
@end

NS_ASSUME_NONNULL_END
