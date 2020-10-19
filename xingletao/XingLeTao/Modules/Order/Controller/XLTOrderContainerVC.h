//
//  XLTOrderContainerVC.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/18.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTBaseViewController.h"
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTOrderContainerVC : XLTBaseViewController
@property (nonatomic, assign) NSUInteger letaoDefaultSelectedIndex;
@property (nonatomic, assign) BOOL letaoIsGroupStyle;
@property (nonatomic, strong) JXPagerView *letaoJXPagerView;
@property (nonatomic, copy, nullable) NSString *letaoYearMonthText;
@end

NS_ASSUME_NONNULL_END
