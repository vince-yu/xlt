//
//  XLDGoodsStoreRecomendHeaderView.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XLDGoodsStoreRecomendHeaderViewDelegate <NSObject>

- (void)letaoGoStoreAction;

@end

@interface XLDGoodsStoreRecomendHeaderView : UICollectionReusableView
@property (nonatomic, weak) id<XLDGoodsStoreRecomendHeaderViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
