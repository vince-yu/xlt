//
//  XLDGoodsEarnCollectionViewCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/8.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTGoodsDetailCellsFactory.h"
NS_ASSUME_NONNULL_BEGIN


@protocol XLDGoodsEarnCollectionViewCellDelegate <NSObject>

- (void)letaoIsQuestionButtonClicked;

@end


@interface XLDGoodsEarnQuestionButton : UIButton

@end

@interface XLDGoodsEarnCollectionViewCell : UICollectionViewCell <XLTGoodsDetailCellProtocol>
@property (nonatomic, weak) id<XLDGoodsEarnCollectionViewCellDelegate> delegate;
- (void)adjustStyleForisLetaoHighCommission:(BOOL)letaoHighCommission;
@end

NS_ASSUME_NONNULL_END
