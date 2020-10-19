//
//  XLTHomeKingKongCell.h
//  XingLeTao
//
//  Created by chenhg on 2020/5/18.
//  Copyright © 2020 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTHomeCellsFactory.h"

NS_ASSUME_NONNULL_BEGIN

@class XLTHomeKingKongCell;
@protocol XLTHomeKingKongCellDelegate <NSObject>

- (void)homeKingKongCell:(XLTHomeKingKongCell *)cell  didSelectItem:(NSDictionary *)itemInfo index:(NSInteger )index;

@end

@interface XLTHomeKingKongCell : UICollectionViewCell

- (void)letaoUpdateCellDataWithInfo:(NSArray *)info moduleHeight:(CGFloat)moduleHeight;

@property (nonatomic, weak) id<XLTHomeKingKongCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
