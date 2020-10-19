//
//  XLDGoodsDetailTopMenuView.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/10.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTMallGoodsDetailCustomBar : UIView
@property (nonatomic, strong) UIButton *letaoLeftButton;
@property (nonatomic, strong) UILabel *letaoTitleLabel;

- (void)letaoAdjustMenuStyleWithOffset:(CGPoint)offset;
@end

NS_ASSUME_NONNULL_END
