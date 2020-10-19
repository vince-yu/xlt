//
//  XLDGoodsCouponCollectionViewCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTGoodsDetailCellsFactory.h"
NS_ASSUME_NONNULL_BEGIN

@class XLDGoodsCouponCollectionViewCell;
@protocol XLDGoodsCouponCollectionViewCellDelegate <NSObject>
@required
- (void)letaoIsCoupon:(XLDGoodsCouponCollectionViewCell * )cell xingletaonetwork_requestCouponBtnClicked:(id)sender;
@end

@interface XLDGoodsCouponCollectionViewCell : UICollectionViewCell <XLTGoodsDetailCellProtocol>
@property (nonatomic, weak) id<XLDGoodsCouponCollectionViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
