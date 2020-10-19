//
//  XLTHomeTopCollectionViewCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/5.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLTHomeCategoryTopCollectionViewCell;
@protocol XLTHomeCategoryTopCellDelegate <NSObject>

- (void)letaoTopCell:(XLTHomeCategoryTopCollectionViewCell *)cell didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface XLTHomeCategoryTopCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<XLTHomeCategoryTopCellDelegate> delegate;

- (void)letaoUpdateCellDataWithInfo:(NSArray *)info;


@end

NS_ASSUME_NONNULL_END
