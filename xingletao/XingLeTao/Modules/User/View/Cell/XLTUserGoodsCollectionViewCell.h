//
//  XLTUserGoodsCollectionViewCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/17.
//  Copyright © 2019 snqu. All rights reserved.
//

#import "XLTHomeCategoryGoodsCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLTUserGoodsCollectionViewCell : XLTHomeCategoryGoodsCollectionViewCell
@property (nonatomic, copy, nullable) void(^letaoCellCoverButtonClicked)(void);
@end

NS_ASSUME_NONNULL_END
