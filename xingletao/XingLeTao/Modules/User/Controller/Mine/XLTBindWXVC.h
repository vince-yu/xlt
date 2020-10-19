//
//  XLTBindWXVC.h
//  XingLeTao
//
//  Created by vince on 2020/2/14.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XLTBindWXDelegate <NSObject>

- (void)reloadSettingVC;

@end

@interface XLTBindWXVC : XLTBaseViewController
@property (nonatomic ,weak) id<XLTBindWXDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
