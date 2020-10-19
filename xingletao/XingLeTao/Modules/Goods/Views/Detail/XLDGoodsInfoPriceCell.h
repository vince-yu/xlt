//
//  XLDGoodsInfoPriceCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTGoodsDetailCellsFactory.h"
#import "SDCycleScrollView.h"
#import "XLDGoodsEarnCollectionViewCell.h"
#import "XLDGoodsInfoMemberUpgradeCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface XLDGoodsInfoPriceCell : UICollectionViewCell <XLTGoodsDetailCellProtocol>
@property (nonatomic, weak) id<XLDGoodsEarnCollectionViewCellDelegate,XLDGoodsInfoMemberUpgradeCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
