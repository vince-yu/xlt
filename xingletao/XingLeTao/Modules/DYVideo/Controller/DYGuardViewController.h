//
//  DYGuardViewController.h
//  XingLeTao
//
//  Created by chenhg on 2020/5/12.
//  Copyright © 2020 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DYGuardDelegate <NSObject>

- (void)guardShouldDismiss;

@end

@interface DYGuardViewController : XLTBaseViewController
@property (nonatomic, weak) id <DYGuardDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
