//
//  XLDGoodsDetailTopMenuView.m
//  XingLeTao
//
//  Created by chenhg on 2019/10/10.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLDGoodsDetailTopMenuView.h"
#import "XLTUIConstant.h"
#import "UIColor+Helper.h"

@interface XLDGoodsDetailTopMenuView ()

@property (nonatomic, strong) UILabel *letaoCustomTitleLabel;
@property (nonatomic, assign) XLTGoodsRecommendFeedButtonStyle recommendFeedButtonStyle;

@end

@implementation XLDGoodsDetailTopMenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSDictionary *dict = @{NSForegroundColorAttributeName : [UIColor colorWithHex:0xff333333],
                               NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:18.0]
        };
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"商品详情" attributes:dict];
        
        CGFloat titleLabelWidth = 170;
        _letaoCustomTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ceilf((self.bounds.size.width - titleLabelWidth)/2), kStatusBarHeight, titleLabelWidth, 44)];
        _letaoCustomTitleLabel.userInteractionEnabled = YES;
        _letaoCustomTitleLabel.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
        _letaoCustomTitleLabel.attributedText = title;
        _letaoCustomTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_letaoCustomTitleLabel];
        
        
        _letaoLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _letaoLeftButton.frame = CGRectMake(5, kStatusBarHeight, 44, 44);
        [self addSubview:_letaoLeftButton];
        
        _letaoCollectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _letaoCollectButton.frame = CGRectMake(self.bounds.size.width - 44 -5, kStatusBarHeight, 44, 44);
        [self.letaoCollectButton setImage:[UIImage imageNamed:@"tabBar_collect_highlight"] forState:UIControlStateSelected];

        [self addSubview:_letaoCollectButton];
        
        
        _recommendFeedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _recommendFeedButton.frame = CGRectMake(_letaoCollectButton.frame.origin.x - 44, kStatusBarHeight, 44, 44);
        _recommendFeedButton.hidden = YES;
        [self addSubview:_recommendFeedButton];
        
        
//
//        [self letaoSetupSegmentedControl];
    }
    return self;
}

/*
- (void)letaoSetupSegmentedControl {
    // 配置`菜单视图`
    CGFloat segmentedControlWidth = 170;
    _letaoSegmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(ceilf((self.bounds.size.width - segmentedControlWidth)/2), CGRectGetMinY((self.letaoLeftButton.frame)) +10, segmentedControlWidth, 30)];
    _letaoSegmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _letaoSegmentedControl.backgroundColor = [UIColor clearColor];
    _letaoSegmentedControl.selectionIndicatorHeight = 1.0;
    _letaoSegmentedControl.type = HMSegmentedControlTypeText;
    _letaoSegmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    _letaoSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _letaoSegmentedControl.selectionIndicatorColor = [UIColor letaomainColorSkinColor];
    _letaoSegmentedControl.userDraggable = NO;
    _letaoSegmentedControl.titleTextAttributes = @{NSFontAttributeName: [UIFont letaoRegularFontWithSize:15.0], NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF333333]};
    _letaoSegmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName: [UIFont letaoMediumBoldFontWithSize:15.0], NSForegroundColorAttributeName:[UIColor letaomainColorSkinColor]};
    _letaoSegmentedControl.sectionTitles = @[@"商品",@"详情", @"推荐"];
    [self addSubview:_letaoSegmentedControl];
}
*/

#define kTopOffset 44
- (void)letaoAdjustMenuStyleWithOffset:(CGPoint)offset {
    if (offset.y < kTopOffset) {
        CGFloat alpha = 1.f - offset.y / kTopOffset;
        self.alpha = alpha;
        [self.letaoLeftButton setImage:[UIImage imageNamed:@"xinletao_gooddetail_graybackground_back"] forState:UIControlStateNormal];
        [self.letaoCollectButton setImage:[UIImage imageNamed:@"goods_nav_collect_graybg"] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
//        self.letaoSegmentedControl.hidden = YES;
        self.letaoCustomTitleLabel.hidden = YES;
        self.recommendFeedButtonStyle = (NSInteger )self.goodsRecommendFeedStyle;
    } else {
        CGFloat alpha = MIN(1.f, (offset.y - kTopOffset) / 100.f);
        self.alpha = alpha;
        [self.letaoLeftButton setImage:[UIImage imageNamed:@"xinletao_nav_left_back_gray"] forState:UIControlStateNormal];
        [self.letaoCollectButton setImage:[UIImage imageNamed:@"goods_nav_collect_gray"] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:alpha];
//        self.letaoSegmentedControl.hidden = NO;
        self.letaoCustomTitleLabel.hidden = NO;
        if (self.goodsRecommendFeedStyle == XLTGoodsRecommendFeedStyle_Hidden) {
            self.recommendFeedButtonStyle = XLTGoodsRecommendFeedButtonStyle_Hidden;
        } else {
            self.recommendFeedButtonStyle = (self.goodsRecommendFeedStyle + 3);
        }
    }
}

- (void)setRecommendFeedButtonStyle:(XLTGoodsRecommendFeedButtonStyle)recommendFeedButtonStyle {
    _recommendFeedButtonStyle = recommendFeedButtonStyle;
    
    self.recommendFeedButton.hidden = (recommendFeedButtonStyle <= XLTGoodsRecommendFeedButtonStyle_Hidden);
    switch (recommendFeedButtonStyle) {
        case XLTGoodsRecommendFeedButtonStyle_Enabled: {
            [_recommendFeedButton setImage:[UIImage imageNamed:@"goods_nav_recommend_enabled_graybg"] forState:UIControlStateNormal];
        } break;
        case XLTGoodsRecommendFeedButtonStyle_Disabled: {
            [_recommendFeedButton setImage:[UIImage imageNamed:@"goods_nav_recommend_disabled_graybg"] forState:UIControlStateNormal];
        } break;
        case XLTGoodsRecommendFeedButtonStyle_Recommend: {
            [_recommendFeedButton setImage:[UIImage imageNamed:@"goods_nav_recommend_graybg"] forState:UIControlStateNormal];
        } break;
        case XLTGoodsRecommendFeedButtonStyle_Enabled_Gray: {
            [_recommendFeedButton setImage:[UIImage imageNamed:@"goods_nav_recommend_enabled_gray"] forState:UIControlStateNormal];
        } break;
        case XLTGoodsRecommendFeedButtonStyle_Disabled_Gray: {
            [_recommendFeedButton setImage:[UIImage imageNamed:@"goods_nav_recommend_disabled_gray"] forState:UIControlStateNormal];
        } break;
        case XLTGoodsRecommendFeedButtonStyle_Recommend_Gray: {
            [_recommendFeedButton setImage:[UIImage imageNamed:@"goods_nav_recommend_gray"] forState:UIControlStateNormal];
        } break;
            
        default:
            break;
    }
}

@end
