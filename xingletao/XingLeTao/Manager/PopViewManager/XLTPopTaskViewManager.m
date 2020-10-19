//
//  XLTPopTaskViewManager.m
//  XingLeTao
//
//  Created by chenhg on 2019/11/13.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTPopTaskViewManager.h"
#import "XLTGoodsInfoAlertVC.h"
#import "XLTPopAdView.h"

@interface XLTPopTaskViewManager ()
@property (nonatomic, strong) NSMutableArray *popedViewArray;
@end

@implementation XLTPopTaskViewManager
+ (instancetype)shareManager {
    static XLTPopTaskViewManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _popedViewArray = [NSMutableArray array];
    }
    return self;
}

- (void)addPopedView:(id)popedView {
    if (popedView) {
        [_popedViewArray addObject:popedView];
    }
}

- (void)removePopedView:(id)popedView {
    if (popedView) {
        [_popedViewArray removeObject:popedView];
    }
}

- (BOOL)havePopedViews {
    return _popedViewArray.count > 0;
}


- (BOOL)havePopedGoodsInfoAlertVC {
    __block  BOOL havePopedGoodsInfo = NO;
    [_popedViewArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isMemberOfClass:[XLTGoodsInfoAlertVC class]]) {
            havePopedGoodsInfo = YES;
            *stop = YES;
        }
    }];
    return havePopedGoodsInfo;
}


// 是否有0元购广告弹窗
- (BOOL)havePopedZeroBuyAd {
    __block  BOOL havePopedZeroBuyAd = NO;
    [_popedViewArray enumerateObjectsUsingBlock:^(XLTPopAdView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isMemberOfClass:[XLTPopAdView class]]) {
            if (obj.isZeroBuyAd) {
                havePopedZeroBuyAd = YES;
                *stop = YES;
            }
        }
    }];
    return havePopedZeroBuyAd;
}

- (void)clearPopedViews {
    [_popedViewArray removeAllObjects];
}

- (void)clearPopedAdView {
    NSMutableArray *popedAdViewArray = [NSMutableArray array];
    [_popedViewArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           if ([obj isMemberOfClass:[XLTPopAdView class]]) {
               [popedAdViewArray addObject:obj];
           }
    }];
    [popedAdViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_popedViewArray removeObject:obj];
    }];
}


@end
