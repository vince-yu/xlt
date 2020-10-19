//
//  XLDGoodsInfoMemberUpgradeCell.h
//  XingLeTao
//
//  Created by chenhg on 2020/1/4.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTGoodsDetailCellsFactory.h"

NS_ASSUME_NONNULL_BEGIN

@class XLDGoodsInfoMemberUpgradeCell;
@protocol XLDGoodsInfoMemberUpgradeCellDelegate <NSObject>
- (void)memberUpgradeCell :(XLDGoodsInfoMemberUpgradeCell * )cell upgradeBtnClicked:(id)sender;
@end

@interface XLDGoodsInfoMemberUpgradeCell : UICollectionViewCell <XLTGoodsDetailCellProtocol>
@property (nonatomic, weak) id<XLDGoodsInfoMemberUpgradeCellDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
