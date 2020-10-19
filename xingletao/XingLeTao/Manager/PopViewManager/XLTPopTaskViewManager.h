//
//  XLTPopTaskViewManager.h
//  XingLeTao
//
//  Created by chenhg on 2019/11/13.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTPopTaskViewManager : NSObject

+ (instancetype)shareManager;

- (void)addPopedView:(id)popedView;

- (void)removePopedView:(id)popedView;

// 是否有弹窗（广告+0元购广告弹窗+剪贴板弹窗）
- (BOOL)havePopedViews;

// 是否有商品弹窗（剪贴板弹窗）
- (BOOL)havePopedGoodsInfoAlertVC;

// 是否有0元购广告弹窗
- (BOOL)havePopedZeroBuyAd;

- (void)clearPopedViews;
- (void)clearPopedAdView;

@end

NS_ASSUME_NONNULL_END
