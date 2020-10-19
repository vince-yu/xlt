//
//  XLTHotOnlineHeadView.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/1.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTHotOnlineHeadView : UIView
@property (nonatomic, readonly) UIButton *leftButton;
@property (nonatomic, readonly) UIButton *searchButton;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

+ (CGFloat)headViewDefaultHeight;

- (void)letaoSetupSegmentedControl;
@end

NS_ASSUME_NONNULL_END
