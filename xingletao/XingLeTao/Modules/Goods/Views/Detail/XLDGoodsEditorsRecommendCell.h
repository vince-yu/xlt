//
//  XLDGoodsEditorsRecommendCell.h
//  XingLeTao
//
//  Created by chenhg on 2020/7/2.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTGoodsDetailCellsFactory.h"
NS_ASSUME_NONNULL_BEGIN

@interface XLDGoodsEditorsRecommendCell : UICollectionViewCell <XLTGoodsDetailCellProtocol>

+ (CGFloat)cellHeightForRecommendText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
