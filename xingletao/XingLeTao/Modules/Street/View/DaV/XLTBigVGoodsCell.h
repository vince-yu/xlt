//
//  XLTBigVGoodsCell.h
//  XingLeTao
//
//  Created by chenhg on 2019/10/5.
//  Copyright © 2019 snqu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLTBigVGoodsCell;
@protocol XLTBigVGoodsCellDelegate <NSObject>

- (void)letaoMoreBtnClicked:(XLTBigVGoodsCell *)cell;

@end

@interface XLTBigVGoodsCell : UICollectionViewCell
- (void)letaoUpdateCellDataWithInfo:(id _Nullable )itemInfo isLastCell:(BOOL)lastCell;

@property (nonatomic, weak) id<XLTBigVGoodsCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
