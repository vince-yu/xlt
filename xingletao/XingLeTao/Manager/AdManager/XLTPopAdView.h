//
//  XLTPopAdView.h
//  XingLeTao
//
//  Created by chenhg on 2019/11/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTPopAdView : NSObject
@property (nonatomic, assign) BOOL isZeroBuyAd;
- (void)updateAdInfo:(NSArray *)adArray;
@end

NS_ASSUME_NONNULL_END
