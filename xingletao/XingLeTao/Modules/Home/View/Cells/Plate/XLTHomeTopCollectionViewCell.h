//
//  XLTHomeTopCollectionViewCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/5.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLTHomeTopCollectionViewCell;
@protocol XLTPlateTopSectionCellDelegate <NSObject>

- (void)letaoCell:(XLTHomeTopCollectionViewCell *)cell didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface XLTHomeTopCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<XLTPlateTopSectionCellDelegate> delegate;

- (void)letaoUpdateCellDataWithInfo:(NSArray *)info;


@end

NS_ASSUME_NONNULL_END
