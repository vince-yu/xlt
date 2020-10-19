//
//  XLDGoodsDetailTopMenuView.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/10.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "XLTRecommedFeedLogic.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XLTGoodsRecommendFeedButtonStyle) {
    XLTGoodsRecommendFeedButtonStyle_Hidden = 0,
    XLTGoodsRecommendFeedButtonStyle_Enabled,
    XLTGoodsRecommendFeedButtonStyle_Disabled,
    XLTGoodsRecommendFeedButtonStyle_Recommend,

    XLTGoodsRecommendFeedButtonStyle_Enabled_Gray,
    XLTGoodsRecommendFeedButtonStyle_Disabled_Gray,
    XLTGoodsRecommendFeedButtonStyle_Recommend_Gray,
};



@interface XLDGoodsDetailTopMenuView : UIView
@property (nonatomic, strong) UIButton *letaoLeftButton;
//@property (nonatomic, strong) HMSegmentedControl *letaoSegmentedControl;
@property (nonatomic, strong) UIButton *letaoCollectButton;
@property (nonatomic, strong) UIButton *recommendFeedButton;

@property (nonatomic, assign) XLTGoodsRecommendFeedStyle goodsRecommendFeedStyle;
@property (nonatomic, copy, nullable) NSString *goodsRecommendFeedTipText;

- (void)letaoAdjustMenuStyleWithOffset:(CGPoint)offset;
@end

NS_ASSUME_NONNULL_END

